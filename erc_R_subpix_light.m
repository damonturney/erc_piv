function [R]=erc_R_subpix_light(im1,im2_padded)

%
%
%
%disp('* MQD - method (raw calculation - this WILL be slow)')


winsize1=size(im1);
winsize2=size(im2_padded);
length_im1=length(im1(:));
variance_im1=var(im1(~isnan(im1)));
min_good_ind=min(length_im1*0.9,1000);

R=zeros(winsize2(1)-winsize1(1)+1,winsize2(2)-winsize1(2)+1);

%For choosing the two sub-images to correlate:
%   m is the offset, measured in pixels, of the searching window to-the-right. The searching window pans across im2_padded
%   n is the offset, measured in pixels, of the searching window down. The searching window pans across im2_padded



for n=1:2:winsize2(2)-winsize1(2)+1
  for m=1:2:winsize2(1)-winsize1(1)+1
    im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
    %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
    if any(any(isnan(im2))) || any(any(isnan(im1)))
        good_ind=~isnan(im1+im2);
        sumgood=sum(good_ind(:));
        if sumgood>min_good_ind
            R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).* (im2(good_ind(:))-mean(im2(good_ind(:)))))...
                /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
        else
            R(m,n)=0.012345;
        end
    else
        R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
    end
  end
end

[maxm,maxn]=find(R==max(max(R)),1,'first');
if (maxn-2)>0 && (maxn+2)<=size(R,2) && (maxm-2)>0 && (maxm+2)<=size(R,1) 
    for n=maxn-2:maxn+2
      for m=maxm-1:2:maxm+1
        im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
        %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
        if any(any(isnan(im2))) || any(any(isnan(im1)))
            good_ind=~isnan(im1+im2);
            sumgood=sum(good_ind(:));
            if sumgood>min_good_ind
                R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).* (im2(good_ind(:))-mean(im2(good_ind(:)))))...
                    /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
            else
                R(m,n)=0.012345;
            end
        else
            R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
        end
      end
    end
    
    for n=maxn-1:2:maxn+1
      for m=[maxm-2 maxm maxm+2]
        im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
        %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
        if any(any(isnan(im2))) || any(any(isnan(im1)))
            good_ind=~isnan(im1+im2);
            sumgood=sum(good_ind(:));
            if sumgood>min_good_ind
                R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).* (im2(good_ind(:))-mean(im2(good_ind(:)))))...
                    /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
            else
                R(m,n)=0.012345;
            end
        else
            R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
        end
      end
    end
end

[maxm2,maxn2]=find(R==max(max(R)),1,'first');
if abs(maxm2-maxm)==2 || abs(maxn2-maxn)==2
    if maxm2-maxm==-2 && maxm2-1>0
        for n=maxn-2:maxn+2
          for m=maxm2-1
            im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
            %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
            if any(any(isnan(im2))) || any(any(isnan(im1)))
                good_ind=~isnan(im1+im2);
                sumgood=sum(good_ind(:));
                if sumgood>min_good_ind
                    R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).*(im2(good_ind(:))-mean(im2(good_ind(:)))))...
                        /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
                else
                    R(m,n)=0.012345;
                end
            else
                R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
            end
          end
        end
    end
    
    if maxm2-maxm==2 && maxm2+1<=size(R,1)
        for n=maxn-2:maxn+2
          for m=maxm2+1
            im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
            %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
            if any(any(isnan(im2))) || any(any(isnan(im1)))
                good_ind=~isnan(im1+im2);
                sumgood=sum(good_ind(:));
                if sumgood>min_good_ind
                    R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).*(im2(good_ind(:))-mean(im2(good_ind(:)))))...
                        /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
                else
                    R(m,n)=0.012345;
                end
            else
                R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
            end
          end
        end
    end
    
    if (maxn2-maxn)==-2 && (maxn2-1)>0
        for n=maxn2-1
          for m=maxm-2:maxm+2
            im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
            %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
            if any(any(isnan(im2))) || any(any(isnan(im1)))
                good_ind=~isnan(im1+im2);
                sumgood=sum(good_ind(:));
                if sumgood>min_good_ind
                    R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).*(im2(good_ind(:))-mean(im2(good_ind(:)))))...
                        /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
                else
                    R(m,n)=0.012345;
                end
            else
                R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
            end
          end
        end
    end
    
    if (maxn2-maxn)==2 && (maxn2+1)<=size(R,2)
        for n=maxn2+1
          for m=maxm-2:maxm+2
            im2=im2_padded(m:m+winsize1(1)-1,n:n+winsize1(2)-1);
            %I use R(n+winsize/2,m+winsize/2) in order to keep in line with Kristof Sveen's convention on the meaning of R
            if any(any(isnan(im2))) || any(any(isnan(im1)))
                good_ind=~isnan(im1+im2);
                sumgood=sum(good_ind(:));
                if sumgood>min_good_ind
                    R(m,n)=sum((im1(good_ind(:))-mean(im1(good_ind(:)))).*(im2(good_ind(:))-mean(im2(good_ind(:)))))...
                        /(length(im1(good_ind(:)))-1)/sqrt(var(im1(good_ind(:)))*var(im2(good_ind(:)))+500);
                else
                    R(m,n)=0.012345;
                end
            else
                R(m,n)=sum((im1(:)-mean(im1(:))).*(im2(:)-mean(im2(:))))/(length_im1-1)/sqrt(variance_im1*var(im2(:))+500);  
            end
          end
        end
    end
end
