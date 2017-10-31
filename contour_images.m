function contour_points = contour_images( a, b, phi_d, Tx, Ty )
%This function return the contour points of a selected image by index
% a is the index of image
% b is the scale

%   Created by An Mo on 31st Oct. 2017

load contour_images.mat;

phi = phi_d*pi/180;

switch a
    case 1
        contour_points = contour_1;
    case 2
        contour_points = contour_2;
    case 3
        contour_points = contour_3;
    case 4
        contour_points = contour_4;
    case 5
        contour_points = contour_5;
    case 6
        contour_points = contour_6;
    case 7
        contour_points = contour_7;        
    otherwise
        error('Error. Invalid index of image contour!');
end

contour_points = [cos(phi),-sin(phi);sin(phi),cos(phi)]*contour_points; % rotation
contour_points = contour_points + [Tx; Ty];                             % translation
contour_points = contour_points .* b;                                   % scale

end

