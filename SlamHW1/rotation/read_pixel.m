function [ ] = read_pixel(  )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
h = imshow('left2.jpg');
hold on 
%scatter(569,696,'O','r');
%l = imshow('right2.jpg');
        hp = impixelinfo;
        set(hp,'Position',[5 1 300 20]);


%        hp = impixelinfo;
%        set(hp,'Position',[5 1 300 20]);

end
