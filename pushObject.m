function [closestPoint,translation,rotation] = pushObject(obj2grasp, pin, contactPoints, rotationSpeedOfPin_d)
%pushObject update the pose of the object to grasp when contacted with a
%pin
%   contactPoint is the center point of two intersect points of two
%   contour, closestPoint is the point on the contour of pin assuming to be
%   the ture contact point.

% created by An Mo on 20th Sept. 2017

rotationIndex = 0.5;       % compensate the situation rolling friction and dry friction are working together
translationIndex = 1;

contactPoint = [mean(contactPoints(1,:)); mean(contactPoints(2,:))];
[closestPoint, ~] = distBWpointAndPoints(contactPoint, pin.contour);

dist2objCenter_v = closestPoint - [obj2grasp.position_x;obj2grasp.position_y];        % vector
dist2pinCenter_v = closestPoint - [pin.position_x;pin.position_y]; 
dist2objCenter = norm(dist2objCenter_v);                                              % scalar
dist2pinCenter = norm(dist2pinCenter_v);
% rotationSpeedOfPin_r = rotationSpeedOfPin_d*pi/180;

rotation = rotationIndex*rotationSpeedOfPin_d*dist2pinCenter/dist2objCenter;          % deg
if(~pin.rotationDirection)    % clockwise
    rotation = -rotation;
end
translation = translationIndex*(closestPoint - contactPoint);

%% update the object's pose (which is down outside of function now)
% the contour will be regenerated
% obj2grasp.translate(translation(1),translation(2));
% obj2grasp.rotate(rotation);                                                           % deg

end

