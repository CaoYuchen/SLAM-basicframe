function [ T ] = DLT( c,P )
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明
n=size(c,1);
rand=randperm(n,8);

X=[];
for i=1:n
    x=m(c(i,1),c(i,2),P(i,:,:));
    X=[X;x];
end

% x1=m(c(rand(1),1),c(rand(1),2),P(rand(1),:,:));
% x2=m(c(rand(2),1),c(rand(2),2),P(rand(2),:,:));
% x3=m(c(rand(3),1),c(rand(3),2),P(rand(3),:,:));
% x4=m(c(rand(4),1),c(rand(4),2),P(rand(4),:,:));
% x5=m(c(rand(5),1),c(rand(5),2),P(rand(5),:,:));
% x6=m(c(rand(6),1),c(rand(6),2),P(rand(6),:,:));
% 
% X=[x1;x2;x3;x4;x5;x6];

[~,~,V]=svd(X);
T=reshape(V(:,12),[4,3])';

end

function [ left ] = m( u,v,P )
%normalization
fx=520.9;	
fy=521.0;	
cx=325.1;	
cy=249.7;

K=[fx,0,cx;0,fy,cy;0,0,1];
%K=1;
s1=K\[u;v;1];
s1=s1/s1(3);
u=s1(1);
v=s1(2);

left=[P(1),P(2),P(3),1,0,0,0,0,-u*P(1),-u*P(2),-u*P(3),-u;
      0,0,0,0,P(1),P(2),P(3),1,-v*P(1),-v*P(2),-v*P(3),-v];
end