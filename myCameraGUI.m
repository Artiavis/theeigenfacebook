function varargout = myCameraGUI(varargin)
% MYCAMERAGUI MATLAB code for mycameragui.fig
%      MYCAMERAGUI, by itself, creates a new MYCAMERAGUI or raises the existing
%      singleton*.
%
%      H = MYCAMERAGUI returns the handle to a new MYCAMERAGUI or the handle to
%      the existing singleton*.
%
%      MYCAMERAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MYCAMERAGUI.M with the given input arguments.
%
%      MYCAMERAGUI('Property','Value',...) creates a new MYCAMERAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before myCameraGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to myCameraGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mycameragui

% Last Modified by GUIDE v2.5 04-Dec-2013 22:36:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @myCameraGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @myCameraGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before mycameragui is made visible.
function myCameraGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mycameragui (see VARARGIN)

% Choose default command line output for mycameragui
clc
handles.output = hObject;

global faces;
if exist('faces.mat','file')
    load('faces.mat')
else
    faces = cell(0);
    save('faces.mat','faces');      % save database
end

% Create video object
% Putting the object into manual trigger mode and then
% starting the object will make GETSNAPSHOT return faster
% since the connection to the camera will already have
% been established.
OS = computer();
switch OS
    case 'PCWIN64' % windows
        try
            handles.video = videoinput('winvideo', 1, 'YUY2_640x480');
        catch
            handles.video = videoinput('winvideo', 1);
        end
    case 'MACI64'  % mac    
        handles.video = videoinput('macvideo',1); % add resolution! (need to call "imaqtool" on mac)
    otherwise      % sorry linux   
        disp('error - operating system')
end

global xRes;
global yRes;
Res = handles.video.VideoResolution;
xRes = Res(1);
yRes = Res(2);


set(handles.video,'TimerPeriod', 0.1, ...
'ReturnedColorspace', 'grayscale', ...
'TimerFcn',['if(~isempty(gco)),'...
'handles=guidata(gcf);'... % Update handles
'imshow(fliplr(getsnapshot(handles.video)));'... % Get picture using GETSNAPSHOT and put it into axes using IMAGE'hold on;'...
'set(handles.cameraAxes,''ytick'',[],''xtick'',[]),'... % Remove tickmarks and labels that are inserted when using IMAGE
'global xRes;'...
'global yRes;'...
'hold on;'...
'plot(handles.cameraAxes,xRes/2,yRes/2,''ro'',''MarkerSize'',yRes/4);'...
'else '...
'delete(imaqfind);'... % Clean up - delete any image acquisition objects
'end']);
triggerconfig(handles.video,'manual');
handles.video.FramesPerTrigger = Inf; % Capture frames until we manually stop it

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mycameragui wait for user response (see UIRESUME)
uiwait(handles.myCameraGUI);


% --- Outputs from this function are returned to the command line.
function varargout = myCameraGUI_OutputFcn(hObject, eventdata, handles)
% varargout cell array for returning output args (see VARARGOUT);
% hObject handle to figure
% eventdata reserved - to be defined in a future version of MATLAB
% handles structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
handles.output = hObject;
varargout{1} = handles.output;


% --- Executes on button press in signInUser.
function signInUser_Callback(hObject, eventdata, handles)
name = inputdlg('Enter your name to sign in:'); % get name to search database
name = lower(name); % only use lowercase names

if isempty(name) % if 'cancel'
    return
end

while strcmp(name,'')
   name = inputdlg('Enter your name to sign in:'); % get name to search database
   name = lower(name); % only use lowercase names
end

load faces.mat; % load database
for userNum = 1:length(faces) % check each database entry for name
   if strcmp(faces{userNum}.Name, name)
       msgbox('Ok you''re signed in!');
       break;
   end
   
   if userNum == length(faces)
       msgbox('You''re not in the database!');
       return
   end
end

set(handles.newUser,'Enable','Off');
set(handles.detectUser,'Enable','Off');

global userObj;
userObj = faces{userNum};
set(handles.startStopCamera,'Enable','On');

% --- Executes on button press in detectUser.
function detectUser_Callback(hObject, eventdata, handles)
set(handles.newUser,'Enable','off');
set(handles.signInUser,'Enable','off');
set(handles.recognizeFace,'Enable','on');
strng = sprintf('Click [???] when ready');
msgbox(strng);
set(handles.takePhoto,'Visible','on');
startCamera(handles);


% --- Executes when user attempts to close myCameraGUI.
function myCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% Hint: delete(hObject) closes the figure
delete(hObject);
delete(imaqfind);


% --- Executes on button press in newUser.
function newUser_Callback(hObject, eventdata, handles)
name = inputdlg('Enter your name:');
name = lower(name); % only use lowercase names
if isempty(name)
    return
end

load faces.mat; % load database
for userNum = 1:length(faces) % check each database entry for name
   if strcmp(faces{userNum}.Name, name)
       msgbox('Username already exists');
       return;
   end
end

set(handles.takePhoto,'Enable','on');

% initialize EigenFace object for user
global userObj;
userObj = EigenFace(name);
strng = sprintf('Click [Take Photo] when ready, %s',name{1});
msgbox(strng);
set(handles.takePhoto,'Visible','on');
startCamera(handles);

% --- Executes on button press in takePhoto.
function takePhoto_Callback(hObject, eventdata, handles)
frame = getsnapshot(handles.video);
set(handles.statusText,'String','Photo taken');
global faces;
global userObj;

% only run for a new user
if isempty(userObj.Photos)
    stopCamera(handles);
    set(handles.takePhoto,'Enable','off');
    set(handles.statusText,'String','Successfully added to the database');
    numUsers = length(faces);    % find number of users
    userObj.UserId = numUsers + 1;
    faces{numUsers + 1} = userObj; % add new user to database
end

im = imresize(frame,[480 640]); % resize image
disp(userObj.UserId)
faces{userObj.UserId} = faces{userObj.UserId}.addPhoto(im);
save('faces.mat','faces');      % save database

function startCamera(handles)
start(handles.video);

function stopCamera(handles)
stop(handles.video)


% --------------------------------------------------------------------
function Menu_File_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Menu_View_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Menu_Exit_Callback(hObject, eventdata, handles)


function recognizeFace_Callback(hObject, eventdata, handles)
set(handles.recognizeFace,'Enable','off');
stopCamera(handles);
% do some stuff
set(handles.newUser,'Enable','on');
set(handles.signInUser,'Enable','on');

function startStopCamera_Callback(hObject, eventdata, handles)
if strcmp(get(handles.startStopCamera,'String'),'Start Camera')
    % camera is off
    set(handles.startStopCamera,'String','Stop Camera');
    start(handles.video);
    set(handles.takePhoto,'Enable','On');
else
    set(handles.startStopCamera,'String','Start Camera');
    stop(handles.video);
    set(handles.takePhoto,'Enable','Off');
end
