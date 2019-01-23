function [mean_image]=mean_of_images(path2images,image_names,save)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: August 20 2004
%
% Description: reads in all the images in the current directory that have a name
%              matched by the string image_names (which can include a wild character)
%
%               Saves the result
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

images_list=dir([path2images image_names]);
disp([num2str(size(images_list,1)) ' images to average.'])

if size(images_list,1)>1
    sum=double(imread([path2images images_list(1).name]));
    for i=1:size(images_list,1)
        disp(['On image ' num2str(i) '.'])
        sum=sum+double(imread([path2images images_list(i).name]));
    end
end

mean_image=uint8(round(sum/i));

if save==1
    imwrite(mean_image,[path2images 'a_mean_image.tif'],'tif');
end


        

