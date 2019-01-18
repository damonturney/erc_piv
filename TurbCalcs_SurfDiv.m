%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% written by: Damon Turney
% date: September 05 2007
%
% Description: Uses MatPIV to create velocity vectors
% 
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
close all
clear all

cd('E:\ImagesForPIV\2007_11_24_Top_4point5CM_Dual_cameras\2007_11_24_ChannelFlow_Re30000_D13cm_250fps');
good_images=1:10:531;
meanmeanu=ones(1,length(good_images));
dircontents=dir('my');
files=zeros(1,50);
for i=1:size(dircontents,1)
    files(i)= dircontents(i).name(1)=='1' | dircontents(i).name(1)=='2' | dircontents(i).name(1)=='3' | dircontents(i).name(1)=='4';
end


load(sprintf('my/1/mqdpivdata%06g.mat',good_images(1)));
xmy=x;
ymy=y;
umy=u;
vmy=v;
load(sprintf('crss/1/mqdpivdata%06g.mat',good_images(1)));
xcrss=x;
ycrss=y;
ucrss=u;
vcrss=v;
[xglued,yglued]=meshgrid(-0.6:0.07:13.8,2:-0.07:-5.5);
xglued=xglued+ones(size(xglued)).*0.05;
yglued=yglued+ones(size(xglued)).*0.05;
u=griddata([xmy xcrss],[ymy ycrss],[umy ucrss],xglued,yglued,'linear');
v=griddata([xmy xcrss],[ycrss ycrss],[vmy vcrss],xglued,yglued,'linear');
sumdatav=zeros(size(xglued));
sumdatau=zeros(size(xglued));

meanurecord=ones(1,length(good_images)*sum(files));
count=0 ;
for i=1:sum(files)
	for image_number=good_images
        count=count+1;
		disp(['Calculating Mean, Folder ' num2str(i) ', Image #' num2str(image_number)])
        load(sprintf('my/%s/mqdpivdata%06g.mat',num2str(i),image_number));
        umy=u;
        vmy=v;
        load(sprintf('crss/%s/mqdpivdata%06g.mat',num2str(i),image_number));
        ucrss=u;
        vcrss=v;
        u=griddata([xmy(1:end,1:end-1) xcrss(1:end,3:end)],[ymy(1:end,1:end-1) ycrss(1:end,3:end)],...
            [umy(1:end,1:end-1) ucrss(1:end,3:end)],xglued,yglued,'linear');
        v=griddata([xmy(1:end,1:end-1) xcrss(1:end,3:end)],[ymy(1:end,1:end-1) ycrss(1:end,3:end)],...
            [vmy(1:end,1:end-1) vcrss(1:end,3:end)],xglued,yglued,'linear');
        meanurecord(count)=mean(u(~isnan(u(:))));
        sumdatau=sumdatau+u;
        sumdatav=sumdatav+v;
	end
end
meanu=sumdatau./count;
meanv=sumdatav./count;

% angle=atan(meanv./-meanu);
% clear i
% meanu=real((meanu+i*meanv).*(cos(angle)+i.*sin(angle)));
% meanv=imag((meanu+i*meanv).*(cos(angle)+i.*sin(angle)));

pfit=ones(sum(files),2);
blocklength=9;
correctionfactoru2=ones(1,sum(files)*length(good_images));
for i=1:sum(files)*length(good_images)/blocklength;
    pfit(i,1:end)=polyfit(1:blocklength,meanurecord((i-1)*blocklength+1:i*blocklength),1);
end
for i=1:sum(files)*length(good_images)/blocklength;
    correctionfactoru2((i-1)*blocklength+1:i*blocklength)=polyval(pfit(i,1:end),1:blocklength);
end
correctionfactoru2=correctionfactoru2./mean(meanu(~isnan(meanu)));

