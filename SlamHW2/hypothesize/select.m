function [ R_f,t_f,flag ] = select( E,c1,c2,eight )


[u,e,v]=svd(E);
 e = eye(3);e(3,3)=0;

Rz=[cos(pi/2),-sin(pi/2),0;sin(pi/2),cos(pi/2),0;0,0,1];
Rz_i=[cos(-pi/2),-sin(-pi/2),0;sin(-pi/2),cos(-pi/2),0;0,0,1];
temp=u*Rz*e*u';
t(1,:)=[temp(3,2),temp(1,3),temp(2,1)];
temp=u*Rz_i*e*u';
t(2,:)=[temp(3,2),temp(1,3),temp(2,1)];
R(1:3,:)=u*Rz'*v';
if det(R(1:3,:))<0
    R(1:3,:)=-R(1:3,:);
end
R(4:6,:)=u*Rz_i'*v';
if det(R(4:6,:))<0
    R(4:6,:)=-R(4:6,:);
end

flag=0;
n=randperm(7,1);
% % select positive depth for 4 results
xx1=[c1(n,1);c1(n,2)];
xx2=[c2(n,1);c2(n,2)];
t_f=0;
R_f=0;
if eight==0
for i=1:2
    for j=1:3:4
        [s11,s12]=tri(c1(1,:)',c2(1,:)',R(j:j+2,:),t(i,:)');
        [s21,s22]=tri(c1(2,:)',c2(2,:)',R(j:j+2,:),t(i,:)');
        [s31,s32]=tri(c1(3,:)',c2(3,:)',R(j:j+2,:),t(i,:)');
        [s41,s42]=tri(c1(4,:)',c2(4,:)',R(j:j+2,:),t(i,:)');
        [s51,s52]=tri(c1(5,:)',c2(5,:)',R(j:j+2,:),t(i,:)');
        [s61,s62]=tri(c1(6,:)',c2(6,:)',R(j:j+2,:),t(i,:)');
        [s71,s72]=tri(c1(7,:)',c2(7,:)',R(j:j+2,:),t(i,:)');
        if s11>0 && s12>0 && s21>0 && s22>0 && s31>0 && s32>0 &&s41>0 && s42>0 && s51>0 && s52>0 && s61>0 && s62>0&& s71>0 && s72>0
            flag=1;
            t_f=t(i,:)';
            R_f=R(j:j+2,:);
        end
    end
end
else
for i=1:2
    for j=1:3:4
        [s1,s2]=tri(xx1,xx2,R(j:j+2,:),t(i,:)');
        if s1>0 && s2>0 
            flag=1;
            t_f=t(i,:)';
            R_f=R(j:j+2,:);
        end
    end
end
end
end