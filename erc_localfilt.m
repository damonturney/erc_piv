function [newu,newv]=erc_localfilt(oldu,oldv,threshold,winsize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: August 20 2004
%
% Description:
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

oldu=[  ones(size(oldu,1),winsize).*NaN             oldu             ones(size(oldu,1),winsize).*NaN         ];
oldu=[  ones(winsize,size(oldu,2)).*NaN            ;oldu;            ones(winsize,size(oldu,2)).*NaN  ];

oldv=[  ones(size(oldv,1),winsize).*NaN             oldv             ones(size(oldv,1),winsize).*NaN         ];
oldv=[  ones(winsize,size(oldv,2)).*NaN            ;oldv;            ones(winsize,size(oldv,2)).*NaN  ];

dummy_matrix_u=oldu.*0;
dummy_matrix_v=oldv.*0;
normalize_matrix=zeros(size(oldu));
for i=1:size(oldu,1)-winsize+1
    for j=1:size(oldu,2)-winsize+1
        subwindow_u=oldu(i:i+winsize-1,j:j+winsize-1);
        nonnan_indices=~isnan(subwindow_u(:));
        subwindow_u_nonnans=subwindow_u(nonnan_indices);
        subwindow_v=oldv(i:i+winsize-1,j:j+winsize-1);
        subwindow_v_nonnans=subwindow_v(nonnan_indices);
        if ~isempty(subwindow_v_nonnans)
            std_subwin_u=std(subwindow_u_nonnans(:));
            std_subwin_v=std(subwindow_v_nonnans(:));
            if sum(nonnan_indices)>25
                median_subwin_u=mean(subwindow_u_nonnans(:));
                median_subwin_v=mean(subwindow_v_nonnans(:));
            else
                median_subwin_u=median(subwindow_u_nonnans(:));
                median_subwin_v=median(subwindow_v_nonnans(:));
            end
        else
            std_subwin_u=-1;
            std_subwin_v=-1;
        end

        if std_subwin_u>0.00001         
            dummy_matrix_u(i:i+winsize-1,j:j+winsize-1)=dummy_matrix_u(i:i+winsize-1,j:j+winsize-1) + ...
                abs(subwindow_u-median_subwin_u)./std_subwin_u;
        elseif length(subwindow_u_nonnans(:))==1
            dummy_matrix_u(i:i+winsize-1,j:j+winsize-1)=dummy_matrix_u(i:i+winsize-1,j:j+winsize-1) + 3;
        end
        if std_subwin_v>0.00001         
            dummy_matrix_v(i:i+winsize-1,j:j+winsize-1)=dummy_matrix_v(i:i+winsize-1,j:j+winsize-1) + ...
                abs(subwindow_v-median_subwin_v)./std_subwin_v;
        elseif length(subwindow_v_nonnans(:))==1 
            dummy_matrix_v(i:i+winsize-1,j:j+winsize-1)=dummy_matrix_v(i:i+winsize-1,j:j+winsize-1) + 4;
        end
        normalize_matrix(i:i+winsize-1,j:j+winsize-1)=normalize_matrix(i:i+winsize-1,j:j+winsize-1)+1;
    end
end

decision_matrix_u=dummy_matrix_u./normalize_matrix;
decision_matrix_v=dummy_matrix_v./normalize_matrix;
badindices=find(decision_matrix_u>threshold | decision_matrix_v>threshold);
newu=oldu;
newu(badindices)=NaN;
newv=oldv;
newv(badindices)=NaN;

newv=newv(1+winsize:end-winsize,1+winsize:end-winsize);
newu=newu(1+winsize:end-winsize,1+winsize:end-winsize);

disp(['Localfiltmqd running....... ' num2str(length(badindices)) ' vectors changed to NaN.'])





