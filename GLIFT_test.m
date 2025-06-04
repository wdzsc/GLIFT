
clear;
clc;

img_path1='.\image\pair5_1.png';
img_path2='.\image\pair5_2.png';

im1 = imread(img_path1);
im2 = imread(img_path2);

scale=1;  % scale of 0 indicates no scaling and 1 indicates a scaling change
sfcd=2/3; % image scaling
s=4;  % Scale
o=9;  % Direction
num_point=5000; % Number of key points
if size(im1,3)==1 
    temp=im1; im1(:,:,1)=temp; im1(:,:,2)=temp; im1(:,:,3)=temp;
end
if size(im2,3)==1
    temp=im2; im2(:,:,1)=temp; im2(:,:,2)=temp; im2(:,:,3)=temp;
end


[key_A,key_B,im1_transformed,im2,H1] =global_search(im1,im2,scale,s,o,num_point);


[matchedPoints1,matchedPoints2]=local_search(im1_transformed,im2,key_A,key_B,H1);


H2=FSC(matchedPoints1,matchedPoints2,'affine',3);
Y_=H2*[matchedPoints1';ones(1,size(matchedPoints1,1))];
Y_(1,:)=Y_(1,:)./Y_(3,:);
Y_(2,:)=Y_(2,:)./Y_(3,:);
E=sqrt(sum((Y_(1:2,:)-matchedPoints2').^2));
inliersIndex=E<3;
cleanedPoints1 = matchedPoints1(inliersIndex, :);
cleanedPoints2 = matchedPoints2(inliersIndex, :);
% Show results
figure;
showMatchedFeatures(im1, im2, cleanedPoints1, cleanedPoints2, 'montage','PlotOptions', {'bo','g+','y-'});


