function varargout = eigenfacebook(varargin)
% EIGENFACEBOOK MATLAB code for eigenfacebook.fig
%      EIGENFACEBOOK, by itself, creates a new EIGENFACEBOOK or raises the existing
%      singleton*.
%
%      H = EIGENFACEBOOK returns the handle to a new EIGENFACEBOOK or the handle to
%      the existing singleton*.
%
%      EIGENFACEBOOK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EIGENFACEBOOK.M with the given input arguments.
%
%      EIGENFACEBOOK('Property','Value',...) creates a new EIGENFACEBOOK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eigenfacebook_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eigenfacebook_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eigenfacebook

% Last Modified by GUIDE v2.5 19-Nov-2013 15:14:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eigenfacebook_OpeningFcn, ...
                   'gui_OutputFcn',  @eigenfacebook_OutputFcn, ...
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


% --- Executes just before eigenfacebook is made visible.
function eigenfacebook_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eigenfacebook (see VARARGIN)

% Choose default command line output for eigenfacebook
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eigenfacebook wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eigenfacebook_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in saveFaceButton.
function saveFaceButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveFaceButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in signInButton.
function signInButton_Callback(hObject, eventdata, handles)
% hObject    handle to signInButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
