% DEFINEWOCO - calculate the mapping from image to physical coordinates in MatPIV
%
% [comap,A1,world]=definewoco(image,coordinatestyle)
% 
% DEFINEWOCO is a file for calculating the pixel to world 
% coordinate transformation. 
% This function needs an image with distinct coordinate points. 
% These points should either be easily locatable dots in the 
% image (these are assumed to be circular), or they will have to
% be defined by a grid with known spacing. Your points need to be
% WHITE on a BLACK (dark) background.
%
% definewoco('woco.bmp','o'); will assume circular points with a well 
% defined peak
%
% definewoco('woco.bmp','+'); will assume that the image contains a grid 
% with known spacing. In this case the image is cross-correlated with an 
% artificial cross.
%
% definewoco('woco.bmp','x'); will assume that the image contains grid 
% points in the form of x's. In this case the image is cross-correlated 
% with an artificial x (rotated cross).
%
% definewoco('woco.bmp','.'); will assume circular points where the peak 
% is not well defined, for example if it is flat and relatively large. In 
% this case the input-image is cross correlated with a gaussian bell to 
% emphasize the center of each point in the original image. This option has 
% now the added functionality of letting the user enter an aproximate size
% of his/her world-coordinate point. This helps in many cases where the 
% points are "very" wide, for example 20 pixels in diameter.
%
% The user will then have to mark the local regions around each 
% coordinate point using the mouse (first button).
%
% Subsequently the user will be asked to enter the physical coordinates
% (cm) for each point.
%
% In the final step one will have to choose between a linear and non-
% linear mapping function to use in the calculation of the mapping 
% factors. In most cases a linear function will do a proper job.
%
% The final result will be saved to a file in the present work directory. 
% The file is named 'worldcoX.mat', where the X is any number specified 
% by the user. This option is for the cases where one might have two or 
% more different coordinate systems in the same working directory. If this 
% is not the case just press <enter> when asked for a number. The file will 
% then be named 'worldco.mat'
%
% See also: MATPIV


% Copyright, J. Kristian Sveen, 1999-2004, last revision April 16, 2004
%             jks@math.uio.no
% For use with MatPIV 1.6.1
%
%Heavily modified by Damon Turney 2007

% Distributed under the GNU general public license



disp('Please enter an m x 2 array of [x y] pixel positions in your raw photographs.')
disp('The locations are specified by Adobe Photoshop as x and y.')
disp('To obtain these x and y values use the measurement tool in Adobe Photoshop.')
camera=input('Enter the array here:');
x=camera(:,1)'+1;
y=camera(:,2)'+1;

%close(2)
fprintf('\n')
disp('Now enter an m x 2 array of world coordinates corresponding to the points specified above.')
disp('The entries are formated as [x y] where x will plot in matlab as the abscissa and y plots as the ordinate.')
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

