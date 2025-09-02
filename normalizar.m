%% Función para la normalización de las variables cartesianas y articulares a usar en la red neuronal
function [ vCartNorm,vArtNorm ] = normalizar( vCartRed,vArtRed,ylimmin,ylimmax,xmin,xmax,ymin,ymax,th1,th2,th3,orient)

%Normalización de las variables articulares en base a su rango de operación
vArtNorm(1,:)=ylimmin+(ylimmax-ylimmin)*(vArtRed(1,:)-th1(1))/(th1(2)-th1(1));
vArtNorm(2,:)=ylimmin+(ylimmax-ylimmin)*(vArtRed(2,:)-th2(1))/(th2(2)-th2(1));
vArtNorm(3,:)=ylimmin+(ylimmax-ylimmin)*(vArtRed(3,:)-th3(1))/(th3(2)-th3(1));

%Normalización de las variables cartesianas en base a los límites
%seleccionados y determinados para el caso de la orientación
vCartNorm(1,:)=ylimmin+(ylimmax-ylimmin)*(vCartRed(1,:)-xmin)/(xmax-xmin);
vCartNorm(2,:)=ylimmin+(ylimmax-ylimmin)*(vCartRed(2,:)-ymin)/(ymax-ymin);
vCartNorm(3,:)=ylimmin+(ylimmax-ylimmin)*(vCartRed(3,:)-orient(1))/(orient(2)-orient(1));

end