sumdatav=zeros(size(xglued));
sumdatau=zeros(size(xglued));
sumturbulentusqrd=zeros(size(xglued));
sumturbulentvsqrd=zeros(size(xglued));
tempcorrv=zeros(1,length(good_images));
count=0;
clear i
for j=1:sum(files)
	for image_number=good_images
        count=count+1;
		disp(['Calculating Turbulence & Correlations 1, Folder ' num2str(j) ', Image #' num2str(image_number)])
        load(sprintf('my/%s/mqdpivdata%06g.mat',num2str(j),image_number));
        umy=u;
        vmy=v;
        load(sprintf('crss/%s/mqdpivdata%06g.mat',num2str(j),image_number));
        ucrss=u;
        vcrss=v;
        u=griddata([xmy(1:end,1:end-1) xcrss(1:end,3:end)],[ymy(1:end,1:end-1) ycrss(1:end,3:end)],...
            [umy(1:end,1:end-1) ucrss(1:end,3:end)],xglued,yglued,'linear');
        v=griddata([xmy(1:end,1:end-1) xcrss(1:end,3:end)],[ymy(1:end,1:end-1) ycrss(1:end,3:end)],...
            [vmy(1:end,1:end-1) vcrss(1:end,3:end)],xglued,yglued,'linear');
        sumdatau=sumdatau+u;
        sumdatav=sumdatav+v;
        turbulentu=(u-meanu.*correctionfactoru2(count));
        turbulentv=(v-meanv.*correctionfactoru2(count));
        tempcorrv(count)=turbulentv(3,10)*turbulentv(3,105);
        sumturbulentusqrd=sumturbulentusqrd+turbulentu.^2;
        sumturbulentvsqrd=sumturbulentvsqrd+turbulentv.^2;
	end
end
meanu=sumdatau./count;
meanv=sumdatav./count;
rmsu=sqrt(sumturbulentusqrd./(count));
rmsv=sqrt(sumturbulentvsqrd./(count));

correctionfactoru=ones(size(xglued));
for row=1:size(xglued,1)
    if sum(~isnan(rmsu(row,1:end)))
        meanrow=mean(rmsu(row,~isnan(rmsu(row,1:end))));
    else
        meanrow=NaN;
    end
    correctionfactoru(row,1:end)=meanrow./rmsu(row,1:end);
end

correctionfactorv=ones(size(xglued));
for row=1:size(xglued,1)
    if sum(~isnan(rmsv(row,1:end)))
        meanrow=mean(rmsv(row,~isnan(rmsv(row,1:end))));
    else
        meanrow=NaN;
    end
    correctionfactorv(row,1:end)=meanrow./rmsv(row,1:end);
end



turbulentu=zeros(size(xglued));
sumturbulentu=zeros(size(xglued));
turbulentv=zeros(size(xglued));
sumturbulentusqrd=zeros(size(xglued));
sumturbulentvsqrd=zeros(size(xglued));
sumturbulentuv=zeros(size(xglued));
sum4correlationu=zeros(size((xglued)));
sum4correlationv=zeros(size((xglued)));
correlationu=zeros(size((xglued)));
correlationv=zeros(size((xglued)));
bottomcorrelationu=zeros(size((xglued)));
middlecorrelationu=zeros(size((xglued)));
topcorrelationu=zeros(size((xglued)));
bottomcorrelationv=zeros(size((xglued)));
middlecorrelationv=zeros(size((xglued)));
topcorrelationv=zeros(size((xglued)));
bottomcorrelationvposu=zeros(size((xglued)));
middlecorrelationvposu=zeros(size((xglued)));
topcorrelationvposu=zeros(size((xglued)));
bottomcorrelationvnegu=zeros(size((xglued)));
middlecorrelationvnegu=zeros(size((xglued)));
topcorrelationvnegu=zeros(size((xglued)));
column=10;
count=0;
bottomcountvposu=0;
middlecountvposu=0;
topcountvposu=0;
bottomcountvnegu=0;
middlecountvnegu=0;
topcountvnegu=0;
meanurecord3=zeros(1,length(good_images));
j=0;
clear i
for j=1:sum(files)
	for image_number=good_images
        count=count+1;
		disp(['Calculating Turbulence & Correlations 2, Folder ' num2str(j) ', Image #' num2str(image_number)])
        load(sprintf('my/%s/mqdpivdata%06g.mat',num2str(j),image_number));
        umy=u;
        vmy=v;
        load(sprintf('crss/%s/mqdpivdata%06g.mat',num2str(j),image_number));
        ucrss=u;
        vcrss=v;
        u=griddata([xmy(1:end,1:end-1) xcrss(1:end,3:end)],[ymy(1:end,1:end-1) ycrss(1:end,3:end)],...
            [umy(1:end,1:end-1) ucrss(1:end,3:end)],xglued,yglued,'linear');
        v=griddata([xmy(1:end,1:end-1) xcrss(1:end,3:end)],[ymy(1:end,1:end-1) ycrss(1:end,3:end)],...
            [vmy(1:end,1:end-1) vcrss(1:end,3:end)],xglued,yglued,'linear');
