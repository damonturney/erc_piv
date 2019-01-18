function [u,v]=erc_globfilt(u,v,threshold)

%
% This function is a so called global histogram operator. It
% features a few slightly different ways of giving the maximum and
% minimum velocities allowed in your vector fields.
%

std_u=std(u(~isnan(u(:))));
mean_u=mean(u(~isnan(u(:))));
std_v=std(v(~isnan(v(:))));
mean_v=mean(v(~isnan(v(:))));

indices2replace=abs(u(:)-mean_u)/std_u>threshold | abs(v(:)-mean_v)/std_v>threshold ;

u(indices2replace)=NaN;
v(indices2replace)=NaN;

disp(['Golbal Filter .......' num2str(sum(indices2replace(:))) ' NaNs'])
