%CS284-SLAM Assignment3  copyright@Cao Yuchen  90878609
function [indices,n,cc1,cc2 ] = inlier( c1,c2,R,t,K )
%c1 and c2 are bearing-vector, i.e. n column [x,y,1]'
[s1,~]=tri(c1,c2,R,t,K); 
x2_e = R*s1+t;
x2_e = K*(x2_e./x2_e(3,:));
x2 = K*c2;
%calculate the error < 1
error=x2-x2_e;
error=sqrt(error(1,:).^2+error(2,:).^2);
[~,indices,]=find(error<1);
cc1=c1(:,indices);
cc2=c2(:,indices);
n=size(indices,2);
end

