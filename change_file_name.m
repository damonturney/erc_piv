function change_file_name(path2images,initial_filename_prefix,desired_filename_prefix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: February 20 2016
%
% Description: converts color images to greyscale
%
%               Saves the result
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


images_list=dir([path2images initial_filename_prefix]);
image_list2=char({images_list.name});

disp([num2str(length(image_list2)) ' images to rename.'])

if length(image_list2)>1
    for i=1:size(image_list2,1)
        disp(['On image ' num2str(i) '.'])
        movefile([path2images image_list2(i,1:end)],[path2images desired_filename_prefix image_list2(i,end-9:end)]);
    end
end




        

