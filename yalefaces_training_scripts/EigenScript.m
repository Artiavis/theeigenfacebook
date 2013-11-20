allextensions = {'centerlight', 'glasses', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink' };
bestextensions = {'happy', 'noglasses', 'normal', 'sad', 'sleepy', 'surprised', 'wink' };

noglassesextensions = {'centerlight', 'happy', 'leftlight', 'noglasses', 'normal', 'rightlight', 'sad', 'sleepy', 'surprised', 'wink' };

lightextensions = {'centerlight', 'leftlight', 'normal', 'rightlight' };
expressionextensions = {'happy', 'normal', 'sad', 'sleepy', 'surprised', 'wink' };

extensions = allextensions;

clear train;
clear test;
clear M;

%First, extract the faces into training and test faces
trainidx = 1;
testidx = 1;

for i = 1:length(Faces),
    for j = 1:length(extensions);
        X = double(Faces(i).(extensions{j}));

        if( rand > 0.3 )
            train(trainidx).data = X;
            trainidx = trainidx + 1;
        else
            test(testidx).data = X;
            testidx = testidx + 1;
        end;
        
    end;
end;

%Take the average of the training faces
avg = meanface(train);

%Put all of the training faces into one big matrix and do svd
idx = 1;
for i = 1:length(train),
    X = double(train(i).data);
    W = X - avg;

    M(:, idx) = W(:);
    idx = idx + 1;
end;

[U, W, V] = svd(M,0);

Result = U * W * V';

%Show the variance produced by the top eigenvectors
cvalues = zeros(1,size(W,1)-3);
cvalues(1) = W(1,1);
valsum = W(1,1);
for i = 2:length(cvalues);
    cvalues(i) = cvalues(i-1) + W(i,i);
    valsum = valsum + W(i,i);
end;
cvalues = cvalues / valsum;
figure;
set(gcf, 'Name', 'Eigenvalue Variance');
plot(cvalues);
fprintf('10 PC Variance: %f\n25 PC Variance %f\n', cvalues(10), cvalues(25));
    
    
%Show the top k eigenfaces
k = 25;
dim = ceil(sqrt(k));
eigenfaceFigure = figure;
axis off;
for i = 1:k,
    tightsubplot(dim, i, reshape(U(:,i), size(avg)));
end;
colormap(gray);
set(gcf, 'Name', 'Top 25 Eigenfaces');

%Pick a random sample of the training input and reconstruct
reconstructFigure = figure;
axis off;
set(gcf, 'Name', 'Reconstruction using 25 eigenfaces');
idx = 1;
reconstruct = zeros(size(avg));
for i = 1:25
    
    %reconstruct = reconstruct + reshape( V(idx, i) * W(i,i) * U(:,idx), size(avg) );

%     WRecon = zeros(size(W));
%     WRecon(1:i, 1:i) = W(1:i, 1:i);
%     reconstruct = U * WRecon * V';

    reconstruct = U(:,1:i) * W(1:i,1:i) * V(:,1:i)';
    
    recon = reshape( reconstruct(:,1), size(avg) ) + avg;

    tightsubplot( 5, idx, recon );
    idx = idx + 1;
    
    imagesc(recon);
    colormap(gray);
    axis off;
    drawnow;
    
end;


%Put all of the training faces into one big matrix and project
idx = 1;
for i = 1:length(test),
    X = double(test(i).data);
    Wh = X - avg;

    T(:, idx) = Wh(:);
    idx = idx + 1;
end;

%For each test example, find best match in training data
%trainweights = W(1:k,:)*V(:, 1:k)';
clear trainweights;
clear distances;
for i = 1:length(train)
    trainweights(:,i) = U(:,1:k)' * M(:,i);
end;

recognitionFigure = figure;
axis off;
colormap(gray);
set(gcf, 'Name', 'Recognition Results');

idx = 1;
for i = 1:length(test)

    testweights = U(:,1:k)' * T(:,i);
    
    for j = 1:length(train),
        distances(j) = sum((trainweights(:,j) - testweights(:)).^2);
    end;
        
    [val, best] = min(distances);
    
    tightsubplot(8, idx, test(i).data ); 
    
    axis off;
    tightsubplot(8, idx+1, train(best).data ); axis off;
    idx = idx + 2;
    
    %subplot(1,2,1); imagesc(test(i).data);
    %subplot(1,2,2); imagesc(train(best).data);
    drawnow;
end;

% %Now load three images and project them to both the eigenfaces,
% % and to the orthogonal complement
%  nonfaces = {'face.gif', 'face2.gif', 'nonface1.jpg', 'nonface2.jpg', 'nonface3.jpg'};
% for j=1:length(nonfaces),
%     face = double(imread(nonfaces{j}));
%     faceweights = U(:,1:k)' * face(:);
%     
%     reconstruct = U(:,1:k) * faceweights(:) + avg(:);
%     reconstruct = reshape(reconstruct, [199, 199]);
%     
%     figure;
%     imagesc(reconstruct);
%     
%     recon2 = face - reconstruct;
%     
%     normA = norm(face - reconstruct)
%     normB = norm(face - recon2);
%     
%     ratio = normA / normB;
%     
%     %diff1 = sqrt((face(:) - reconstruct(:)) .^2);
%     %diff2 = sqrt((face(:) - (face(:) - reconstruct(:))) .^ 2);
%     fprintf('Ratio: %d\n' , ratio);
% %    fprintf('Distance to reconstruction: %f, Distance to complement: %f \n', diff1, diff2);
%     
% end;


