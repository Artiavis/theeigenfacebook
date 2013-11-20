%F = function centerfaces(F, windowX, windowY)
function F = centerfaces(F, windowX, windowY)

if( nargin < 2 )
    windowX = 80;
    windowY = 80;
end;

fields = fieldnames(F);

for i = 1:length(F),
    for j = 1:length(fields);
        X = F(i).(fields{j});
        
        figure(1);
        truesize;
        imagesc(X);
        colormap(Gray);
        
        while(1),
            [y x ] = ginput(1);
            if( x > windowX && x < size(X,1) - windowX && ...
                y > windowY && y < size(X,2) - windowY )
                break;
            else
                fprintf('Error, point (%d %d) with window size %d too close to edge', x, y, windowX);
            end;
        end;
        
        x = round(x);
        y = round(y);
        
        Y = X( x - windowX + 1: x + windowX - 1, y - windowY + 1 : y + windowY - 1 );        
        figure(2);
        imagesc(Y);
        truesize;
        drawnow;
        
        F(i).(fields{j}) = Y;
    end;
end;


