function contour_points = contour_flower( a, b, phi_d, Tx, Ty )
%UNTITLED Summary of this function goes here
%   a: number of leaves
%   b: depth between leaves
%   created by An Mo on 20th Sept. 2017

magnitude = 10;

t = linspace(0,2*pi,100);
r1 = magnitude*sin(a*t)+b;  x1 = r1.*cos(t); y1 = r1.*sin(t);
contour_points = [x1; y1];

end

