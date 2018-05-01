# SLAM-basicframe

**SLAMHW1/rotation**

Calculating Rotation matrix with Homography Matrix.

**SLAMHW2/harris**

Extract Harris Corner feature along the image. The dataset is TUM RGBD Freiburg2 desk sequence: https://vision.in.tum.de/data/datasets/rgbd-dataset/download

Stablish  correspondences  between  each  pair  of  images  by simple  SSD  patch  comparison. For  each  match,  draw  a  line  segment  between  the coordinates of the matched features (both in the first image).

**SLAMHW2/hypothesize**

Implement  a  simplified  hypothesize-and‐test  algorithm  to  compute  the  fundamental  matrix between each pair of views using the seven‐point algorithm. Chose an inlier threshold of about 1 pixel. In each iteration, take 7 random correspondences, compute the fundamental matrix, decompose it into rotation and translation, and then find out via triangulation and reprojection how many points will be classified  as  inliers  for  each  hypothesis.  Retain  the  hypothesis  with  the  highest  number  of  inliers. Finally, recompute the fundamental matrix with all inliers using the eight‐point algorithm. Essential matrices are obtained by applying the intrinsic camera calibration matrix to the fundamental matrix. To  conclude  this  point,  verify  that  a  sequence  of  three  rotations  results  approximately  in  identity (using the Frobenius norm). Rerun the experiment until this condition is met. Rescale the translation vectors such that, again, the sequence of the three translation vectors results in approximately a zero vector.

**SLAMHW2/plot3D**

plot 3D camera pose points

**SLAMHW3**

Use SIFT to extract feature.

Use OpenGV to calculate more accurate camera matrix: http://laurentkneip.github.io/opengv/page_matlab.html

Use the homography at infinity to “unrotate” the keypoints in one of the views, and compute a robust disparity measurement (i.e. take the median of the remaining disparities). Set the current frame as the new reference frame whenever the robust disparity measure exceeds a given threshold (e.g. 15 pixels). Moreover, rescale the relative translation by making sure that the depths of old points stays about the same.

Extract the relative pose between all neighbouring keyframes (including the loop closing pair), and also an approximate diagonal information matrix where the magnitude of the values along the diagonal are simply given as a suitable function of the number of observations between the two respective images. Assume the relative poses and information matrices as fixed measurements. Define a non‐linear function that computes the residual errors inside a pose graph w.r.t. these measurements, and as a function of variations of the absolute pose of the keyframes (expressed as a translation and an axis-‐angle rotation). For the initial poses, the error should be large at the loop closing pair, but zero for all other edges in the graph.

