% this is to generate the grasp process for manuscript - PAH-II Fig. 10
% by using the "pause;", different frame of figures can be obtained.
% the object radio in 10 x 10 matrix, the 6th with 5 contacts is prefered

%   created by An Mo on 6th Mar. 2018


clear;clc;clf;tic;

numberOfPins = 10;
eccentricity = 0.85;
rotationStroke = 90;
noiseEnable = 0;
objectShapeIndex = 3;

maxNumberOfContacted = mock_graspTestEllipse(numberOfPins,eccentricity,rotationStroke,objectShapeIndex,noiseEnable);

%% F9 to run the following lines will replot the needed figures

% Load saved figures
c=hgload('f1.fig');
k=hgload('f2.fig');
j=hgload('f3.fig');

% Prepare subplots
figure
f(1)=subplot(1,3,1);axis equal;axis([-70 70 -70 70]);
f(2)=subplot(1,3,2);axis equal;axis([-70 70 -70 70]);
f(3)=subplot(1,3,3);axis equal;axis([-70 70 -70 70]);


% Paste figures on the subplots
copyobj(allchild(get(c,'CurrentAxes')),f(1));
copyobj(allchild(get(k,'CurrentAxes')),f(2));
copyobj(allchild(get(j,'CurrentAxes')),f(3));

% % Add legends
% l(1)=legend(f(1),'LegendForFirstFigure')
% l(2)=legend(f(2),'LegendForSecondFigure')
% l(3)=legend(f(3),'LegendForThirdFigure')
%%

toc;


function [maxNumberOfContacted] = mock_graspTestEllipse(numberOfPins,eccentricity,rotationStroke,objectShapeIndex,noiseEnable)
% %graspTest start a simulation with selected pins configuration and object
%   inputs: 
%       numberOfPins(per line)
%       eccentricity(global variable),
%       rotationStroke(0-90deg)
%       objectShapeIndex(shape is fixed around 100 x 100mm)
%       noiseEnable generate object's pose randomly
%
%   eccentricity is sqrt(1-(b/a)^2)
%   the area of grasp is around 120 x 120mm
%
%   created by An Mo on 6th Oct. 2017


%% init
% pins
n = numberOfPins;
m = numberOfPins;
spacing = 120/(numberOfPins-1);
semiAxis = semiAxisEllipse(spacing, eccentricity);
a_pin = semiAxis(1);
b_pin = semiAxis(2);
centers = zeros(n,m,3);
% object                    %           TO DO: + random
x_object = 1;
y_object = 2;
orientation_object = -20;    % deg 
% iteration
rotationTimes = 10;                                    % number of steps of rotation in one strock
rotationSpeedOfPin_d = rotationStroke/rotationTimes;   % rotation angle on pin each iteration: deg/step
% statistics
maxIter = 10;               % numebr of maximum iteration, NOT used!
numberOfRemove = 0;
maxNumberOfContacted = 0;

%% generate pin array
% position of bottom-left pin
x0 = -((n-1)/2*spacing);
y0 = x0;
% set center and orientation of pins  
for i = 1:n                 % row
    for j = 1:m             % colunm
        centers(i,j,1) = x0 + spacing * (i-1);      % can be replaced by "meshgrid" command
        centers(i,j,2) = y0 + spacing * (j-1);
        if(rem((i+j),2)>0)
            centers(i,j,3) = 0;
        else
            centers(i,j,3) = 90;
        end
    end
end
% generate the needed pins
for i = 1:n                 % row
    for j = 1:m             % colunm
        val = reshape(centers(i,j,:), [1 3]);       % transfer 3 values to a row vector
        if(rem((i+j),2)>0)
            rotationDirection = 0;                  % counter-clockwise => 0
        else
            rotationDirection = 1;                  % clockwise => 1
        end
        pinInput = [val,rotationDirection];
        % pins are generated here in a continuous index
        % where 4 inputs are: x, y, orientation(deg), rotation direction
        ellipses((i-1)*n+j) = pin(pinInput(1),pinInput(2),pinInput(3),pinInput(4));
    end
end
% generate pins' contour

for i = 1:n*m
    ellipses(i).generateContour(a_pin,b_pin);
    ellipses(i).plot();hold on;  
end
% pause; % set a break point here --> pin array is generated here
savefig('f1.fig');
%% create object to grasp
% one object is generated by setting the center and orientation(deg)
switch(objectShapeIndex)
    case 1 
        a_object = 5;
        b_object = 45;
    case 2
        a_object = 50;
        b_object = 30;
    case 3
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 1;                               % b_object is the scale
    case 4
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 1;                               % b_object is the scale
    case 5
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 1;                               % b_object is the scale        
    case 6
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 0.7;                               % b_object is the scale        
    case 7
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 1;                               % b_object is the scale        
    case 8
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 1;                               % b_object is the scale        
    case 9
        a_object = objectShapeIndex - 2;            % a_object is the index of image
        b_object = 1;                               % b_object is the scale         
    otherwise
        error('Shape index invalid!');
