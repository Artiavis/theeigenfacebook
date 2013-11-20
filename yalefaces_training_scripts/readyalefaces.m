function F = readyalefaces()

extensions = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink' };

for i = 1 : 15,
    basename = fullfile('yalefaces','subject');
    if( i < 10 )
        basename = [basename, '0', num2str(i)];
    else
        basename = [basename, num2str(i)];
    end;

    for j = 1:length(extensions),
        fullname = [basename, '.', extensions{j}];
        X = imread(fullname);
        F(i).(extensions{j}) = X;
    end;

end;
