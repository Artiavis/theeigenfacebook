function [ M, U ] = eigenmyfaces( pictures )
%EIGENMYFACES Turns a cell array of images into an eigenface reference
%   Given a cell array of images of constant and fixed dimensions,
%   EIGENMYFACES will unwrap the images into a single, large matrix, and
%   then perform Single-Value Decomposition on them to extract the
%   Eigenfaces of the data set. The returned values are the mean-difference
%   matrix M, and the eigenvectors matrix U.

%   You need u for recognition, but not v.
    
    M = meandiff(pictures);
    
    % Peform Single-Value Decomposition
    [U, s, v] = svd(M,0);
%     eMeanDiffUnrolled2 = U * W * V';
    
end

