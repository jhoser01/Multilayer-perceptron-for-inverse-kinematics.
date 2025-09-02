%% Función para la restricción del espacio de trabajo en base a los límites seleccionados 

function [ vCartRed,vArtRed ] = restringirDatos( v_cartesianas,v_articulares,xmin,xmax,ymin,ymax )

i=1;
%Se condicionan las variables cartesianas x,y para seleccionar aquellos
%datos que se encuentren dentro de los límites seleccionados, se almacenan
%los pares cartesianos y articulares
for j=1:length(v_articulares)
if v_cartesianas(1,j)>=xmin && v_cartesianas(1,j)<=xmax
    if v_cartesianas(2,j)>=ymin && v_cartesianas(2,j)<=ymax
        v_cartes_red(:,i)=v_cartesianas(:,j);
        v_art_red(:,i)   =v_articulares(:,j);
        i=i+1;
    end
end

end

%En caso de existir variables cartesianas repetidas, se eliminan las repetidas 
A=v_cartes_red;
B=v_art_red;
 A(3,:)=A(3,:)-floor(A(3,:)/(2*pi))*2*pi;
[C, ia,ic]=unique(A.','rows','stable');
k=1;

for i=1:length(A)
    for j=1:length(ia)
        if i==ia(j)
         D(:,k)=B(:,i);   
        k=k+1;
        end
    end
end

vCartRed=C.';
vArtRed=D;

end