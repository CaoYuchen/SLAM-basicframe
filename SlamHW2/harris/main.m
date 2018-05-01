clear;
close all;

P1=imread('1.png');
corners1=harris(P1);
% t1=getpatch(corners1.Location,P1);
t1=getpatch(corners1,P1);

 P2=imread('2.png');
 corners2=harris(P2);
%  t2=getpatch(corners2.Location,P2);
t2=getpatch(corners2,P2);
 
 P3=imread('3.png');
 corners3=harris(P3);
%  t3=getpatch(corners3.Location,P3);
 t3=getpatch(corners3,P3);
 
%  [coordinates1,coordinates2]=ssd(t1,t2,corners1.Location,corners2.Location);
%  [coordinates1,coordinates3]=ssd(t1,t3,corners1.Location,corners3.Location);
 [coordinates1_2,coordinates2_1]=ssd(t1,t2,corners1,corners2);
 [coordinates3_1,coordinates1_3]=ssd(t3,t1,corners3,corners1);
 [coordinates2_3,coordinates3_2]=ssd(t2,t3,corners2,corners3);
 
 
 
%  imshow(P1);
%  hold on;
% %  scatter(corners1(:,1),corners1(:,2),'r');
%  scatter(corners1(:,1),corners1(:,2),'r');
%  hold on;
% % scatter(corners2(:,1),corners2(:,2),'g');
% scatter(corners2(:,1),corners2(:,2),'g');
%  hold on;
%  for i=1:size(coordinates1_2,1)
%     X=[coordinates1_2(i,1),coordinates2_1(i,1)];
%     Y=[coordinates1_2(i,2),coordinates2_1(i,2)];
%     line(X,Y,'color','b');
%     hold on;
%  end
%  hold off;

% 
%  imshow(P2);
%  hold on;
% %  scatter(corners2(:,1),corners2(:,2),'r');
%  scatter(corners2(:,1),corners2(:,2),'r');
%  hold on;
% % scatter(corners3(:,1),corners3(:,2),'g');
% scatter(corners3(:,1),corners3(:,2),'g');
%  hold on;
%  for i=1:size(coordinates2_3,1)
%     X=[coordinates2_3(i,1),coordinates3_2(i,1)];
%     Y=[coordinates2_3(i,2),coordinates3_2(i,2)];
%     line(X,Y,'color','b');
%     hold on;
%  end
%  hold off;
  

 imshow(P1);
 hold on;
%  scatter(corners1.Location(:,1),corners1.Location(:,2),'r');
 scatter(corners1(:,1),corners1(:,2),'r');
 hold on;
 scatter(corners3(:,1),corners3(:,2),'g');
 hold on;
 for i=1:size(coordinates1_3,1)
    X=[coordinates1_3(i,1),coordinates3_1(i,1)];
    Y=[coordinates1_3(i,2),coordinates3_1(i,2)];
    line(X,Y,'color','b');
    hold on;
 end
 hold off;

 
 save ('..\hypothesize\correspondences1_2.mat','coordinates1_2');
 save ('..\hypothesize\correspondences2_1.mat','coordinates2_1');
 save ('..\hypothesize\correspondences1_3.mat','coordinates1_3');
 save ('..\hypothesize\correspondences3_1.mat','coordinates3_1');
 save ('..\hypothesize\correspondences2_3.mat','coordinates2_3');
 save ('..\hypothesize\correspondences3_2.mat','coordinates3_2');
 