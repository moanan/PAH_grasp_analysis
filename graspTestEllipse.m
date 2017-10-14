function [maxNumberOfContacted] = graspTestEllipse(numberOfPins,rotationStroke)
% %graspTest start a simulation with selected pins configuration and object
%   inputs: 
%       numberOfPins(per line)
%       eccentricity(global variable),
%       rotationStroke(0-90deg)
%       shapeOfObject(shape is fixed around 100 x 100mm)
%       isRandom
%
%   eccentricity is sqrt(1-(b/a)^2)
%   the area of grasp is around 120 x 120mm
%
%   created by An Mo on 6th Oct. 2017


%% init
% pins
n = numberOfPins;
m = numberOfPins;
global spacing
spacing = 120/(numberOfPins-1);
x0=[eps,eps];
myFunction = @root2d_ellipse;
semiAxis = fsolve(myFunction,x0);
a_pin = semiAxis(1);
b_pin = semiAxis(2);
centers = zeros(n,m,3);
% object
                                                %% TO DO shapeOfObject = xxx;
                                                %% TO DO shape is fixed within 100 x 100mm
a_object = 5;
b_object = 45;
x_object = 0;
y_object = 0;
orientation_object = 10;    % deg           TO DO: + ramdon



% iteration
rotationTimes = 10;                                    % number of steps of rotation in one strock
rotationSpeedOfPin_d = rotationStroke/rotationTimes;   % rotation angle on pin each iteration: deg/step
% statistics
maxIter = 10;               % numebr of maximum iteration, NOT used!
numberOfRemove = 0;
maxNumberOfContacted = 0;

%% create pin array
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
end

%% create object to grasp
% one object is generated by setting the center and orientation(deg)




object1 = obj2grasp(x_object, y_object, orientation_object, 1);
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
%         plot(P(1,:),P(2,:),'ro');                       % draw inner contacts, removable 
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
toc;

%% draw pins with rotation
% from here on, simulation begins...

% v = VideoWriter('contour adaption flower.mp4','MPEG-4'); Das funktioniert nicht...
v = VideoWriter('contour adaption flower.avi');
v.FrameRate = 2;
open(v);
frame = getframe(gcf);      % record the first frame
writeVideo(v,frame);
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
            plot(closestPoint(1,1),closestPoint(2,1),'o');
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
    title('15 x 15 pin array hand simulation');
    xlabel(['Number of contacted pins is: ',num2str(numberOfContactedPins)]);
    frame = getframe(gcf);      % record the process
    writeVideo(v,frame);
    if(numberOfContactedPins > 0)
        disp(['Contacted! Number of contacted pins is: ',num2str(numberOfContactedPins)]);
        if(numberOfContactedPins > maxNumberOfContacted)        % save the maximun number of contacted pins
            maxNumberOfContacted = numberOfContactedPins;
        end
    else
        disp('Not contacted.');
    end
    if(t~=rotationTimes)
%         pause;               % uses breakpoint here to see the pin movement
        clf; 
    end
end
disp(['Maximun number of contacted pins are: ', num2str(maxNumberOfContacted)]);
close(v);

end
