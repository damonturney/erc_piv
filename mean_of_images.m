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
image_list2=char({images_list.name});

image_list2(1,1:end)
sum=double(imread([path2images image_list2(1,1:end)]));
counter=1;

disp([num2str(length(image_list2)) ' images to average.'])

if length(image_list2)>1
    for i=2:length(image_list2)
        counter=counter+1;
        disp(['On image ' num2str(counter) '.'])
        sum=sum+double(imread([path2images image_list2(i,1:end)]));
    end
end

mean_image=uint8(round(sum./counter));



if save==1
    imwrite(mean_image,[path2images 'a_mean_image.tif'],'tif');
end


        

