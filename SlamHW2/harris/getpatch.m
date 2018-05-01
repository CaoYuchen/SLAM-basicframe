function [ t ] = getpatch( c,p )
%UNTITLED9 此处显示有关此函数的摘要
%   此处显示详细说明
kernel=15;
k=floor(kernel/2);
w=1;%fspecial('gaussian',kernel,10); 
row=size(c,1);
t=zeros(row,kernel,kernel);
p=rgb2gray(p);
pp=im2double(p);
p_pad=padarray(pp,[k,k],'replicate','both');
for i=1:row
     
%   size(w)
    coln=(floor(c(i,1)));
    rown=(floor(c(i,2)));
 %  size(p_pad(c(i,1):(c(i,1)+2*k),c(i,2):(c(i,2)+2*k)))
 %  size(w)
    t(i,1:kernel,1:kernel)=w.*p_pad(rown:(rown+2*k),coln:(coln+2*k));
    
 %   zero normalization does not yield a good result, why?
 %   t(i,1:kernel,1:kernel)=t(i,1:kernel,1:kernel)-mean(mean(mean(t(i,1:kernel,1:kernel))));
end
%t=t-mean(mean(pp));    

end

