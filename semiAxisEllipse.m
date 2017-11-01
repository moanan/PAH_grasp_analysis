function semiAxis = semiAxisEllipse(spacing, eccentricity)
%calculate the seme axis of ellipse by giving spacing and eccentricity
%   Detailed explanation goes here

a = eccentricity^2;
b = -2*spacing;
c = spacing^2;

delta = b^2-4*a*c;
x_1 = (-b+sqrt(delta))/(2*a);
y_1 = spacing - x_1;
x_2 = (-b-sqrt(delta))/(2*a);
y_2 = spacing - x_2;

if(x_1>0 && y_1>0)
    semiAxis = [x_1, y_1];
else
    semiAxis = [x_2, y_2];
end

end

