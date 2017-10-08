function F = root2d_ellipse(x)
%calculate the semi-axis of ellipse pin array
%   
global spacing
global eccentricity

a = x(1);
b = x(2);
F(1) = a+b-spacing;
F(2) = 1-(b/a)^2-eccentricity^2;

end

