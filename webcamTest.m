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
        %vid = videoinput('winvideo', 1, 'YUY2_320x240');
        vid = videoinput('winvideo', 1);
    case 'MACI64'  % mac    
        vid = videoinput('macvideo',1); % add resolution! (need to call "imaqtool" on mac)
    otherwise      % sorry linux   
        disp('error - operating system')
end

% set webcam parameters
vid.FramesPerTrigger = 1; 
vid.ReturnedColorspace = 'rgb'; % return type. maybe we only need grayscale?

% get webcam parameters
xRes = vid.VideoResolution
yRes = xRes(2);
xRes = xRes(1);
xCenter = xRes/2;
yCenter = yRes/2;

% display webcam with smiley overlay for alignment
hImage = imshow(zeros(yRes,xRes)); % create figure handle
preview(vid, hImage);              % show real time webcam data
hold on;                           % plot face on top the preview

% just a placeholder face for now...
smiley.eyes = [xCenter-0.07*xRes yCenter-0.1*yRes; ...
               xCenter+0.07*xRes yCenter-0.1*yRes];  
smiley.mouth_x = (xCenter-0.1*xRes):(xCenter+0.1*xRes);
smiley.mouth_y = (yCenter+0.1*yRes)*ones(1,length(smiley.mouth_x));
plot(smiley.eyes(:,1),smiley.eyes(:,2),'ro','MarkerSize',7);
plot(smiley.mouth_x,smiley.mouth_y,'r');
title('Please align your face with the smiley :|');

% wait for input, should be changed to a button press in GUI
input('Any input to take snapshot:  ','s');

image = getsnapshot(vid); % take snapshot
imshow(image);
title('Snap shot result');

% clean up after image capture
stoppreview(vid);
closepreview(vid);

