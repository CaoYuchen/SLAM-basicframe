function [n,cc1,cc2 ] = inlier( c1,c2,R,t )
%UNTITLED13 此处显示有关此函数的摘要
%   此处显示详细说明
fx=520.9;	
fy=521.0;	
cx=325.1;	
cy=249.7;

K=[fx,0,cx;0,fy,cy;0,0,1];

n=0;
k=size(c1,1);
cc1=zeros(k,2);
cc2=zeros(k,2);

%[s1,s2]=tri(c1(i,:)',c2(i,:)',R,t); 
% X1=[c1';ones(1,k)];
% X1=K\X1;
% X1=X1./X1(3,:);
% X2=[c2';ones(1,k)];
% X2=K\X2;
% X2=X2./X2(3,:);
for i=1:k   
    [s1,s2]=tri(c1(i,:)',c2(i,:)',R,t); 
    x1=[c1(i,:)';1];
    x2 = K*(R*K^(-1)*(s1*x1)+t);
    x2_e = x2/x2(3);
    x2=[c2(i,:)';1];
%     x1=K\x1;
%     x1=x1/x1(3);
%     x2=[c2(i,:)';1];
%     x2=K\x2;
%     x2=x2/x2(3);
%     x2_e=(s1*R*x1+t)/s2;
%     x2_e=x2_e/x2_e(3);
%     x2_e=K*x2_e;
%     x2=K*x2;
    error=sqrt((x2(1)-x2_e(1))^2+(x2(2)-x2_e(2))^2);
    
    if error <=1
        n=n+1;
        cc1(n,:)=c1(i,:);
        cc2(n,:)=c2(i,:);
    end
end
% [~,index]=intersect(cc1,[0,0],'rows');
% cc1=cc1(1:index-1,:);
% cc2=cc2(1:index-1,:);
cc1(n+1:end,:)=[];
cc2(n+1:end,:)=[];


end

