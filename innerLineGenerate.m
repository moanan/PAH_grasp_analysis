function contourFilled = innerLineGenerate(contour)
%fill a contour with lines within the contour
%   Created by An Mo on 21st Sept. 2017
contourFilled = contour;
[t, numOfPoints] = size(contour);

middle = round((numOfPoints-1)/2);

for i = 1:middle
    contourFilled = [contourFilled, contour(:,i), contour(:,i+middle)];    % scale
end

end

