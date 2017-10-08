
clear;clc;clf;tic;
% 4.6671    3.3329



global spacing
global eccentricity
spacing  = 8;
eccentricity = 0.5;
x0=[eps,eps];
myFunction = @root2d_ellipse;
x = fsolve(myFunction,x0)


toc