%         u=real((tempu+i*tempv).*(cos(angle)+i.*sin(angle))).*correctionfactoru;
%         v=imag((tempu+i*tempv).*(cos(angle)+i.*sin(angle))).*correctionfactorv;
        turbulentu=(u-meanu.*correctionfactoru2(count)).*correctionfactoru;
        meanurecord3(count)=mean(turbulentu(~isnan(turbulentu)));
        turbulentv=(v-meanv.*correctionfactoru2(count)).*correctionfactorv;
        %quiver(xglued,yglued,turbulentu,turbulentv,3)
        %pause(1)
        for row=1:size(xglued,1)
%             rowdata=turbu(row,1:end);
%             if sum(~isnan(rowdata))>0
%                 turbulentu(row,1:end)=turbu(row,1:end)-mean(rowdata(~isnan(rowdata)));
%             else
%                 turbulentu(row,1:end)=NaN;
%             end
%             rowdata=turbulentv(row,1:end);
%             turbulentv(row,1:end)=turbulentv(row,1:end)-mean(mean(rowdata(~isnan(rowdata))));            
            sum4correlationu(row,1:end)=sum4correlationu(row,1:end)+(turbulentu(row,1:end)).*(turbulentu(row,column));
            sum4correlationv(row,1:end)=sum4correlationv(row,1:end)+(turbulentv(row,1:end)).*(turbulentv(row,column));       
        end 
        
        bottomcorrelationu=bottomcorrelationu+turbulentu(end-7,59).*turbulentu;
        middlecorrelationu=middlecorrelationu+turbulentu(26,59).*turbulentu;
        topcorrelationu=topcorrelationu+turbulentu(7,59).*turbulentu;
        bottomcorrelationv=bottomcorrelationv+turbulentv(end-7,59).*turbulentv;
        middlecorrelationv=middlecorrelationv+turbulentv(26,59).*turbulentv;
        topcorrelationv=topcorrelationv+turbulentv(7,59).*turbulentv;
        if turbulentv(end-7,59)>0
            bottomcorrelationvposu=bottomcorrelationvposu+turbulentv(end-7,59).*turbulentu;
            bottomcountvposu=bottomcountvposu+1;
        else
            bottomcorrelationvnegu=bottomcorrelationvnegu+turbulentv(end-7,59).*turbulentu;
            bottomcountvnegu=bottomcountvnegu+1;
        end
        if turbulentv(26,59)>0
            middlecorrelationvposu=middlecorrelationvposu+turbulentv(26,59).*turbulentu;
            middlecountvposu=middlecountvposu+1;         
        else
            middlecorrelationvnegu=middlecorrelationvnegu+turbulentv(26,59).*turbulentu;
            middlecountvnegu=middlecountvnegu+1;
        end
        if turbulentv(7,59)>0
            topcorrelationvposu=topcorrelationvposu+turbulentv(7,59).*turbulentu;
            topcountvposu=topcountvposu+1;
        
        else
            topcorrelationvnegu=topcorrelationvnegu+turbulentv(7,59).*turbulentu;
            topcountvnegu=topcountvnegu+1;
            
        end              
        
        sumturbulentusqrd=sumturbulentusqrd+turbulentu.^2;
        sumturbulentvsqrd=sumturbulentvsqrd+turbulentv.^2;
        sumturbulentuv=sumturbulentuv+turbulentu.*turbulentv;
	end
