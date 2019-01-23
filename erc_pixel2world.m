function [xworld,yworld,uworld,vworld]=erc_pixel2world(ucamera,vcamera,xcamera,ycamera,comap)

% function [x,y,u,v]=pixel2world(ucamera,vcamera,xcamera,ycamera,lswo1,lswo2,mapping)
%
% Calculates the pixels to world coordinate transformation
% You need first to use the m-file DEFINEWOCO to specify your
% world coordinate system. Definewoco then calculates 6 numbers
% that are saved to file ( size(lswo1)=size(lswo2)=[3 1] )
% MAPPING is the mapping function from pixel to world coordinates
% and should be 'linear' or 'nonlinear'. The latter uses a second
% degree polynomial.

if length(comap)>4
    mapping='nonlinear';
  else
    mapping='linear';
end


if strcmp(mapping,'linear')==1
  comap(4:6,1)=0; comap(4:6,2)=0;
end
fprintf(['* Calculating the pixel to world transformation using ',mapping,' mapping'])
for ii=1:1:size(ucamera,2)
  for jj=1:1:size(ucamera,1)

    temp=[1 xcamera(jj,ii) ycamera(jj,ii) ycamera(jj,ii)*xcamera(jj,ii) xcamera(jj,ii)^2 ycamera(jj,ii)^2]*comap;
    xworld(jj,ii)=temp(1);
    yworld(jj,ii)=temp(2);
    
    %Now find velocity
    uworld(jj,ii)=comap(3,1)*vcamera(jj,ii)+comap(2,1)*ucamera(jj,ii)+...
        comap(4,1)*(ycamera(jj,ii)*ucamera(jj,ii)+xcamera(jj,ii)*vcamera(jj,ii))+...
        comap(6,1)*2*ycamera(jj,ii)*vcamera(jj,ii)+comap(5,1)*2*xcamera(jj,ii)*ucamera(jj,ii);
    vworld(jj,ii)=comap(3,2)*vcamera(jj,ii)+comap(2,2)*ucamera(jj,ii)+...
        comap(4,2)*(ycamera(jj,ii)*ucamera(jj,ii)+xcamera(jj,ii)*vcamera(jj,ii))+...
        comap(6,2)*2*ycamera(jj,ii)*vcamera(jj,ii)+comap(5,2)*2*xcamera(jj,ii)*ucamera(jj,ii);
    

  end
end


fprintf(' - DONE\n')
