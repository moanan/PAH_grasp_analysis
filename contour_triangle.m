function contour_points = contour_triangle( a, b, phi_d, Tx, Ty )
%This function return the contour points of a trianle, given the
%semi-major axis, semi-minor axis, rotating angle and translation
%displacement

%   Created by An Mo on 18th Oct. 2017

% this is a temporal version where the traigle is very regular

phi = phi_d*pi/180;
x_temp  = a*cos(pi/6);
x = [-x_temp,x_temp,0,-x_temp];
y = [-0.5*a,-0.5*a,a,-0.5*a];
contour_points = [x;y];

contour_points = [cos(phi),-sin(phi);sin(phi),cos(phi)]*contour_points; % rotation
contour_points = contour_points + [Tx; Ty];                             % translation

end

