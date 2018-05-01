function [ countn,cc1,cc2,R_f,t_f ] = seven( c1,c2 )


fx=520.9;	
fy=521.0;	
cx=325.1;	
cy=249.7;

K=[fx,0,cx;
   0,fy,cy;
   0,0,1];

length=640;
width=480;
Kn=[2/length,0,-1;
    0,2/width,-1;
    0,0,1];

% Kn = eye(3,3);
n=size(c2,1);
random=randperm(n,7);

x1=m(c1(random(1),1),c1(random(1),2),c2(random(1),1),c2(random(1),2));
x2=m(c1(random(2),1),c1(random(2),2),c2(random(2),1),c2(random(2),2));
x3=m(c1(random(3),1),c1(random(3),2),c2(random(3),1),c2(random(3),2));
x4=m(c1(random(4),1),c1(random(4),2),c2(random(4),1),c2(random(4),2));
x5=m(c1(random(5),1),c1(random(5),2),c2(random(5),1),c2(random(5),2));
x6=m(c1(random(6),1),c1(random(6),2),c2(random(6),1),c2(random(6),2));
x7=m(c1(random(7),1),c1(random(7),2),c2(random(7),1),c2(random(7),2));

X=[x1;x2;x3;x4;x5;x6;x7];
[~,~,V]=svd(X);
F1=reshape(V(:,8),[3,3])';
F2=reshape(V(:,9),[3,3])';

% syms lemda;
% res=solve(det(F1+F2*lemda)==0,lemda);
% res=double(res);
res=eig(-inv(F2)*F1);
size(res);
re=real(res(abs(imag(res))<0.0001));
%choose best of three eigen
count_last=0;
countn=0;
cc1=0;
cc2=0;
F=0;
R_f=0;
t_f=0;

if size(re,1)==3
    for i=1:3
        E_t=K'*Kn'*(F1+F2*re(i,1))*Kn*K;
        [ R_ft,t_ft,mark ] = select( E_t,c1(random,:),c2(random,:),0);
        if mark==0
            return;
        end
        [count,~,~]  = inlier( c1,c2,R_ft,t_ft );
        if count>count_last
            F=Kn'*(F1+F2*re(i,1))*Kn;
            count_last=count;
        end
        
    end
           
% elseif size(re,1)==2
%    for i=1:2
%         E_t=K'*inv(Kn)'*(F1+F2*re(i))*(Kn\K);
%         [ R_ft,t_ft,mark ] = select( E_t,c1(random,:),c2(random,:));
%         if mark==0
%             return;
%         end
%         [count,~,~]  = inlier( c1,c2,R_ft,t_ft );
%         if count>count_last
%             F=F1+F2*re(i);
%             count_last=count;
%         end
%         
%    end
elseif size(re,1)==1
    F=Kn'*(F1+F2*re(1))*Kn;
end


if F==0
    return;
end
E=K'*F*K;
[ R_f,t_f,mark ] = select( E,c1(random,:),c2(random,:),0 );
if mark==0
    return;
end
[countn,cc1,cc2]  = inlier( c1,c2,R_f,t_f );

end

function [ left ] = m( u2,v2,u1,v1 )
%normalization
length=640;
width=480;
K=[2/length,0,-1;0,2/width,-1;0,0,1];
% K = eye(3,3);
% fx=520.9;	
% fy=521.0;	
% cx=325.1;	
% cy=249.7;
% 
% K=[fx,0,cx;0,fy,cy;0,0,1];

s1=K*[u1;v1;1];
s2=K*[u2;v2;1];
s1=s1/s1(3,1);
s2=s2/s2(3,1);
u1=s1(1,1);
v1=s1(2,1);
u2=s2(1,1);
v2=s2(2,1);
% left = [u1*u2, v1*u2 u2 u1*v2 v1*v2 v2 u1 v1 1];
left=[u1*u2,u1*v2,u1,v1*u2,v1*v2,v1,u2,v2,1];
end