end
rmsu=sqrt(sumturbulentusqrd./(count));
rmsv=sqrt(sumturbulentvsqrd./(count));
meanuv=sumturbulentuv./(count);
bottomcorrelationu=bottomcorrelationu./(count-1)./rmsu(end-7,59)./rmsu;
middlecorrelationu=middlecorrelationu./(count-1)./rmsu(26,59)./rmsu;
topcorrelationu=topcorrelationu./(count-1)./rmsu(7,59)./rmsu;
bottomcorrelationv=bottomcorrelationv./(count-1)./rmsv(end-7,59)./rmsv;
middlecorrelationv=middlecorrelationv./(count-1)./rmsv(26,59)./rmsv;
topcorrelationv=topcorrelationv./(count-1)./rmsv(7,59)./rmsv;

bottomcorrelationvposu=bottomcorrelationvposu./(bottomcountvposu-1)./rmsv(end-7,59)./rmsu;
middlecorrelationvposu=middlecorrelationvposu./(middlecountvposu-1)./rmsv(26,59)./rmsu;
topcorrelationvposu=topcorrelationvposu./(topcountvposu-1)./rmsv(7,59)./rmsu;
bottomcorrelationvnegu=bottomcorrelationvnegu./(bottomcountvnegu-1)./rmsv(end-7,59)./rmsu;
middlecorrelationvnegu=middlecorrelationvnegu./(middlecountvnegu-1)./rmsv(26,59)./rmsu;
topcorrelationvnegu=topcorrelationvnegu./(topcountvnegu-1)./rmsv(7,59)./rmsu;
for row=1:size(xglued,1)
    correlationu(row,1:end)=sum4correlationu(row,1:end)./(count-1)./rmsu(row,column)./rmsu(row,1:end);
    correlationv(row,1:end)=sum4correlationv(row,1:end)./(count-1)./rmsv(row,column)./rmsv(row,1:end);
end
 

%Calculate the integral length scale of v' in the x direction
vlengthscales=zeros(length(1:5:size(xglued,1)-5),1);
ulengthscales=zeros(length(1:5:size(xglued,1)-5),1);
lengthscaleys=yglued(1:size(xglued,1)-5,35);
count=0;
for row=3:size(xglued,1)-3
    count=count+1;
    avecorrelationv=mean(correlationv(row-2:row+2,column:end));
    avecorrelationu=mean(correlationu(row-2:row+2,column:end));
    if sum(~isnan(avecorrelationv))>0
        avecorrelationvlastcolumn=min([find(avecorrelationv<0,1,'first') length(avecorrelationv) find(~isnan(avecorrelationv),1,'last')]);
        vlengthscales(count)=sum(avecorrelationv(column:avecorrelationvlastcolumn)).*(xglued(row,10)-xglued(row,9));
        avecorrelationulastcolumn=min([find(avecorrelationu<0) length(avecorrelationu) find(~isnan(avecorrelationu),1,'last') ]);
        ulengthscales(count)=sum(avecorrelationu(column:avecorrelationulastcolumn)).*(xglued(row,10)-xglued(row,9));  
%         xs=xglued(~isnan(avecorrelationu));
%         temp=polyfit(xs(end-round(0.6*length(xs)):end),avecorrelationu(end-round(0.6*length(xs)):end),1);
%         ulengthscale_slope=temp(1);
%         ulengthscale_xintercept=ulengthscale_slope/avecorrelationu(end);
%         ulengthscales(count)=ulengthscales(count)+0.5*avecorrelationu(end)*avecorrelationu(end)/ulengthscale_slope;
%         ulengthscales(count)=avecorrelationu(~isnan(avecorrelationu))*ones(sum(~isnan(avecorrelationu)),1).*diff(xglued(1,1:2));
%         vlengthscales(count)=avecorrelationv(~isnan(avecorrelationv))*ones(sum(~isnan(avecorrelationv)),1).*diff(xglued(1,1:2));
    else
        vlengthscales(count)=NaN;
        ulengthscales(count)=NaN;
    end
