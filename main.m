% Please remember to command out the video generation codes (in graspTest.m files)
% when using parallel computing in simulation!

clear;clc;clf;tic;

% global eccentricity
% numberOfPins = 15;
% rotationStroke = 90;
% eccentricity = 0.9;

%% Fig. 1 strock from 10-90
% eccentricity = 0.8;
% numberOfPins = 15;
% 
% i = 1;
% for rotationStroke = 10:10:90
%     maxNumberOfContacted(i) = graspTestEllipse(numberOfPins,rotationStroke);
%     i = i+1;
% end
% rotationStroke = 10:10:90;
% plot(rotationStroke,maxNumberOfContacted);




%% Fig. 2 
numberOfPins = 15;
eccentricity = 0.85;
rotationStroke = 90;
noiseEnable = 1;

averageMaxNumberOfContacted = 0;
indexEnd = 9;
loop = 8;
parfor i = 1:loop
    for objectShapeIndex = 1:indexEnd
        maxNumberOfContacted = graspTestEllipse(numberOfPins,eccentricity,rotationStroke,objectShapeIndex,noiseEnable);
        averageMaxNumberOfContacted = averageMaxNumberOfContacted + maxNumberOfContacted;
    end
end
averageMaxNumberOfContacted = averageMaxNumberOfContacted / (indexEnd*loop)

toc;