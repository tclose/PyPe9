% This script generates random points within a cylinder of the given height and radius
% Argument k is a coefficient that indicates how much the points should be perturbed from
% the sides of the cylinder
function [X,Y,Z,P,W,BB] = genMF (np, height, radius, k)

     % np: number of points

     theta = linspace(0,360,np);

     % X,Y,Z coordinates of a cylinder of the given radius
     X    = radius .* cos(theta);
     Y    = radius .* sin(theta);
     Z    = linspace (0,height,np);

     % z coordinate, radius, angle of random points within a cylinder
     P_z = rand(np,1) * height;
     P_r = radius-((rand(np,1) + 0.5)*k);
     P_theta = rand(np,1) .* theta';

     P = pol2cart (P_theta, P_r, P_z);
     W = rand(np,1) * k;
     BB = [[min(P(:,1)),min(P(:,2)),min(P(:,3))] 
           [max(P(:,1)),max(P(:,2)),max(P(:,3))] ];
           

endfunction


     

     
