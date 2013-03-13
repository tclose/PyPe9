function [ new_trees, rotation_matrix ] = intrinsic_coordinate( original_trees )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
n1=normal_soma(original_trees);
n2=normal_dendrite(original_trees);
n3=cross(n2,n1);
n3=n3/normest(n3);
n2=cross(n3,n1);
n2=n2/normest(n2);
rotation_matrix=[ n3' n2' n1' ];
%construct the new trees
A=inv(rotation_matrix);
new_trees=original_trees;
i=1;
k=size(original_trees,2);
while i<=k
    B=[original_trees{i}.X original_trees{i}.Y original_trees{i}.Z]*A';
    new_trees{i}.X=B(:,1);
    new_trees{i}.Y=B(:,2);
    new_trees{i}.Z=B(:,3);
    i=i+1;
end

end

