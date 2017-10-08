function contour_points = oval_contour( a, b, phi_d, Tx, Ty )
%This function return the contour points of an ellipse, given the
%semi-major axis, semi-minor axis, rotating angle and translation
%displacement

%   Created by An Mo on 6th Jul. 2017
%   Modified by An Mo on 31th Aug. 2017

phi = phi_d*pi/180;
t = linspace(0,2*pi);

x = a.*cos(t);
y = b.*sin(t);

contour_points = [x',y']';
contour_points = [cos(phi),-sin(phi);sin(phi),cos(phi)]*contour_points; % rotation
contour_points = contour_points + [Tx; Ty];                             % translation

end

