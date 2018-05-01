clc
clear

fx=520.9;	
fy=521.0;	
cx=325.1;	
cy=249.7;
K=[fx,0,cx;0,fy,cy;0,0,1];

c1_2=importdata('C1_2.mat');
c2_1=importdata('C2_1.mat');
c1_3=importdata('C1_3.mat');
c3_1=importdata('C3_1.mat');
c2_3=importdata('C2_3.mat');
c3_2=importdata('C3_2.mat');

R8_1=importdata('R8_1.mat');
R8_2=importdata('R8_2.mat');
R8_3=importdata('R8_3.mat');
t8_1=importdata('t8_1.mat');
t8_2=importdata('t8_2.mat');
t8_3=importdata('t8_3.mat');

R7_1=importdata('R7_1.mat');
R7_2=importdata('R7_2.mat');
R7_3=importdata('R7_3.mat');
t7_1=importdata('t7_1.mat');
t7_2=importdata('t7_2.mat');
t7_3=importdata('t7_3.mat');

n=size(c1_2,1);
x=zeros(n,1);
y=zeros(n,1);
z=zeros(n,1);
R=R7_1;
t=t7_1;
for i=1:n
    [s1,~,X1,Y1]=tri(c1_2(i,:)',c2_1(i,:)',R,t);
    x(i)=X1;
    y(i)=Y1;
    z(i)=s1;
end

% rule out some far points
mid=median(sort(z));
mini=min(z);
zz=abs(z-mid);
x_s=x(zz<mid-mini);
y_s=y(zz<mid-mini);
z_s=z(zz<mid-mini);

%for convenient of 3D plot
scale=100;
z_s=z_s/scale;
x_s=x_s/scale;
y_s=y_s/scale;
scatter3(x_s,y_s,z_s,10,'b','filled');
hold on;
% take camera pose 1 as world frame
C1=cameracenter(K*eye(3,4));
C1=C1/C1(4);
scatter3(0,0,0,'r');
%text(0,0,0,'C1');
quiver3(0,0,0,0,0,1,0.5,'r');
quiver3(0,0,0,0,1,0,0.5,'g');
quiver3(0,0,0,1,0,0,0.5,'b');

hold on;
C2=cameracenter(K*[R,t]);
C2=C2/C2(4);
origin2=R'*[0;0;0]-R'*t;
origin2=origin2/scale;
pose1=R'*[0;0;1]+origin2;
pose2=R'*[0;1;0]+origin2;
pose3=R'*[1;0;0]+origin2;
% origin1=R*[0;0;0]+t;
% origin1=origin1/scale;
%origin2=origin2/origin2(3);
pose1=pose1/norm(pose1,'fro');
pose2=pose2/norm(pose2,'fro');
pose3=pose3/norm(pose3,'fro');
% scatter3(origin1(1),origin1(2),origin1(3),'g');
scatter3(origin2(1),origin2(2),origin2(3),'g');
%text(origin2(1),origin2(2),origin2(3),'C2');
quiver3(origin2(1),origin2(2),origin2(3),pose1(1),pose1(2),pose1(3),0.5,'r');
quiver3(origin2(1),origin2(2),origin2(3),pose2(1),pose2(2),pose2(3),0.5,'g');
quiver3(origin2(1),origin2(2),origin2(3),pose3(1),pose3(2),pose3(3),0.5,'b');
hold on;
view(-22,-64);
axis([-1.5 1.5 -1.5 1.5 -1 4]);
xlabel('X');
ylabel('Y');
zlabel('Z');
title('3D Plot');
hold off;

%Calculate the error
P3=[x,y,z];
number=50;
m=min([size(c2_1,1),size(c3_2,1),size(P3,1)]);
[~,index1]=intersect(c2_3,c2_1,'rows');
c=c3_2(index1(1:number),:);
[~,index2]=intersect(c2_1,c2_3(index1(1:number),:),'rows');
P=P3(index2,:);

%RA=[R7_3*t7_2,t7_3,R7_3*R7_2*t7_1];
RA=[R7_1*t7_2,R7_2*R7_1*t7_3,t7_1];
[~,~,V]=svd(RA);
S=V(:,3);
S=S/S(3);
s1=S(1);
s2=S(2);
% dist1=R7_3*R7_2*t7_1+s1*R7_3*t7_2+s2*t7_3;
% dist2=norm(R7_3*R7_2*R7_1-eye(3),'fro')
dist3=s1*R7_1*t7_2+s2*R7_2*R7_1*t7_3+t7_1;

T = DLT( c,P );
[Rt,Kt]=qr(inv(T(:,1:3)));
Rt=inv(Rt);
Kt=inv(Kt);
error=1;
for ii=1:number
fp=T*[P(ii,:),1]';
fp=fp/fp(3);
fp_e=[R7_3',-R7_3'*s2*t7_3]*[P(ii,:),1]';
% fp_e=[R7_3,s2*t7_3]*[P(1,:),1]';
fp_e=fp_e/fp_e(3);
error_t=sqrt((fp(1)-fp_e(1))^2+(fp(2)-fp_e(2))^2);
% error=norm(R7_3*Rt'-eye(3),'fro')
if error>error_t
error=error_t;
end
end
% error is from 0.0024-0.03
error

function [C]=cameracenter(P)

C=[det([P(:,2),P(:,3),P(:,4)]);
    -det([P(:,1),P(:,3),P(:,4)]);
    det([P(:,1),P(:,2),P(:,4)]);
    -det([P(:,1),P(:,2),P(:,3)])];
end




