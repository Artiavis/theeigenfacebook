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

% Last Modified by GUIDE v2.5 01-Dec-2013 21:42:07

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
handles.output = hObject;

global faces;
if exist('faces.mat','file')
    load('faces.mat')
else
    faces = cell(0);
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
'hImage = imshow(fliplr(getsnapshot(handles.video)));'... % Get picture using GETSNAPSHOT and put it into axes using IMAGE'hold on;'...
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


% --- Executes on button press in captureImage.
function captureImage_Callback(hObject, eventdata, handles)
% hObject    handle to captureImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% frame = getsnapshot(handles.video);
frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
save('testframe.mat', 'frame');
disp('Frame saved to file ''testframe.mat''');

global faces;
numImages = length(faces);
faces{numImages+1} = frame;
save('faces.mat','faces');
disp('Your face was saved to the database.');

% --- Executes on button press in startAcquisition.
function startAcquisition_Callback(hObject, eventdata, handles)
% hObject    handle to startAcquisition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Start/Stop acquisition
if strcmp(get(handles.startAcquisition,'String'),'Start Acquisition')
    % Camera is not acquiring. Change button string and start acquisition.
    set(handles.startAcquisition,'String','Stop Acquisition');
    trigger(handles.video);
else
    % Camera is acquiring. Stop acquisition, save video data,
    % and change button string.
    stop(handles.video);
    disp('Saving captured video...');
    
    videodata = getdata(handles.video);
    save('testvideo.mat', 'videodata');
    disp('Video saved to file ''testvideo.mat''');
    
    start(handles.video); % Restart the camera
    set(handles.startAcquisition,'String','Start Acquisition');
end

% --- Executes when user attempts to close myCameraGUI.
function myCameraGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to myCameraGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);
delete(imaqfind);


% --- Executes on button press in newUser.
function newUser_Callback(hObject, eventdata, handles)
% hObject    handle to newUser (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
name = inputdlg('Enter your name');
if isempty(name)
    return
end
global userObj;
userObj = EigenFace(name);
strng = sprintf('Please allign your face with the displayed circle and say cheese, %s!',name{1});
msgbox(strng);
set(handles.captureFace,'Visible','on');
startCamera(handles);

% --- Executes on button press in captureFace.
function captureFace_Callback(hObject, eventdata, handles)
% hObject    handle to captureFace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%frame = get(get(handles.cameraAxes,'children'),'cdata'); % The current displayed frame
frame = getsnapshot(handles.video);
stopCamera(handles);
im = imresize(frame,[480 640]);

global faces;
global userObj;
userObj = userObj.addPhoto(im);
numUsers = length(faces);
faces{numUsers+1} = userObj;
save('faces.mat','faces');
set(handles.statusText,'String','Successfully added to the database');
set(handles.captureFace,'Visible','off');

function startCamera(handles)
start(handles.video);

function stopCamera(handles)
stop(handles.video)
