function [ im2 ] = fliprgblr( im )
%FLIPRGBLR Summary of this function goes here
%   Detailed explanation goes here
    %[m,n,o] = size(im);
    %im2 = zeros(m,n,3);
    im2(:,:,1) = fliplr(im(:,:,1));
    im2(:,:,2) = fliplr(im(:,:,2));
    im2(:,:,3) = fliplr(im(:,:,3));
end

