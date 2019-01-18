%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: September 05 2007
%
% Description: Uses MatPIV to create velocity vectors
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
close all
clear all
fprintf('\n\n\n\n\n\n\n');
if ~(any(findstr(path,'PIV_PROCESSING_SOFTWARE')) | any(findstr(path,'piv_processing_software')))
	addpath ~/DAMONS_PIV_PROCESSING_SOFTWARE;
	addpath ~/DAMONS_PIV_PROCESSING_SOFTWARE/naninterp;
	addpath ~/DAMONS_PIV_PROCESSING_SOFTWARE/masking;
	addpath ~/DAMONS_PIV_PROCESSING_SOFTWARE/filters;
	addpath ~/DAMONS_PIV_PROCESSING_SOFTWARE/pixels2worldcoordinates;
end
path2rawimages='rawimages/';
path2output2='';
path2worldcofile='worldco.mat';
path2maskfile='polymask.mat';
path2meanimage='a_mean_image.tif';




good_images=[1:10:1491];  % alternatives -->  100:10:1590    1:10:1491     1:10:1191
fps=500;
cameraorientation='sideways'; % alternatives --> 'sideways'  'normal'
skip=0;
dT=(1/fps)*(skip+1);








if strcmp(cameraorientation,'sideways')
    winsizes=[[128 2]];
    searchoverlaps=[[0.25 0 1 1]];  %[up down left right]
    overlaps=[[0.5 0.5]];        %[up/down  left/right]
else
    winsizes=[[2 128]];
    searchoverlaps=[[1 1 0.25 0]];  %[up down left right]  
    overlaps=[[0 0]];             %[up/down  left/right]
end



i=0;
for image_number=good_images
    i=i+1;
    fprintf('\n\n');
    disp(['Processing Image #' num2str(image_number)])

	zeros='00';
	if image_number < 1000,  zeros='000'; end;
	if image_number < 100, zeros='0000'; end;
	if image_number < 10, zeros='00000'; end;
	image_filename= [path2rawimages 'f_' zeros num2str(image_number)   '.tif'];
	image_filename2=[path2rawimages 'f_' zeros num2str(image_number+skip+1) '.tif'];
    
    [x,y,u,v,R_mins]=multimqdpiv(image_filename,image_filename2,winsizes,dT,overlaps,searchoverlaps, path2worldcofile,path2maskfile,path2meanimage);
    
    if strcmp(cameraorientation,'normal')
        u_profiles(:,i)=u(:,2);
    else
        u_profiles(i,:)=u(2,:);
    end
    
end

if strcmp(cameraorientation,'normal')
    y2=y(:,2);
else
    y2=y(2,:);
end

if strcmp(computer,'PCWIN')
    save([path2output2 'u_profiles' ], 'y2', 'u_profiles') 
else
    save([path2output2 'u_profiles' ], 'y2', 'u_profiles','-v6')
end

disp(['Finished at ' datestr(now,0)])