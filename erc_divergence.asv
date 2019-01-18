function div=erc_divergence(x,y,u,v,waterheight)
%DIVERGENCE  Divergence of a vector field.
%   DIV = DIVERGENCE(X,Y,Z,U,V) computes the divergence of a 3-D
%   vector field U,V,W. The arrays X,Y define the coordinates for
%   U,V


% Take this out when other data types are handled
u = double(u);
v = double(v);

[gradz,gradx]=gradient(waterheight,length_node,-length_node);

numrows=size(u,1);
numcolumns=size(u,2);

for row=1:numrows
    deltax = diff(x(row,:))./cos(atan(gradx(row,:))); 
    [px junk] = gradient(u(row,:), hx); %#ok
end



    hy = y(:,1); 
[junk qy] = gradient(v, hx, hy); %#ok
  

div = px+qy;




