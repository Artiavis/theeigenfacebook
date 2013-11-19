% Cory Pisano - November 19, 2013 
%
% Code to interface with webcam, using MATLAB's "Image Acquisition Toolbox"
% Starts webcam (which has small warm up period), displays real time
% preview of webcam data, and takes snapshot when input is entered. 
%
% commands for webcam characterization: imaqtool, imaqhwinfo

clear all; close all; clc

% get operating system information and start webcam
OS = computer();
switch OS
    case 'PCWIN64' % windows
        vid = videoinput('winvideo', 1, 'YUY2_320x240');
    case 'MACI64'  % mac    
        vid = videoinput('macvideo',1); % add resolution! (need to call "imaqtool" on mac)
    otherwise      % sorry linux   
        disp('error - operating system')
end

% set webcam parameters
vid.FramesPerTrigger = 1; 
vid.ReturnedColorspace = 'rgb'; % return type. maybe we only need grayscale?

preview(vid); % show real time webcam data

% wait for input, should be changed to a button press in GUI
input('Any input to take snapshot:  ','s');

image = getsnapshot(vid); % take snapshot
imshow(image);
title('Snap shot result');

% clean up after image capture
stoppreview(vid);
closepreview(vid);