end

if(noiseEnable)
    object1 = obj2grasp(x_object+rand, y_object+rand, orientation_object+rand, objectShapeIndex);
else
    object1 = obj2grasp(x_object, y_object, orientation_object, objectShapeIndex);
end
object1.generateContour(a_object, b_object);
object1.plot();
hold on;

%% judge contacts and remove pushed pins
% create the shape of the object to grasp
temp_shape = object1.contour;
temp_center = [object1.position_x; object1.position_y];
temp_shape = temp_shape - temp_center;                  % translation to origin
contourFilled = innerLineGenerate(temp_shape);          % draw additional lines in the object
contourFilled = contourFilled + temp_center;            % translation back
% judge contacts
for i = 1:n*m                                           % use "parfor" to speed up if needed
    ellipses(i).plot();                                 % removable 
    P = InterX(contourFilled,ellipses(i).contour);
    if(~isempty(P))
        plot(P(1,:),P(2,:),'ro');                       % draw inner contacts, removable 
        ellipses(i).isContacted = 1;
    end
end
% remove contact pins
j = 1;
for i = 1:n*m
    if(ellipses(i).isContacted)
        index(j) = i;
        j = j+1;
    end
end
ellipses(index) = [];
numberOfRemove = length(index);

%% draw pins with rotation
% from here on, simulation begins...

%% video recording (commands in the middle and the last few lines also need to be taken care of)
%------ v = VideoWriter('contour adaption flower.avi');
%------ v.FrameRate = 2;
%------ open(v);
%------ frame = getframe(gcf);      % record the first frame
%------ writeVideo(v,frame);
clf;



for i = 1:n*m-numberOfRemove
    ellipses(i).plot();hold on;
end
object1.plot();
% pause; % set a break point here --> pin sliding is shown here
savefig('f2.fig');
clf;



for t = 1:rotationTimes     % every time rotation, the object is already moved only once considering each collision
    numberOfContactedPins = 0;
    object1.plot();
    hold on;
    objectTranslation = [0;0];
    objectRotation = 0;     % deg
    for i = 1:n*m-numberOfRemove
        ellipses(i).rotate(rotationSpeedOfPin_d);        
        contactPoints = InterX(object1.contour, ellipses(i).contour);   % not stable enough...
        ellipses(i).plot();                 % plot so many ellipse pins is very time comsuming!!!!!!!!!!!!!!!!!!!!!!!!!!
        if(~isempty(contactPoints))         % if contacted, mark the contact point
            %% pushObject
            [closestPoint,eachObjectTranslation,eachObjectRotation] = pushObject(object1, ellipses(i), contactPoints, rotationSpeedOfPin_d);
            plot(closestPoint(1,1),closestPoint(2,1),'o','MarkerEdgeColor','k');
            numberOfContactedPins = numberOfContactedPins + 1;
            objectTranslation = objectTranslation + eachObjectTranslation;
            objectRotation = objectRotation + eachObjectRotation;
        end  
    end
    % the contour of the object is reregenerated here
    if(numberOfContactedPins>4)            % damper: reduce overshoot of object while translating
        objectTranslation = objectTranslation/(numberOfContactedPins/2);
    end
    object1.translate(objectTranslation(1),objectTranslation(2));
    object1.rotate(objectRotation); 
    % statistics
%     title([num2str(n),' x ',num2str(m),' pin array gripper simulation']);   %'15 x 15 pin array hand simulation'
%     xlabel(['Number of contacted pins is: ',num2str(numberOfContactedPins)]);
%------     frame = getframe(gcf);      % record the process
%------     writeVideo(v,frame);
    if(numberOfContactedPins > 0)
        disp(['Contacted! Number of contacted pins is: ',num2str(numberOfContactedPins)]);
        if(numberOfContactedPins > maxNumberOfContacted)        % save the maximun number of contacted pins
            maxNumberOfContacted = numberOfContactedPins;
        end
    else
        disp('Not contacted.');
    end
    if(t == 6)
        savefig('f3.fig');
    end
    if(t~=rotationTimes)
%         pause;               % uses breakpoint here to see the pin movement
        clf; 
    end
end
disp(['Maximun number of contacted pins of object (index ',num2str(objectShapeIndex),') are: ', num2str(maxNumberOfContacted)]);
%------ close(v);

end