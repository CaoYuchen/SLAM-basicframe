%CS284-SLAM Assignment3  copyright@Cao Yuchen  90878609
clc
clear
close all
addpath('sift_data');
addpath('opengv');
addpath('opengv-master/matlab');

file_path =  '.\rgb\';
img_path_list = dir(strcat(file_path,'*.png')); 
img_num = length(img_path_list);

% mannually choose loop closure pair
fx=520.9; fy=521.0; cx=325.1; cy=249.7;
K=[fx,0,cx;0,fy,cy;0,0,1];

name=strcat('sift',num2str(1),'.mat');
sift_begin=importdata(name);
name='.\keyf\looppair.mat';
looppair=importdata(name);
name=strcat('sift',num2str(looppair(1)),'.mat');
sift_end=importdata(name);
% choose correspondences
[matches, ~] = vl_ubcmatch(sift_begin.descriptors, sift_end.descriptors) ;      
numbers=size(matches,2);
coordinates_begin=K\[sift_begin.features(1:2,matches(1,:));ones(1,numbers)];
coordinates_end=K\[sift_end.features(1:2,matches(2,:));ones(1,numbers)];          
coor1_norm=coordinates_begin./repmat(sqrt(sum(coordinates_begin.*coordinates_begin)),3,1);
coor2_norm=coordinates_end./repmat(sqrt(sum(coordinates_end.*coordinates_end)),3,1);
% calculate relative R and t of loop pair
[X,indices]=opengv('fivept_stewenius_ransac',coor1_norm,coor2_norm);
X_best = X; indices_best = indices;
for i=1:5
    [X,indices] = opengv('fivept_stewenius_ransac', coor1_norm,coor2_norm);
    if size(indices,2) > size(indices_best,2)
        indices_best = indices; X_best = X;
    end
end
T=opengv('rel_nonlin_central',double(indices),coor1_norm,coor2_norm,X);
%read absolute poses
name='.\keyf\keyf.mat';
keyframes=importdata(name);
pose_abs=cell2mat(keyframes(:,1));
weight=cell2mat(keyframes(:,2));
% calculate relative R and t of other frames
temp=[eye(4);pose_abs(1:end-4,:)];
numbers=size(keyframes,1);
pose_rel=zeros(numbers*4,4);
j=1; i=1; weights=zeros(numbers*6,6); X0=zeros(numbers*6,1);
for k=1:numbers
pose_rel(i:i+3,:)=pose_abs(i:i+3,:)\temp(i:i+3,:);
weights(j:j+5,:)=weight(k)*eye(6);
% weights(j:j+5,:)=eye(6);
temp2=vrrotmat2vec(pose_abs(i:i+2,1:3));
X0(j:j+5)=[pose_abs(i:i+2,4);temp2(1:3)'/norm(temp2(1:3),2)*temp2(4)];
j=j+6; i=i+4;
end
%optimization
options=optimoptions(@lsqnonlin,'Display','iter','Algorithm','levenberg-marquardt','MaxIteration',200);
w=weights(7:end,:); z=pose_rel(5:end,:); T=[T;zeros(1,3),1]; x0=X0(7:end); T_init=pose_abs(1:4,:);
[X,resnorm,residual,exitflag,output]=lsqnonlin(@(x) nonlinear(x,w,z,T,T_init),x0,[],[],options);
%visualization
X=[X0(1:6);X];
plot3(X(1:6:end-5),X(2:6:end-4),X(3:6:end-3),'b-'); hold on;
positions=cell2mat(keyframes(:,1));
locations=reshape(positions(:,4),4,[]);
plot3(locations(1,:),locations(2,:),locations(3,:),'r-');hold off;


function [ error ] = nonlinear( x, w, z, T,T_init )
    %loop pair
    error=zeros(size(x,1)+12,1);
    numbers=size(w,1);
    loop=numbers-5;
    T1=T_init;
    R2=vrrotvec2mat([x(loop+3:loop+5)'/norm(x(loop+3:loop+5),2),norm(x(loop+3:loop+5),2)]);  t2=x(loop:loop+2);
    T2=[R2,t2;zeros(1,3),1];
    T_err=T*T2\T1;
    err=vrrotmat2vec(T_err(1:3,1:3));
    err=[T_err(1:3,4);err(1:3)'/norm(err(1:3),2)*err(4)];
    error(1:6)=eye(6)*err;
    %first and second frame
    R2=vrrotvec2mat([x(4:6)'/norm(x(4:6),2),norm(x(4:6),2)]);  t2=x(1:3);
    T2=[R2,t2;zeros(1,3),1];
    T_err=z(1:4,:)*T_init\T2;
    err=vrrotmat2vec(T_err(1:3,1:3));
    err=[T_err(1:3,4);err(1:3)'/norm(err(1:3),2)*err(4)];
    error(7:12)=sqrt(w(1:6,:))*err;
    %nonliear function
    for i=1:6:numbers-6
        R1=vrrotvec2mat([x(i+3:i+5)'/norm(x(i+3:i+5),2),norm(x(i+3:i+5),2)]);  t1=x(i:i+2);
        T1=[R1,t1;zeros(1,3),1];
        R2=vrrotvec2mat([x(i+9:i+11)'/norm(x(i+9:i+11),2),norm(x(i+9:i+11),2)]);  t2=x(i+6:i+8);
        T2=[R2,t2;zeros(1,3),1];
        T_err=z((i-1)/6*4+5:(i-1)/6*4+8,:)*T1\T2;
        err=vrrotmat2vec(T_err(1:3,1:3));
        err=[T_err(1:3,4);err(1:3)'/norm(err(1:3),2)*err(4)];
        error(i+12:i+17,1)=sqrt(w(i+6:i+11,:))*err;
    end
end

