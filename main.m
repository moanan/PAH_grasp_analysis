clear;clc;clf;
tic;

global eccentricity
% numberOfPins = 15;
% rotationStroke = 90;
% eccentricity = 0.9;

%% Fig. 1 strock from 10-90
eccentricity = 0.8;
numberOfPins = 15;

i = 1;
for rotationStroke = 10:10:90
    maxNumberOfContacted(i) = graspTestEllipse(numberOfPins,rotationStroke);
    i = i+1;
end
rotationStroke = 10:10:90;
plot(rotationStroke,maxNumberOfContacted);




%% Fig. 2 
% eccentricity = 0.9;
% maxNumberOfContacted = graspTestEllipse(numberOfPins,rotationStroke)
% eccentricity = 0.8;
% maxNumberOfContacted = graspTestEllipse(numberOfPins,rotationStroke)


toc;