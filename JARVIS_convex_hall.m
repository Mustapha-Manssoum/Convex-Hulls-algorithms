%% Javis algorithm, "gift warping algorithm"
clear all; close all; clc;
%% définition de l'orientation de 2 points:
orient = @(px,py,qx,qy, rx, ry) sign((qx - px) * (ry - py) - (rx - px) * (qy - py));
%% Calcul du cos (produit scalaire)
cosAngle = @(px,py,qx,qy, rx, ry)  ((qx - px) * (rx - qx) + (qy - py) * (ry - qy)) / (sqrt((qx - px)^2 + (qy - py)^2) * sqrt((rx - qx)^2 + (ry - qy)^2));
%% Un nuage dde points aléatoire dans le carré [0,1]²
n = 30;
points = rand(2,n);

%% Affichage du nuage
figure;
plot(points(1,:), points(2,:), '.');
axis square; axis equal;
title("nuage de points");
axis([0 1 0 1]); hold on;

%% 
[~, extrem] = min(points(1,:));
%% Look for the first segment of the convex hull:
tStart = tic;

for i = 1:n
    count = 0;
    for j = 1:n
        if (i ~= j && i ~= extrem && j ~= extrem)
            if (orient(points(1,extrem),points(2,extrem),points(1,i),points(2,i),points(1,j),points(2,j)) >= 0)
                        count = count + 1;
            else
                        count = count - 1;                   
            end
        end
    end
    if ((count == n - 2))
                plot([points(1,extrem) points(1,i)],[points(2,extrem) points(2,i)]);
                p = extrem;
                q = i;
                px = points(1,extrem);
                py = points(2,extrem);
                qx = points(1,i);
                qy = points(2,i);
    end
end

%% The searched segments are the one forming the largest possible angle with the previous segment
x = p;
j = q;
for i = 1:n
    max_cos = -1;
    for r = 1:n

        my_cos = cosAngle(points(1,x),points(2,x),points(1,j),points(2,j),points(1,r),points(2,r));
            
            if (my_cos > max_cos)
                max_cos = my_cos;
                max_r = r;
            end
       
    end
    x = j;
    j = max_r;
    plot([points(1,x) points(1,j)],[points(2,x) points(2,j)]);
    
    
end
tEnd = toc(tStart);
