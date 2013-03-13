function [ N] = mean_soma( trees )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
k=size(trees,2);
i=1;
N=[];
while i<=k
    n=size(trees{i}.X(trees{i}.R==1),1);
    a=sum(trees{i}.X(trees{i}.R==1))/n;
    b=sum(trees{i}.Y(trees{i}.R==1))/n;
    c=sum(trees{i}.Z(trees{i}.R==1))/n;
    x=[a b c];
    N=[N x'];
    i=i+1;
end
N=N';
end

