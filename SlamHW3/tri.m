%CS284-SLAM Assignment3  copyright@Cao Yuchen  90878609
function [ s1,s2 ] = tri( x1,x2,R,t,K )
%input of x1 and x2 are plane-vector, i.e. [x,y,1]'
x1=K*x1;
x2=K*x2;
P1=K*[eye(3),zeros(3,1)];
P2=K*[R,t];
s1=zeros(3,size(x1,2)); s2=s1;
for i=1:size(x1,2)
    A=[x1(1,i)*P1(3,:)-P1(1,:);
        x1(2,i)*P1(3,:)-P1(2,:);
        x2(1,i)*P2(3,:)-P2(1,:);
        x2(2,i)*P2(3,:)-P2(2,:)];
    [~,~,V]=svd(A);
    threed=V(:,end);
    threed=threed/threed(4);
    s1(:,i)=threed(1:3);
    s2(:,i)=K\P2*threed;
end

end

