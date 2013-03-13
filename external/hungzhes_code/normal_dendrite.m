function [ n] = normal_dendrite( trees )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
SIZE=size(trees);
k=SIZE(:,2);
N=[];
CONSTANT=[1 1 1];
i=1;
while i<=k
    diam_cut = 1.5;
    ind = (trees{i}.R~=1) & (trees{i}.D<diam_cut);
    x=trees{i}.X(ind);
    y=trees{i}.Y(ind);
    z=trees{i}.Z(ind);
    %X=[ones(size(x)) x y];
    %b=regress(z,X);
    %n=[ -b(2,:) -b(3,:) 1];
    pts = [x y z];
    [v, d] = eig(cov(pts));
    [temp, ind] = sort(diag(d));
    v1 = v(:,ind(end));
    v2 = v(:,ind(end-1));
    n = cross(v1,v2)';
    n=n/normest(n);   
    if n*CONSTANT'>0
        n=-n;
    end
    N=[N n'];
    i=i+1;
end
n=sum(N,2)/k;
n=n/normest(n);
end

