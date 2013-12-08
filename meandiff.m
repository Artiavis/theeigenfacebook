function [ eMeanDiffUnrolled ] = meandiff( pictures )
%MEANDIFF Extract the cell-array of length L containing M by N images into
% a M*N by L matrix, computes the difference between that matrix and its
% own mean, and returns.

%   Example?

% Ignore this, use cellfun instead
    % Unwrap images into columns of a matrix
    imgUnroll = zeros(numel(pictures{1}{:}), length(pictures));
    for index=1:length(pictures)
       imgUnroll(:,index) = reshape(pictures{index}{:},[1 numel(pictures{index}{:})]); 
    end

    % Compute and subtract the mean of those images
    eMeanDiffUnrolled = imgUnroll - repmat(mean(imgUnroll, 2), [1 length(pictures)]);

end

