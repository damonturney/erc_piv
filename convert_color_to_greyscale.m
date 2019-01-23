function convert_color_to_greyscale(path2images,image_names)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: February 20 2016
%
% Description: converts color images to greyscale
%
%               Saves the result
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


images_list=dir([path2images image_names]);
image_list2=char({images_list.name});

disp([num2str(length(image_list2)) ' images to average.'])

if length(image_list2)>1
    for i=1:size(image_list2,1)
        disp(['On image ' num2str(i) '.'])
        imwrite(mean(imread([path2images image_list2(i,1:end)]),3)/255,[path2images 'grey_' image_list2(i,1:end)],'tif');
    end
end
