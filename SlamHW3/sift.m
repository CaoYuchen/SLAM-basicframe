%CS284-SLAM Assignment3  copyright@Cao Yuchen  90878609
clc
clear
close all
addpath('opengv');
addpath('opengv-master/matlab');
%before run this script, please first run vl_setup under vl_feat

file_path =  '.\rgb\';
img_path_list = dir(strcat(file_path,'*.png')); 
img_num = length(img_path_list);

out_path_sift = '.\sift_data\';
out_path_T='.\T\';
if img_num > 0  
        for j = 1:img_num-1  
            % first frame
            image_name = img_path_list(j).name;
            image1 =  imread(strcat(file_path,image_name)); 
            image = single(rgb2gray(image1)) ;     
            [ features1,descriptors1 ]=vl_sift(image);
            % second frame
            image_name = img_path_list(j+1).name;
            image2 =  imread(strcat(file_path,image_name)); 
            image = single(rgb2gray(image2)) ;
            [ features2,descriptors2 ]=vl_sift(image);
            % match 
            [matches, scores] = vl_ubcmatch(descriptors1, descriptors2) ;      
            % choose first 300 correspondences
            numbers=size(matches,2);
            coordinates1=features1(1:2,matches(1,:));
            coordinates2=features2(1:2,matches(2,:));     
            % plot
%             pic=cat(2,image1,image2);
%             figure(1), imshow(pic);
%             hold on, scatter(coordinates1(1,:),coordinates1(2,:),'b');
%             hold on, scatter(double(size(image1,2))+coordinates2(1,:),coordinates2(2,:),'b');
%             for i=1:numbers
%                  hold on, line([coordinates1(1,i),double(size(image1,2))+coordinates2(1,i)],[coordinates1(2,i),coordinates2(2,i)]);
%             end
%             hold off;

            % calculate Essential Matrix
            fx=520.9; fy=521.0; cx=325.1; cy=249.7;
            K=[fx,0,cx;0,fy,cy;0,0,1];
            
            coordinates1=K\[coordinates1;ones(1,numbers)];
            coordinates2=K\[coordinates2;ones(1,numbers)];          
            coor1_norm=coordinates1./repmat(sqrt(sum(coordinates1.*coordinates1)),3,1);
            coor2_norm=coordinates2./repmat(sqrt(sum(coordinates2.*coordinates2)),3,1);
            
            [X,indices]=opengv('fivept_stewenius_ransac',coor1_norm,coor2_norm);
            X_best = X;
            indices_best = indices;
            for i=1:5
                [X,indices]=opengv('fivept_stewenius_ransac', coor1_norm,coor2_norm);
                if size(indices,2) > size(indices_best,2)
                    indices_best = indices;
                    X_best = X;
                end
            end
            T=opengv('rel_nonlin_central',double(indices_best),coor1_norm,coor2_norm,X_best);
            %check the error of R and t
            [pointcloud2,pointcloud1]=tri(coordinates2,coordinates1,T(1:3,1:3),T(1:3,4),K);
            kk=T(1:3,1:3)*pointcloud2+T(1:3,4);
            kk=K*(kk./kk(3,:)-coordinates1);
            error=sqrt(kk(1,:).^2+kk(2,:).^2);
            % choose inliers
            [indices,numbers,coordinates2,coordinates1 ] = inlier( coordinates2,coordinates1,T(1:3,1:3),T(1:3,4),K );
            % plot the correspondences
            pic=cat(2,image1,image2);
            coordinates2=K*coordinates2; coordinates1=K*coordinates1;
            figure(1), imshow(pic);
            hold on, scatter(coordinates1(1,:),coordinates1(2,:),'b');
            hold on, scatter(double(size(image1,2))+coordinates2(1,:),coordinates2(2,:),'b');
            for i=1:numbers
                 hold on, line([coordinates1(1,i),double(size(image1,2))+coordinates2(1,i)],[coordinates1(2,i),coordinates2(2,i)]);
            end
            hold off;
            %save data
            name=strcat('T',num2str(j+1),'_',num2str(j));
            path=strcat(out_path_T,name);
            save (path,'T');
            if j==1
                features=features1; descriptors=descriptors1;
                name=strcat('sift',num2str(j));
                path=strcat(out_path_sift,name);
                save(path,'features','descriptors');
            end
            features=features2; descriptors=descriptors2;
            name=strcat('sift',num2str(j+1));
            path=strcat(out_path_sift,name);
            save (path,'features','descriptors');
            j
        end  
end  


