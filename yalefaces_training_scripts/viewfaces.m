function viewfaces(faces)
extensions = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink' };
if( nargin < 1 )
    faces = Faces;
end;

faceviewer = figure;
imagesc(faces(1).(extensions{1}));
drawnow;

row = 1;
col = 1;

while(1)
    waitforbuttonpress;
    key = double(get(gcf, 'CurrentCharacter'));
    if( key == 30 ) %up
        if( row > 1 )
            row = row - 1;
        else
            continue;
        end;
        
    elseif( key == 31 ) %down
        if( row < length(faces) )
            row = row + 1;
        else
            continue;
        end;
        
    elseif( key == 28 ) %left
        if( col > 1 )
            col = col - 1;
        else
            continue;
        end;      
        
    elseif( key == 29 ) %right
        if( col < length(extensions) )
            col = col + 1;
        else
            continue;
        end;      
                
    elseif( key == 27 ) %esc
        break;
        
    else
        continue;
    end;
    
    imagesc(faces(row).(extensions{col}));
    set(gcf, 'Name', sprintf('Person %d/%d, Pose %d/%d (%s)', ...
        row, length(faces), col, length(extensions), extensions{col}));
    drawnow;
end;

