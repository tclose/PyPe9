function [ normal_soma] = normal_soma( trees )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
CONSTANT=[1 1 1];
N=mean_soma(trees);
%x=N(:,1);
%y=N(:,2);
%z=N(:,3);
%X=[ones(size(x)) x y];
%b=regress(z,X);
%n=[ -b(2,:) -b(3,:) 1];
[v, d] = eig(cov(N));
[temp, ind] = sort(diag(d));
v1 = v(:,ind(end));
v2 = v(:,ind(end-1));
n = cross(v1,v2)';
if n*CONSTANT'>0
        n=-n;
end
normal_soma=n/normest(n);

end

