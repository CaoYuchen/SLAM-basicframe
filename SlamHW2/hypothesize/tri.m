function [ s1,s2 ] = tri( xx1,xx2,R,t )
%UNTITLED15 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
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
s1=threed(3);
proj=K\P2*threed;
% proj=proj/proj(4);
s2=proj(3);

end

