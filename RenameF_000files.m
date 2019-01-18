%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: August 20 2004
%
% Description: finds files named "f_000xxx.tif" in the current directory and renames them f_000yyy.tif where the yyy
%              is a greater number than xxx  
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function RenameF_000files(number)

images_list=dir(['f_0*']);
images_list2=char({images_list.name});

if length(images_list2) == 0
    disp('no files found')
end

for i=1:length(images_list2)
    filenumber=str2num(images_list2(i,3:8));
    filenumber=filenumber+number;
    if filenumber >= 10000
        system(['mv ' images_list2(i,:) ' ' images_list2(i,1:2) '0' num2str(filenumber) '.tif']);
    elseif filenumber >= 1000
        system(['mv ' images_list2(i,:) ' ' images_list2(i,1:2) '00' num2str(filenumber) '.tif']);
    elseif filenumber >= 100
        system(['mv ' images_list2(i,:) ' ' images_list2(i,1:2) '000' num2str(filenumber) '.tif']);
    elseif filenumber >= 10
        system(['mv ' images_list2(i,:) ' ' images_list2(i,1:2) '0000' num2str(filenumber) '.tif']);
    else
        system(['mv ' images_list2(i,:) ' ' images_list2(i,1:2) '00000' num2str(filenumber) '.tif']);
    end
    
end