classdef pin < handle
    %PIN is a pin section, which can be in various shape
    %   Created by An Mo on 20th Sept. 2017
    
    properties
        position_x                  % center of gravity
        position_y
        orientation_d               % counter-clockwise rotation (deg)
        rotationDirection           % counter-clockwise -> 0
        isContacted = 0
        contour
    end
    
    methods
        %% constructor
        function obj = pin(position_x, position_y, orientation_d, rotationDirection)
            obj.position_x = position_x;
            obj.position_y = position_y;
            obj.orientation_d = orientation_d;
            obj.rotationDirection = rotationDirection;
        end
        %% generate only once the contour of pin
        function generateContour(obj, a, b)
            obj.contour = contour_oval(a, b, obj.orientation_d, obj.position_x, obj.position_y);
        end
        %% update the orientation of a pin
        function rotate(obj, rotationAngle_d)
            if(~obj.rotationDirection)
                phi = rotationAngle_d*pi/180;
            else
                phi = -rotationAngle_d*pi/180;
            end
            obj.orientation_d = obj.orientation_d + phi*180/pi;            % update orientation
            temp_contour = obj.contour - [obj.position_x; obj.position_y]; % update contour / translate to origin point
            temp_contour = [cos(phi),-sin(phi);sin(phi),cos(phi)]*temp_contour; % rotation
            obj.contour = temp_contour + [obj.position_x; obj.position_y]; % translate back            
        end

        %% overwrite of plot command to show the corresponding pin
        % TO DO: define the color of rotation
        function plot(obj)
            plot(obj.contour(1,:),obj.contour(2,:));axis equal;
        end
    end
end

