function [  ] = stiching( H )
%UNTITLED6 此处显示有关此函数的摘要
%   此处显示详细说明
% e=[2476;2329;1]-R*[796;2251;1];

right=imread('right2.jpg');
left=imread('left2.jpg');
%h=im2double(left);
%size(right);
%size(left);
%err=H*[1080;1440;1]-[1080;1440;1]
%row=err[1]

%pic=zeros(1080*2,1440*2,3);
thre=0;
[row,col,z]=size(left);
[rown,coln,zn]=size(right);
up=H*[1;coln;1];
up=up/up(3);
down=H*[rown;coln;1];
down=down/down(3);

if up()
%pic=zeros(1997,3000,3);
pic = zeros(row+354, col+660,3);


%pic(1+row:1080+row,1441:2880,:)=right;

for i=1:rown
   for j=1:coln
       temp=H*[j;i;1];
       temp(3);
       temp=temp/temp(3);
       ii=thre+round(temp(2));
       jj=thre+round(temp(1));
       pic(ii,jj,:)=right(i,j,:);
       
     
      % hold on;
   end
end
pic(thre+1:thre+row,thre+1:thre+col,:)=left;

% temp1=H*[rown;coln;1];
% temp2=H*[0;0;1];
% ii=thre+round(temp1(1));
% jj=round(temp1(2));
% i=thre+round(temp2(1));
% j=round(temp2(2));
% pic(i:ii,j:jj,:)=right;
  imshow(pic);
  clear
%right*H;
end

