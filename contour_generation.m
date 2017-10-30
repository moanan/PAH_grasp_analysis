%extract contour of object in photo
% The photo size is 1440 x 1080 (WeChat image size)

% Created by An Mo on 15th Oct. 2017
% Modified by An Mo on 30th Oct. 2017

clf;clear;tic;
numberOfPoints = 150; % number of points of the contour after compressing

for imagename = 1:7
    %% read in image
    I = imread(['test_images\',num2str(imagename),'.jpg']);

    %% image process (contour extraction)
    varName = ['contour_',num2str(imagename)];
    eval([varName, '= imageProcess(I, numberOfPoints);']);

    %% save contour - manually save each shape of contour
    filename = 'contour_images.mat';
    if(exist('contour_images.mat','file'))
        save(filename,varName,'-append');
    else
        save(filename,varName);
    end
end

toc;

%% 
function contour = imageProcess(I, numberOfPoints)
    I = rgb2gray(I);
    BW = ~imbinarize(I);
    [B,L] = bwboundaries(BW,'noholes');
    imshow(label2rgb(L, @jet, [.5 .5 .5]))
    hold on;
    %% extract contour
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
    plot(x,y, 'w', 'LineWidth', 2);axis equal;
    %% find the center of gravity of the object
    x_center = mean(x);
    y_center = mean(y);
    plot(x_center,y_center, 'o');
    %% translation to coordinate origin
    x = x - x_center;
    y = y - y_center;
    plot(x,y, 'w', 'LineWidth', 2);
    %% scale
    x_length = max(x)-min(x);
    y_length = max(y)-min(y);
    scale = max(x_length, y_length)/100;
    x = x ./ scale;
    y = y ./ scale;
    plot(x,y, 'r', 'LineWidth', 2);
    %% reduce points
    space = maxLength/numberOfPoints;
    selectedIndex = round(space*(1:numberOfPoints));
    x = x(selectedIndex);
    y = -y(selectedIndex);
%     figure; plot(x, y, 'r', 'LineWidth', 2); axis equal;
    contour = [x';y'];
end