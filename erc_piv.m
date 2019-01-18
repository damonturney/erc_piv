function [x,y,u,v,R_maxs,pix_u,pix_v]=erc_piv(im1,im2,winsizes,Dt,winoverlaps,searchoverlaps,R_threshold,wocofile,...
    maskfile,path2meanimageA,path2meanimageB,sub_pixel,previous_u,previous_v,winsizethreshold)

% MULTIMQDX- multiple passes for the raw MQD routine 
% function [x,y,u,v,snr]=multimqdpiv(im1,im2,winsizes,Dt,...
% winoverlaps,searchoverlaps,wocofile,maskfile)
%
% winsizes is a list of the sizes of interrigation windows to use [[first size] ; [second size] ; [and so on]]
% winoverlaps is a list of the fraction by which the windows should overlap eachother during the determination of the PIV nodes [[first overlap fractions] ; [second overlap fractions] ; [and so on]]
% searchoverlaps is a list of the fraction of a window by which the "first image window im1" should search for its match in the "second image window im2" [[up down left right] ; [up down left right] ; [and so on]]
% wocofile is the world coordinate file produced by definewoco
% maskfile is the mask file produced by mask


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Image read
A=imread(im1);
B=imread(im2);
A=double(A); B=double(B);

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% background removal 
if exist(path2meanimageA,'file')==2
    if strcmp(path2meanimageA,'do not use')~=1
        bgim=double(imread(path2meanimageA));
        correctionfactor=1.3;
        for row=1:3:size(A,1)-3
            for column=1:3:size(A,2)-3
                bgdata=bgim(row:row+2,column:column+2);
                if max(max(bgdata))<100
                    bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
                    A(row:row+2,column:column+2)=A(row:row+2,column:column+2)-bgdata;
                end
            end
        end
        for column=1:3:size(A,2)-3
            bgdata=bgim(row+3:end,column:column+2);
            if max(max(bgdata))<100
                bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
                A(row+3:end,column:column+2)=A(row+3:end,column:column+2)-bgdata;
            end
        end
        for row=1:3:size(A,1)-3
            bgdata=bgim(row:row+2,column+3:end);
            if max(max(bgdata))<100
                bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
                A(row:row+2,column+3:end)=A(row:row+2,column+3:end)-bgdata;
            end
        end
        bgdata=bgim(row+3:end,column+3:end);
        if max(max(bgdata))<100
            bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
            A(row+3:end,column+3:end)=A(row+3:end,column+3:end)-bgdata; 
        end
        A=A-min(min(A));

        disp('   --> Background removed')
    end
end

if exist(path2meanimageB,'file')==2
    if strcmp(path2meanimageB,'do not use')~=1
        bgim=double(imread(path2meanimageB));
        correctionfactor=1.3;
        for row=1:3:size(B,1)-3
            for column=1:3:size(B,2)-3
                bgdata=bgim(row:row+2,column:column+2);
                if max(max(bgdata))<100
                    bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
                    B(row:row+2,column:column+2)=B(row:row+2,column:column+2)-bgdata;
                end
            end
        end
        for column=1:3:size(B,2)-3
            bgdata=bgim(row+3:end,column:column+2);
            if max(max(bgdata))<100
                bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
                B(row+3:end,column:column+2)=B(row+3:end,column:column+2)-bgdata;
            end
        end
        for row=1:3:size(B,1)-3
            bgdata=bgim(row:row+2,column+3:end);
            if max(max(bgdata))<100
                bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
                B(row:row+2,column+3:end)=B(row:row+2,column+3:end)-bgdata;
            end
        end
        bgdata=bgim(row+3:end,column+3:end);
        if max(max(bgdata))<100
            bgdata=bgdata*correctionfactor-min(min(bgdata*correctionfactor));
            B(row+3:end,column+3:end)=B(row+3:end,column+3:end)-bgdata; 
        end
        B=B-min(min(B));

        disp('   --> Background removed')
    end
end

% A=noisefiltmqd(A,4,20,0.25);
% B=noisefiltmqd(B,4,20,0.25);

%%%%%%%%%%%%%%%%%%%%%%%%%% Read in the mask information
if exist(maskfile,'file')==1
    if (ischar(maskfile) && ~isempty(maskfile))
        mask=load(maskfile);maske=mask.maske;
    end
else
    maske=[];
end 
if ~isempty(maske)
    maskimage=zeros(size(maske(1).msk));
    for i=1:length(maske) 
        maskimage=maskimage+double(maske(i).msk); 
    end 
else 
    maskimage=zeros(size(A)); 
end 
for i=1:length(maskimage(:))
    if maskimage(i)==0
        maskimage(i)=1;
    else
        maskimage(i)=NaN;
    end
end

if exist('winsizethreshold') ==0
    winsizethreshold=250
