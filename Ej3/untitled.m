%% Versión HSV

clear all
close all
clc

input_image = iread('.\example_image_1.png');
figure(1)
idisp(input_image);

input_image_size = size(input_image);
height = input_image_size(1);
width = input_image_size(2);
%{
input_image_H = zeros(height,width);
input_image_S = zeros(height,width);
input_image_L = zeros(height,width);

for row = 1:height
    for col = 1:width
        h,s,l = rgb2
        input_image_H(row,col) = 
    end
end
%}
input_image_hsv = rgb2hsv(input_image);

figure(2)
idisp(input_image_hsv);

H_margin = 60;
input_image_masked = input_image;
for row=1:height
    for col=1:width
        hsv = input_image_hsv(row,col);
        h = hsv(1);
        if h > (120-H_margin)/360 && h < (120+H_margin)/360
            input_image_masked(row,col,:) = [255,0,255];
        end
    end
end
figure(3)
%idisp(input_image_masked);

idisp((input_image_hsv(:,:,1) < 1/12 | input_image_hsv(:,:,1) > 11/12) & input_image_hsv(:,:,2) > 1/4 & input_image_hsv(:,:,3) > 1/4)

%% Versión Blobs

clear all
close all
clc

input_image = iread('.\example_image_1.png');
figure(1)
idisp(input_image);

%input_image_size = size(input_image);
%height = input_image_size(1);
%width = input_image_size(2);

input_image_mono = imono(idouble(input_image));
figure(2)
idisp(input_image_mono);

%t = otsu(input_image_mono);
t = max(max(input_image_mono))*0.7;
input_image_th = input_image_mono>t;
input_image_nobackground = input_image_th;

for col = 1:width(input_image_nobackground)
    if input_image_nobackground(1,col) == 0
        input_image_nobackground = bucket_tool2(input_image_nobackground,1,col,1);
    end
    if input_image_nobackground(end,col) == 0
        input_image_nobackground = bucket_tool2(input_image_nobackground,1,height(input_image_nobackground),1);
    end    
end

for row = 1:height(input_image_nobackground)
    if input_image_nobackground(row,1) == 0
        input_image_nobackground = bucket_tool2(input_image_nobackground,row,1,1);
    end
    if input_image_nobackground(row,end) == 0
        input_image_nobackground = bucket_tool2(input_image_nobackground,row,width(input_image_nobackground),1);
    end
end



figure(3)
idisp(input_image_nobackground)

blobs = iblobs(input_image_th,'boundary');
%lines = blobs(blobs.class > 0);
% quise decir parent != 0

