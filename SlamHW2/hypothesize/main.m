clc;
clear; 

tic
c1_2=importdata('correspondences1_2.mat');
c2_1=importdata('correspondences2_1.mat');
c1_3=importdata('correspondences1_3.mat');
c3_1=importdata('correspondences3_1.mat');
c2_3=importdata('correspondences2_3.mat');
c3_2=importdata('correspondences3_2.mat');




% error = 0.2530
iteration=1000;
max1=0;
max2=0;
max3=0; 

for i=1:iteration
    
    [n1,cc1_1,cc2_1,R_f1,t_f1]=seven(c1_2,c2_1);
    if n1>max1
        R7_1=R_f1;
        t7_1=t_f1;
        C1_2=cc1_1;
        C2_1=cc2_1;
        max1=n1;
    end
end  
for i=1:iteration
    [n2,cc1_2,cc2_2,R_f2,t_f2]=seven(c2_3,c3_2);
    if n2>max2
        R7_2=R_f2;
        t7_2=t_f2;
        C2_3=cc1_2;
        C3_2=cc2_2;
        max2=n2;
    end
end
for i=1:iteration  
    [n3,cc1_3,cc2_3,R_f3,t_f3]=seven(c3_1,c1_3);
    if n3>max3
        R7_3=R_f3;
        t7_3=t_f3;
        C3_1=cc1_3;
        C1_3=cc2_3;
        max3=n3;
    end
    
end


%  error=2;
%  while error>0.1
[ R8_1,t8_1 ] = eight( C1_2,C2_1 );
[ R8_2,t8_2 ] = eight( C2_3,C3_2 );
[ R8_3,t8_3 ] = eight( C3_1,C1_3 );

for i=1:40   
    [s1,s2]=tri(C1_2(i,:)',C2_1(i,:)',R7_1,t7_1)
end

error=norm(R8_1*R8_2*R8_3-diag([1,1,1]),'fro')
%  end
% error


%  save ('..\plot3D\C1_2.mat','C1_2');
%  save ('..\plot3D\C2_1.mat','C2_1');
%  save ('..\plot3D\C1_3.mat','C1_3');
%  save ('..\plot3D\C3_1.mat','C3_1');
%  save ('..\plot3D\C2_3.mat','C2_3');
%  save ('..\plot3D\C3_2.mat','C3_2');
%  
%  save ('..\plot3D\R8_1.mat','R8_1');
%  save ('..\plot3D\t8_1.mat','t8_1');
%  save ('..\plot3D\R8_2.mat','R8_2');
%  save ('..\plot3D\t8_2.mat','t8_2');
%  save ('..\plot3D\R8_3.mat','R8_3');
%  save ('..\plot3D\t8_3.mat','t8_3');
%  
%  save ('..\plot3D\R7_1.mat','R7_1');
%  save ('..\plot3D\t7_1.mat','t7_1');
%  save ('..\plot3D\R7_2.mat','R7_2');
%  save ('..\plot3D\t7_2.mat','t7_2');
%  save ('..\plot3D\R7_3.mat','R7_3');
%  save ('..\plot3D\t7_3.mat','t7_3');
 
 toc
