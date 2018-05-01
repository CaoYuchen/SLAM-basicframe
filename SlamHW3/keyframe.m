%CS284-SLAM Assignment3  copyright@Cao Yuchen  90878609
clc
clear
close all
addpath('T');
addpath('sift_data');
addpath('opengv');
addpath('opengv-master/matlab');

file_path =  '.\rgb\';
img_path_list = dir(strcat(file_path,'*.png')); 
img_num = length(img_path_list);

fx=520.9; fy=521.0; cx=325.1; cy=249.7;
K=[fx,0,cx;0,fy,cy;0,0,1];
tx=-0.1546; ty=-1.4445; tz=1.4773; qx=0.6529; qy=-0.5483; qz=0.3248; qw=-0.4095;
pose_init=[1-2*qz^2-2*qw^2,2*qy*qz-2*qx*qw,2*qy*qw+2*qx*qz,tx;
                2*qy*qz+2*qx*qw,1-2*qy^2-2*qw^2,2*qz*qw-2*qx*qy,ty;
                2*qy*qw-2*qx*qz,2*qz*qw+2*qx*qy,1-2*qy^2-2*qz^2,tz];
% img_num=100;
%initalization
keyframes=cell(img_num,2);
keyn=1;
keyframes(keyn,1)={[pose_init; zeros(1,3),1]};
keyframes(keyn,2)={1};
%first reference frame
name=strcat('sift',num2str(1),'.mat');
sift_ref=importdata(name);
pose_key=[pose_init; zeros(1,3),1];

for j=2:img_num
    j
    %read sift features and descriptors
%     name=strcat('T',num2str(j),'_',num2str(j-1),'.mat');
%     T=importdata(name);
    name=strcat('sift',num2str(j),'.mat');
    sift_cur=importdata(name);
    %match sift features
    [matches, ~] = vl_ubcmatch(sift_ref.descriptors,sift_cur.descriptors);
    numbers=size(matches,2);
    coordinates_ref=K\[sift_ref.features(1:2,matches(1,:));ones(1,numbers)];
    coordinates_cur=K\[sift_cur.features(1:2,matches(2,:));ones(1,numbers)]; 
    %calculate relative T
    coor1_norm=coordinates_ref./repmat(sqrt(sum(coordinates_ref.*coordinates_ref)),3,1);
    coor2_norm=coordinates_cur./repmat(sqrt(sum(coordinates_cur.*coordinates_cur)),3,1);
    [X,indices]=opengv('fivept_stewenius_ransac',coor1_norm,coor2_norm);
    X_best = X; indices_best = indices;
    for i=1:5
        [X,indices]=opengv('fivept_stewenius_ransac', coor1_norm,coor2_norm);
        if size(indices,2) > size(indices_best,2)
            indices_best = indices; X_best = X;
        end
    end
    T=opengv('rel_nonlin_central',double(indices_best),coor1_norm,coor2_norm,X_best);
    % choose keyframes        
    pose_rel=[T; zeros(1,3),1];
    rota=pose_rel(1:3,1:3)*coordinates_cur;
    dis=K*rota./rota(3,:)-K*coordinates_ref;
    disparities=sqrt(dis(1,:).^2+dis(2,:).^2);
    disparity=median(disparities);
      
    if disparity>15       
        keyn=keyn+1;
        %rescale the first norm(t)=1
        if keyn==2
            pose_rel(1:3,4)=pose_rel(1:3,4)/norm(pose_rel(1:3,4),'fro');
        %rescale the rest translations
        elseif keyn>=3
            %find correspondences among 3 frames
            features_ref=sift_ref.features(:,matches(1,:));
            features_cur=sift_cur.features(:,matches(2,:));
            [matches2, ~]=vl_ubcmatch(sift_ref.descriptors(:,matches(1,:)),sift_pre.descriptors);
            numbers2=size(matches2,2);
            coor_mid=K\[features_ref(1:2,matches2(1,1:numbers2));ones(1,numbers2)];
            coor_pre=K\[sift_pre.features(1:2,matches2(2,1:numbers2));ones(1,numbers2)];
            coor_nex=K\[features_cur(1:2,matches2(1,1:numbers2));ones(1,numbers2)]; 
%             A=K*coor_mid; B=K*coor_pre; C=K*coor_nex;
%             scatter(A(1,:),A(2,:),'b'); hold on; scatter(B(1,:),B(2,:),'r'); hold on; scatter(C(1,:),C(2,:),'g'); hold off;
            %rescale translation
            [s_pre,~]=tri( coor_mid,coor_pre,pose_pre(1:3,1:3),pose_pre(1:3,4),K);
            [~,s_cur]=tri( coor_nex,coor_mid,pose_rel(1:3,1:3),pose_rel(1:3,4),K);
            scales=s_pre(3,:)./s_cur(3,:);
            scale=median(scales);
            pose_rel(1:3,4)=pose_rel(1:3,4)*scale;
        end
        %point clouds
        [~,weight,coordinates2,coordinates1]=inlier( coordinates_cur,coordinates_ref,...
                                                                                    pose_rel(1:3,1:3),pose_rel(1:3,4),K );
        [~,pointclouds]=tri( coordinates2,coordinates1,pose_rel(1:3,1:3),pose_rel(1:3,4),K);                   
        pointclouds=pose_key(1:3,1:3)*pointclouds+pose_key(1:3,4);
        weight=weight/numbers;
        %update parameters
        sift_pre=sift_ref;
        sift_ref=sift_cur;
        pose_key=pose_key*pose_rel;
        pose_pre=pose_rel;
        if j<2645
        keyframes(keyn,1)={pose_key};  keyframes(keyn,2)={weight};  looppair=[j,keyn];
        end
    end    
end
keyframes(cellfun(@isempty,keyframes))=[];
keyframes=reshape(keyframes,[],2);

%visualization
positions=cell2mat(keyframes(:,1));
locations=reshape(positions(:,4),4,[]);
directions=reshape(positions(:,1:3)*[0;0;0.1],4,[]);
numbers=size(keyframes,1);
scatter3(locations(1,:),locations(2,:),locations(3,:),'b');hold on;
scatter3(locations(1,:)+directions(1,:),locations(2,:)+directions(2,:),locations(3,:)+directions(3,:),'b*');
for i=1:numbers
    hold on; line([locations(1,i),locations(1,i)+directions(1,i)],...
    [locations(2,i),locations(2,i)+directions(2,i)],[locations(3,i),locations(3,i)+directions(3,i)]);
end
hold off;
% save data
out_path_keyframes= '.\keyf\';
name='keyf';
path=strcat(out_path_keyframes,name);
save (path,'keyframes');
name='looppair';
path=strcat(out_path_keyframes,name);
save (path,'looppair');