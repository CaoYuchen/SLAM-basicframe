%CS284-SLAM Assignment3  copyright@Cao Yuchen  90878609
function [ coordinates1, coordinates2 ] = match( descriptors1,descriptors2,features1,features2,numbers,K )
%input is pixel and output is plane-vector
[matches, scores] = vl_ubcmatch(descriptors1, descriptors2);
sortmatch=sortrows([matches;scores]',3)';
coordinates1=features1(1:2,sortmatch(1,1:numbers));
coordinates2=features2(1:2,sortmatch(2,1:numbers));
coordinates1=K\[coordinates1;ones(1,numbers)];
coordinates2=K\[coordinates2;ones(1,numbers)]; 

end