end

%%%%%%%%%%%%%%%%%%%%%First Pass with PIV
disp(['* Winsize: ',num2str(winsizes(1,:))])
[x,y,u,v,R_maxs]=erc_piv_controller(A,B,winsizes(1,:),winoverlaps(1,:),searchoverlaps(1,:),R_threshold,previous_u,previous_v,[],maske,'no',winsizethreshold);            
% quality control the data
[u,v]=erc_localfilt2(u,v,3.5,8);
[u,v]=erc_localfilt2(u,v,3.5,3);
[u,v]=erc_localfilt2(u,v,3.5,8);
[u,v]=erc_globfilt(u,v,6.5);
[u,v]=erc_naninterp(u,v,'linear',maske,x,y);
[u,v]=erc_localfilt2(u,v,3.5,8);
[u,v]=erc_localfilt2(u,v,3.5,3);
[u,v]=erc_globfilt(u,v,6.5);
[u,v]=erc_naninterp(u,v,'linear',maske,x,y);





%%%%%%%%%%%%%%%%% Subsequent Passes with PIV
i=1;
if size(winsizes,1)>1
	for i=2:size(winsizes,1)
        % expand the data to match the matrix of the next window size
		next_winsize=winsizes(i,:);
		next_overlap=winoverlaps(i,:);
		next_xs=(next_winsize(2)/2)-1 + 0.5 + 1:round((1-next_overlap(2))*next_winsize(2)):size(A,2)-next_winsize(2)/2-0.5;
		next_ys=(next_winsize(1)/2)-1 + 0.5 + 1:round((1-next_overlap(1))*next_winsize(1)):size(A,1)-next_winsize(1)/2-0.5;
		next_x_matrix=ones(size(next_ys,2),1)*next_xs;
		next_y_matrix=next_ys'*ones(1,size(next_xs,2));
		disp('Expanding velocity-field for next pass')
		u=interp2(x,y,u,next_x_matrix,next_y_matrix);
		v=interp2(x,y,v,next_x_matrix,next_y_matrix);
		[u,v]=erc_naninterp(u,v,'linear',maske,next_x_matrix,next_y_matrix);
		R_maxs=interp2(x,y,R_maxs,next_x_matrix,next_y_matrix);
		[R_maxs,R_maxs]=erc_naninterp(R_maxs,R_maxs,'linear',maske,next_x_matrix,next_y_matrix);        
        disp(['* Winsize: ',num2str(winsizes(i,:))])
        % Make the PIV calculations
        [x,y,u,v,R_maxs]=erc_piv_controller(A,B,winsizes(i,:),winoverlaps(i,:),searchoverlaps(i,:),R_threshold,u,v,R_maxs,maske,'no',winsizethreshold);            
        % quality control the data
        [u,v]=erc_localfilt2(u,v,3.5,8);
        [u,v]=erc_localfilt2(u,v,3.5,3);
        [u,v]=erc_localfilt2(u,v,3.5,8);
        [u,v]=erc_globfilt(u,v,6.5);
        [u,v]=erc_naninterp(u,v,'linear',maske,x,y);
        [u,v]=erc_localfilt2(u,v,3.5,8);
        [u,v]=erc_localfilt2(u,v,3.5,3);
        [u,v]=erc_globfilt(u,v,6.5);
        [u,v]=erc_naninterp(u,v,'linear',maske,x,y);
	end
end


%%%%%%%%%%% Subpixel Calculations
pix_u=u;
pix_v=v;
if strcmp(sub_pixel,'subpixel')
    disp(['* Subpixel PIV at Winsize: ',num2str(winsizes(i,:))])
    [x,y,pix_u,pix_v,R_maxs]=erc_piv_controller(A,B,winsizes(i,:),winoverlaps(i,:),searchoverlaps(i,:),R_threshold,u,v,R_maxs,maske,sub_pixel,winsizethreshold);
end


%%%%%%%%%%% Give Feedback to the user
disp(['Average number of pixels moved, x-dir: ' num2str(mean(pix_u(~isnan(pix_u(:)))))])
disp(['Average number of pixels moved, y-dir: ' num2str(mean(pix_u(~isnan(pix_u(:)))))])

%%%%%%%%%%%%%%%% Convert the units of the velocity from pixels/frame to cm/s, Change x y to laboratory coordinates
u=pix_u/Dt;
v=pix_v/Dt;
if exist(wocofile,'file')==2
    load(wocofile)
    [x,y,u,v]=erc_pixel2world(u,v,x,y,comap);
end


%%%%%%%%%%%%%% Give Feedback to the user
disp(['Average velocity, x-dir: ' num2str(mean(u(~isnan(u(:)))))])
disp(['Average velocity, y-dir: ' num2str(mean(v(~isnan(v(:)))))])