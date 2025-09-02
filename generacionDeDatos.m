%% Código para la generación de datos de entrenamiento, validación y prueba
%UNIVERSIDAD NACIONAL DE TRUJILLO
%INGENIERÍA MECATRÓNICA - CONTROL AVANZADO
%CINEMÁTICA INVERSA DE ROBOT MANIPULADOR 3GDL. 
%APRENDIZAJE BACK PROPAGATION. 
%FECHA: 
%% para las redes neuronales

clc, clear all
%Se define el paso que habrá entre los ángulos de las variables articulares
paso=0.035; 

%Se define el rango de operación de cada una de las variables articulares
theta1=[20*pi/180 60*pi/180];
theta2=[20*pi/180 60*pi/180];
theta3=[20*pi/180 60*pi/180];

%Para visualizar se construye un círculo con centro en el origen y radio 3m
%Espacio trabajo del robot 3GDL. 
wtp=0:0.01:2*pi;
center=[0,0];
radius=3;
xp=center(1)+radius*cos(wtp);
yp=center(2)+radius*sin(wtp);
plot(xp,yp,'k')
grid on
hold on
[vCart,vArt]=generarDatos(paso,theta1,theta2,theta3); %Vector Cartesiano, Vector Articular. 
figure(1)
plot(vCart(1,:),vCart(2,:),'b');

%Después de visualizar el espacio generado se definen límites dentro de 
%este para seleccionar el espacio a trabajar

xmin=0.3;
xmax=0.7;
ymin=2.3;
ymax=2.6;

%Se seleccionan los datos dentro de los límites y se almacenan los valores 
%máximo y mínimo de la variable cartesiana orientación 
[vCartRed,vArtRed] = restringirDatos(vCart,vArt,xmin,xmax,ymin,ymax);
orient(1)=min(vCartRed(3,:));
orient(2)=max(vCartRed(3,:));

%Se normalizan y redondean los datos en el rango de la función de activación
[vCartNorm,vArtNorm] = normalizar(vCartRed,vArtRed,-0.9,0.9,xmin,xmax,...
                                  ymin,ymax,theta1,theta2,theta3,orient);
salida=round(vArtNorm*100000)/100000;
entrada=round(vCartNorm*100000)/100000;
dlmwrite('VarArticulares.txt',salida)
dlmwrite('VarCartesianas.txt',entrada)

