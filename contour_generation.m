%extract contour of object in photo
% The photo size is 1440 x 1080 (WeChat image size)

% Created by An Mo on 15th Oct. 2017
% Modified by An Mo on 6th Oct. 2017

clf;clear;tic;

I = imread('D:\82-Software\2017-Pin Array Hand\grasp_analysis\test_images\radio.jpg');
I = rgb2gray(I);
BW = ~imbinarize(I);

[B,L] = bwboundaries(BW,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on;

maxLength = 0;
for k = 1:length(B)
   boundary = B{k};
   tempLength = length(boundary);
   if(tempLength>maxLength)
       maxLength = tempLength;
       x = boundary(:,2);
       y = boundary(:,1);
   end
%    plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end

%% TO DO: map the coordinates to 100x100 and reduce points
plot(x,y, 'w', 'LineWidth', 2);
axis equal;
% find the center of gravity of the object
x_center = mean(x);
y_center = mean(y);
plot(x_center,y_center, 'o');
% translate the center of the object to coordinate origin
x = x - x_center;
y = y - y_center;
plot(x,y, 'w', 'LineWidth', 2);
% figure;

toc;