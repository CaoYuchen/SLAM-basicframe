function [ co1,co2 ] = ssd( t1,t2,c1,c2 )
%UNTITLED7 此处显示有关此函数的摘要
%   此处显示详细说明
%kernel=5;
row=size(t1,1);
sd=zeros(row,1);
coordinates1=c1;
coordinates2=zeros(row,2);
for j=1:row
    for i=1:row
    s=t1(j,:,:)-t2(i,:,:);
    sd(i)=sum(sum(s.^2));
    end
    
    [~,index]=min(sd);
  %  t=sum(abs(c1(j,1)-c2(index,1))+abs(c1(j,2)-c2(index,2)));
  
    coordinates2(j,:)=[c2(index,1),c2(index,2)];
end

t=sum(abs(coordinates1-coordinates2),2);
mid=median(t);
t=abs(t-mid);
[~,ii]=sort(t,'ascend');
I=ii(1:130);
co1=coordinates1(I,:);
co2=coordinates2(I,:);
 
end

