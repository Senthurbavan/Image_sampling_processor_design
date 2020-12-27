
close all 
clear all


img256 = imread('testpat1.png');
img256  = uint8(img256);
[m,n] = size(img256); 
 
im_paded = zeros(m+2,n+2);
img_sampled = zeros(m/2,n/2);

for i=1:m
    im_paded(i+1,:) = [img256(i,1),img256(i,:),img256(i,n)];
end
im_paded(1,:) = im_paded(2,:);
im_paded(m+2,:) = im_paded(m+1,:);

%im_paded  = uint8(im_paded);

for i=1:m/2
    for j=1:n/2
        img_sampled(i,j) = floor((1/16)*(1*im_paded(2*i-1,2*j-1)+ 2*im_paded(2*i-1,2*j)+ 1*im_paded(2*i-1,2*j+1)+... gaussian filter
                                         2*im_paded(2*i,2*j-1)+ 4*im_paded(2*i,2*j)+ 2*im_paded(2*i,2*j+1)+...
                                         1*im_paded(2*i+1,2*j-1)+ 2*im_paded(2*i+1,2*j)+ 1*im_paded(2*i+1,2*j+1)));
    end
end

%img_sampled = uint8(img_sampled);
img_sampled = mat2gray(img_sampled);

imshow(img_sampled);