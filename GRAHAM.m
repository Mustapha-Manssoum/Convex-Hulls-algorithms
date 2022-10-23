%% clear the workspace
clc; close all; clearvars;
%% Definition of the function of the orientation of 3 points : 
orient = @(px,py,qx,qy, rx, ry) sign((qx - px) * (ry - py) - (rx - px) * (qy - py));
%% Random cloud of points in [0,1]²
n = 20;
points = rand(2,n);
%% Display the cloud of points
figure;
plot(points(1,:), points(2,:), '.');
axis square;
axis equal;
title("Cloud of points");
axis([0 1 0 1]); hold on;
%% 
% To simplify the writing of the algorithm, we will only construct the upper convex hull 
% a second pass of the algorithm will provide us with the lower convex hull

%% The upper convex hull
[sortedPoints, sortedIndex] = sort(points(1,:)); % sort the points by increasing x values
CvxHull = zeros(1,n);
CH(1) = sortedIndex(1);
CH(2) = sortedIndex(2);
%{
When a new point pi is considered considered, two cases can arise:
1 • the new point forms a right turn with respect to the last segment of the upper convex hull: 
the convexity is preserved preserved, the point integrates the convex hull.

2 • the new point forms a left turn with respect to the last segment of the upper
convex hull: the convex hull must be updated. Some points must be removed
from the current (upper) convex hull.

In the case of a left turn, the current convex hull is updated by progressively removing
the points pi−1, pi−2, pi−k+1 until the triplet (pi−k−1, pi−k, pi) forms a right turn, or
there is only one point left in the convex envelope. We can then add the point pi.
%}

top = 2;
for k = 3:n
    nextPoint = sortedIndex(k);
    % while it is a left turn and top >= 2
    while (top >= 2) && (orient( points(1, CH(top - 1)), points(2, CH(top - 1)), points(1, CH(top)), points(2, CH(top)), points(1, nextPoint), points(2, nextPoint))>=0)
        top = top - 1;
    end
    %%end
    top = top + 1;
    CH(top) = nextPoint;
end

%% The lower convex hull
% inversed sortedIndex
sortedIndex = sortedIndex(end:-1:1);
top = top + 1;
CH(top) = sortedIndex(2);
for k = 3:n
    nextPoint = sortedIndex(k);
    % while it is a left turn and top >= 2
    while (top >= 2) && (orient( points(1, CH(top - 1)), points(2, CH(top - 1)), points(1, CH(top)), points(2, CH(top)), points(1, nextPoint), points(2, nextPoint))>=0)
        top = top - 1;
    end
    %%end
    top = top + 1;
    CH(top) = nextPoint;
end

%% Plot
hold on;
plot(points(1,CH(1:top)), points(2,CH(1:top)));







