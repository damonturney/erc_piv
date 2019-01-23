% DEFINEWOCO_NOFIGURE - calculate the mapping from image to real world coordinates
%
% [comap,A1,world]=definewoco_nofigure(image,coordinatestyle)
% 
%
% The final result will be saved to a file in the present work directory. 
% The file is named 'worldcoX.mat', where the X is any number specified 
% by the user. This option is for the cases where one might have two or 
% more different coordinate systems in the same working directory. If this 
% is not the case just press <enter> when asked for a number. The file will 
% then be named 'worldco.mat'
%
% Copyright, J. Kristian Sveen, 1999-2004, last revision April 16, 2004
%             jks@math.uio.no
% For use with MatPIV 1.6.1
%
%Heavily modified by Damon Turney 2007


disp('Please enter an m x 2 array of [x y] pixel positions.')
disp('The upper left pixel location is [0 0], and bottom right is the largest pixel x,y values.')
disp('x refers to the horizontal direction. y refers to the vertical direction.')
disp('For example, in a 1280 wide x 1024 tall image, the bottom right is [1280 1024].')
camera=input('Enter the array here:');
x=camera(:,1)'+1;
y=camera(:,2)'+1;

%close(2)
fprintf('\n')
disp('Now enter an m x 2 array of real world locations corresponding to the pixel locations.')
world=input(['Enter the array here:']);


% Construct function for fitting.
inpx='inne';
while strcmp(inpx,'inne')
  disp('')
  disp('Please Enter a Mapping function.')
  mapfun=input('(N)onlinear or (L)inear (N/n)/(L/l): ','s');
  if strcmp(mapfun,'N')==1 | strcmp(mapfun,'n')==1
    if length(world)>=6
        camera=[ones(size(camera,1),1) camera(:,1) camera(:,2) (camera(:,1).*camera(:,2)) camera(:,1).^2 camera(:,2).^2];
        inpx='ute';
    else
        disp('Not enough points specified to calculate nonlinear mapping factors.')
        disp('Using linear mapping function.');
        if length(world)>=3
            camera=[ones(size(camera,1),1) camera];
            inpx='ute';
        elseif length(world)>1 & length(world)<3
            disp('Only two points were specified. The linear mapping in the unspecified direction will be')
            disp('assumed to be perpedicular and otherwise similar to that of the specified direction.')
            camera=[camera ; [ (camera(2,2)-camera(1,2))+camera(1,1)   -(camera(2,1)-camera(1,1))+camera(1,2)]];
            world= [world  ; [(-(world(2,2) -world(1,2)) +world(1,1))  ((world(2,1) -world(1,1)) +world(1,2))]];
            camera=[ones(size(camera,1),1) camera];
            inpx='ute';
        else
          disp('Not enough points specified. You need to specify two points at least.')
        end
    end
  elseif strcmp(mapfun,'L')==1 | strcmp(mapfun,'l')==1
    if length(world)>=3
        camera=[ones(size(camera,1),1) camera];
        inpx='ute';
    elseif length(world)>1 & length(world)<3
        disp('Only two points were specified. The linear mapping in the unspecified direction will be')
        disp('assumed to be perpedicular and otherwise similar to that of the specified direction.')
        camera=[camera ; [ (camera(2,2)-camera(1,2))+camera(1,1)   -(camera(2,1)-camera(1,1))+camera(1,2)]];
        world= [world  ; [(-(world(2,2) -world(1,2)) +world(1,1))  ((world(2,1) -world(1,1)) +world(1,2))]];
        camera=[ones(size(camera,1),1) camera];
        inpx='ute';
        
    else
        disp('Not enough points specified. You need to specify two points at least.')
    end
  else
    disp('Please specify mapping function (N or n)/(L or l)/(LL or ll):')
  end
end

comap=(camera\world);  % Fit using a minimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% test for error
err=norm( (camera*comap-world));
disp(['Error (norm) = ',num2str(err)])
% give a warning if error is larger than a certain threshold
% 1 is just chosen as a test case. This needs testing.
if err>1e-5
  disp(['WARNING! The minimized system of equations has a large ', ...
	'error.'])
  disp('Consider checking your world coordinate input')
  if strcmp(mapfun,'L') | strcmp(mapfun,'l')
    disp('Also consider using a nonlinear mapping function');
  end
end


save('worldco','comap')


close %close window containing the image

