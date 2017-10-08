function [closestPoint, dist] = distBWpointAndPoints(point, contour)
%UNTITLED3 Summary of this function goes here
% calculate minimun distance between a point and a set of points
% created by An Mo on 20th Sept. 2017

[t, numOfPoints] = size(contour);

dist = norm(contour(:,1)-point);
closestPoint = point;

for i = 1:numOfPoints
    tempDist = norm(point-contour(:,i));
    if(tempDist < dist)
        dist = tempDist;
        closestPoint = contour(:,i);
    end
end

end

