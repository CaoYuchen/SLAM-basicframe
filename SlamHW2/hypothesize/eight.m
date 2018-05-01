function [ R,t ] = eight( c1,c2 )

length=640;
width=480;
Kn=[2/length,0,-1;0,2/width,-1;0,0,1];

fx=520.9;
fy=521.0;
cx=325.1;
cy=249.7;

K=[fx,0,cx;0,fy,cy;0,0,1];

n=size(c2,1);

% rand=1:8;
% X=[];
% for i=1:n
%     x=m(c1(i,1),c1(i,2),c2(i,1),c2(i,2));
%     X=[X;x];
% end

 random=randperm(n,8);
 
x1=m(c1(random(1),1),c1(random(1),2),c2(random(1),1),c2(random(1),2));
x2=m(c1(random(2),1),c1(random(2),2),c2(random(2),1),c2(random(2),2));
x3=m(c1(random(3),1),c1(random(3),2),c2(random(3),1),c2(random(3),2));
x4=m(c1(random(4),1),c1(random(4),2),c2(random(4),1),c2(random(4),2));
x5=m(c1(random(5),1),c1(random(5),2),c2(random(5),1),c2(random(5),2));
x6=m(c1(random(6),1),c1(random(6),2),c2(random(6),1),c2(random(6),2));
x7=m(c1(random(7),1),c1(random(7),2),c2(random(7),1),c2(random(7),2));
x8=m(c1(random(8),1),c1(random(8),2),c2(random(8),1),c2(random(8),2));

 X=[x1;x2;x3;x4;x5;x6;x7;x8];

[~,~,V]=svd(X);
E=K'*Kn'*reshape(V(:,9),[3,3])'*Kn*K;

[ R,t ] = select( E,c1(random,:),c2(random,:),1);



end

function [ left ] = m( u2,v2,u1,v1 )
%normalization
% fx=520.9;	
% fy=521.0;	
% cx=325.1;	
% cy=249.7;
% 
% K=[fx,0,cx;0,fy,cy;0,0,1];
length=640;
width=480;
K=[2/length,0,-1;0,2/width,-1;0,0,1];

s1=K*[u1;v1;1];
s2=K*[u2;v2;1];
s1=s1/s1(3,1);
s2=s2/s2(3,1);
u1=s1(1,1);
v1=s1(2,1);
u2=s2(1,1);
v2=s2(2,1);

left=[u1*u2,u1*v2,u1,v1*u2,v1*v2,v1,u2,v2,1];
end