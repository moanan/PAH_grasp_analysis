classdef obj2grasp < handle
    %OBJ2GRASP is an object, which can be in various shape
    %   Created by An Mo on 20th Sept. 2017
    %   Modified by An Mo on 6th Oct. 2017
    
    properties
        position_x                  % center of gravity
        position_y
        orientation_d               % counter-clockwise rotation (deg)
        isContacted = 0
        contour
    end
    
    methods
        %% constructor
        function obj = obj2grasp(position_x, position_y, orientation_d)
            obj.position_x = position_x;
            obj.position_y = position_y;
            obj.orientation_d = orientation_d;
        end
        
        %% generate the shape of the object
        function generateContour(obj, a, b)
            obj.contour = contour_flower(a, b, obj.orientation_d, obj.position_x, obj.position_y);
            obj.rotate(obj.orientation_d);
        end
        
        %% update orientation
        function rotate(obj, rotationAngle_d)
            obj.orientation_d = obj.orientation_d + rotationAngle_d;       % update orientation
            phi = rotationAngle_d*pi/180;
            temp_contour = obj.contour - [obj.position_x; obj.position_y]; % update contour / translate to origin point
            temp_contour = [cos(phi),-sin(phi);sin(phi),cos(phi)]*temp_contour; % rotation
            obj.contour = temp_contour + [obj.position_x; obj.position_y]; % translate back     
        end

        %% update position
        function translate(obj, x, y)
            obj.position_x = obj.position_x + x;    % update position
            obj.position_y = obj.position_y + y;
            obj.contour = obj.contour + [x; y];     % update contour
        end
        
        %% overwrite of plot command to show the corresponding pin
        function plot(obj)
            plot(obj.contour(1,:),obj.contour(2,:));axis equal;
        end
    end
    
end

