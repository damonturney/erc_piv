%-- 3/13/14  1:38 PM --%
ls
pwd
cd C:\Documents and Settings\madhu\Desktop\Damon-Microsphere-Technique
cd 'C:\Documents and Settings\madhu\Desktop\Damon-Microsphere-Technique'
ls
cd Matlab-PIV-software\
ls
cd DAMONS_PIV_PROCESSING_SOFTWARE\
ls
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,wocofile,...
maskfile,path2meanimageA,path2meanimageB,sub_pixel,previous_u,previous_v,winsizethreshold)
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,wocofile,maskfile,path2meanimageA,path2meanimageB,sub_pixel,previous_u,previous_v,winsizethreshold)
im1='../example-images/f_001472.tif'
im2='../example-images/f_001475.tif'
winsizes=[36 36 ; 16 16]
Dt=2
winoverlaps=[0.5 0.5]
searchoverlaps=[0.9 0.9]
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,wocofile,maskfile,path2meanimageA,path2meanimageB,sub_pixel,previous_u,previous_v,winsizethreshold)
R_Threshold=0.5
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,wocofile,maskfile,path2meanimageA,path2meanimageB,sub_pixel,previous_u,previous_v,winsizethreshold)
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,1)
R_threshold=0.5
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,1)
a=imread(im1);
a
mean_of_images('../example-images/','f_',1)
dir('../example-images/')
mean_of_images('../example-images/','f_*',1)
path2meanimageB='../example-images/a_mean_image.tif'
[x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,wocofile,maskfile,path2meanimageA,path2meanimageB,1)
