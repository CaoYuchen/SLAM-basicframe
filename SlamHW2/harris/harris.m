function [ corners ] = harris( P )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
gray=rgb2gray(P);

% corner=detectHarrisFeatures(gray);
% corner=corner.selectStrongest(200);
% corners=corner.Location;

%size(corners.Location)
% imshow(gray);
% hold on;
% plot(corners);
% hold off;



gray=im2double(gray);

X=imfilter(gray,[-1 0 1]);  
X2=X.^2;  
Y=imfilter(gray,[-1 0 1]');  
Y2=Y.^2;  
XY=X.*Y;  

w=fspecial('gaussian',5,0.7);    
A=imfilter(X2,w);  
B=imfilter(Y2,w);  
C=imfilter(XY,w);

[height,width]=size(gray);
R=zeros(height,width);
%k=0.04-0.06
k=0.04;
RMax=0; 

for i=1:height
    for j=1:width
        M=[A(i,j) C(i,j);C(i,j) B(i,j)];
        R(i,j)=det(M)-k*(trace(M))^2;
        if(R(i,j)>RMax)  
            RMax=R(i,j);
        end
    end
end

Q=0.01;  
R_corner=(R>=(Q*RMax)).*R;  

% rule out the edge corner
[cn,ln]=size(R_corner);
margin=16;
edge=ones(cn-margin,ln-margin);
margin_array=padarray(edge,[margin/2,margin/2],0,'both');
R_corner=R_corner.*margin_array;

% choose the local maximum
corner_peaks=imregionalmax(R_corner);
temp=corner_peaks.*R_corner;
corner_sort=sort(temp(:),'descend');

% sort out strongest 200 corners
number=200;
corners=zeros(number,2);
for i=1:number
    [posr,posc]=find(temp==corner_sort(i));
    %[posr,posc]=find(corner_peaks==1);
    corners(i,:)=[posc,posr];
end


end

