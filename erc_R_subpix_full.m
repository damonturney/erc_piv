function [R]=erc_R_subpix_full(im1,im2_padded)

%
%
%
 
%disp('* MQD - method (raw calculation - this WILL be slow)')


winsize1=size(im1);
length_im1=length(im1(:));
winsize2=size(im2_padded);
variance_im1=var(im1(~isnan(im1)));
R=zeros(winsize2(1)-winsize1(1)+1,winsize2(2)-winsize1(2)+1);

%For choosing the two sub-images to correlate:
%   m is the offset, measured in pixels, of the searching window to-the-right. The searching window pans across im2_padded
%   n is the offset, measured in pixels, of the searching window down. The searching window pans across im2_padded



for n=1:winsize2(2)-winsize1(2)+1
  for m=1:winsize2(1)-winsize1(1)+1
    im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
    %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
    if any(any(isnan(im2))) || any(any(isnan(im1)))
        good_ind=~isnan(im1+im2);
        sumgood=sum(good_ind(:));
        if sumgood>250
            R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).* (im2(good_ind(:))-mean(im2(good_ind(:)))))...
                /(length(im1(good_ind(:)))-1)/sqrt(variance_im1*var(im2(good_ind(:)))+500);
        else
            R(m,n)=0.012345;
        end
    else
        R(m,n)=sum((im1(:)-mean(im1(:))).* (im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
    end
  end
end

