function [ s1,s2,X1,Y1 ] = tri( xx1,xx2,R,t )
%UNTITLED15 此处显示有关此函数的摘要
%   此处显示详细说明
%syms s;
fx=520.9;	
fy=521.0;	
cx=325.1;	
cy=249.7;

K=[fx,0,cx;0,fy,cy;0,0,1];


x1=[xx1;1];
% x1=K\x1;
% x1=x1/x1(3);
x2=[xx2;1];
% x2=K\x2;
% x2=x2/x2(3);
%s1=solve(s*cross(x2,R*x1)+cross(x2,t)==0,s)
% this is a rough triangulation which needs to be improved
% s1=regress(-cross(x2,t),cross(x2,R*x1));
% s2=regress(s1*R*x1+t,x2);

P1=K*[eye(3),zeros(3,1)];
P2=K*[R,t];
A=[x1(1)*P1(3,:)-P1(1,:);
    x1(2)*P1(3,:)-P1(2,:);
    x2(1)*P2(3,:)-P2(1,:);
    x2(2)*P2(3,:)-P2(2,:)];
[~,~,V]=svd(A);
threed=V(:,4);
threed=threed/threed(4);
% if threed(3)>0
s1=threed(3);
X1=threed(1);
Y1=threed(2);
% else
% s1=-threed(3);
% X1=-threed(1);
% Y1=-threed(2);   
% end
proj=P2*threed;
%proj=proj/proj(4);
s2=proj(3);

end

