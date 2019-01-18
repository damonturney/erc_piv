close all
figure(1)
imagesc(C,[0 255])
colormap(gray)
figure(2)
imagesc(D,[0 255])
colormap(gray)
figure(3)
imagesc(R,[0 1])
colormap(gray)
max(max(R))

close all
figure(1)
imshow(im1,[0 255])
figure(2)
imshow(im2_padded,[0 255])
figure







load my\1\mqdpivdata000531.mat
umy=u;
vmy=v;
xmy=x;
ymy=y;
load crss\1\mqdpivdata000531.mat
quiver([xmy x],[ymy y],[umy u]+3.7,[vmy v],3)


figure
aaaa=imread('f_002144.tif');
imshow(uint8(double(aaaa).*5))
figure
bbbb=imread('test.tif');
imshow(uint8(double(bbbb).*5))





mapp=load('worldco1.mat');
figure
[xw,yw,uw,vw]=pixel2world(datax,datay,x,y,mapp.comap(:,1),mapp.comap(:,2));
quiver(xw,yw,uw,vw,.5)

quiver(xw,yw,uw-mean(uw(finite(uw))),vw,.5)



[datax2,datay2]=globfilt(x,y,datax,datay,4);
[datax2,datay2]=localfilt(x,y,datax2,datay2,4,'median',5,maske);
[datax2,datay2]=naninterp(datax2,datay2,'linear',maske,x,y);
[xw,yw,uw,vw]=pixel2world(datax2,datay2,x,y,mapp.comap(:,1),mapp.comap(:,2));

[u2,v2]=globfilt(x,y,u,v,3);
[u2,v2]=naninterp(u2,v2,'linear',maske,x,y);




mean_of_images('f_00*.tif',1);
definewoco('f_000005.tif','.');
copyfile('worldco1.mat','a_worldco1.mat');
delete('worldco1.mat');
mask('f_000005.tif','worldco1.mat');
close all
clear all
copyfile('polymask.mat','a_polymask.mat');
delete('polymask.mat');
[xw,yw,uw,vw,snr,pkh]=matpiv('f_000005.tif','f_000006.tif',32,0.004,0.5...
  ,'single','a_worldco1.mat','a_polymask.mat');
quiver(xw,yw,uw,vw,5)