end

avermsu=zeros(1,size(xglued,1));
avermsv=zeros(1,size(xglued,1));
avemeanuv=zeros(1,size(xglued,1));

for row=1:size(xglued,1)
    rmsunonan=rmsu(row,1:end);
    rmsunonan=rmsunonan(~isnan(rmsunonan));
    rmsvnonan=rmsv(row,1:end);
    rmsvnonan=rmsvnonan(~isnan(rmsvnonan));
    meanuvnonan=meanuv(row,1:end);
    meanuvnonan=meanuvnonan(~isnan(meanuvnonan));
    if ~isempty(meanuvnonan)
        avermsu(row)=mean(rmsunonan);
        avermsv(row)=mean(rmsvnonan);
        avemeanuv(row)=mean(meanuvnonan);
    else
        avermsu(row)=NaN;
        avermsv(row)=NaN;
        avemeanuv(row)=NaN;
    end
        
end


meantop4pt5=mean(mean(meanu(yglued(1:end,1)<0.05 & yglued(1:end,1)>-4.55,5:end-5)));
Lux_over_Luy=sum(middlecorrelationu(26-20:26+20,59:59))/sum(middlecorrelationu(26:26,59-20:59+20));
%ustar prediction
temp=polyfit(yglued(~isnan(avemeanuv),10),avemeanuv(~isnan(avemeanuv))',1);
avemeanuv_slope=temp(1);

if strcmp(computer,'PCWIN')
    save('turbcalcs2', 'xglued','yglued','meanu', 'meanv', 'avermsu', 'avermsv','avemeanuv','correlationu',...
        'correlationv','ulengthscales','vlengthscales','lengthscaleys','bottomcorrelationu','middlecorrelationu',...
        'topcorrelationu','bottomcorrelationv','middlecorrelationv','topcorrelationv','meanurecord3','meanurecord',...
        'bottomcorrelationvposu','middlecorrelationvposu','topcorrelationvposu','bottomcorrelationvnegu',...
        'middlecorrelationvnegu','topcorrelationvnegu','meantop4pt5','avemeanuv_slope')
else %For Linux machines
    save('turbcalcs2', 'xglued','yglued','meanu', 'meanv', 'avermsu', 'avermsv','avemeanuv','correlationu',...
        'correlationv','ulengthscales','vlengthscales','lengthscaleys','bottomcorrelationu','middlecorrelationu',...
        'topcorrelationu','bottomcorrelationv','middlecorrelationv','topcorrelationv','meanurecord3','meanurecord',...
        'bottomcorrelationvposu','middlecorrelationvposu','topcorrelationvposu','bottomcorrelationvnegu',...
        'middlecorrelationvnegu','topcorrelationvnegu','meantop4pt5','avemeanuv_slope','-v6')
end

disp(pwd)

%contourf(xglued, yglued,correlationv),colorbar
%contourf(xglued, yglued,correlationu),colorbar
%plot(avermsv,yglued(1:end,4))
%plot(avermsu,yglued(1:end,4))
%mean(avemeanu(yglued(1:end,4)>-4.5))


% !dir
%plot(avermsv,yglued(1:end,4)),hold on, plot(avermsu,yglued(1:end,4)), plot(avermsu-avermsv,yglued(1:end,4)), hold off
%plot(ulengthscales,lengthscaleys),hold on,plot(vlengthscales,lengthscaleys),hold off,xlim([0 max(ulengthscales)])
%temp=polyfit(yglued(~isnan(avemeanuv),10),avemeanuv(~isnan(avemeanuv))',1);avemeanuv_slope=temp(1);
%temp=polyfit(yglued(10:35,10),avemeanuv(10:35)',1);avemeanuv_slope=temp(1);avemeanuv_slope=temp(1);
%depth=-5;plot(avemeanuv,yglued(1:end,4)),ylim([depth 0]),xlim([0 avemeanuv_slope*(depth)]),sqrt(avemeanuv_slope*(depth)),hold off
