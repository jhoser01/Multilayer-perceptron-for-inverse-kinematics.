%% Función para la determinación de la matriz de transformación homogénea
%% mediante los parámetros de Denavit-Hartenberg

function [ T ] = denavit( theta,d,a,alpha )

%Rotación de un ángulo theta en el eje zi-1
T_z_theta=[cos(theta) -sin(theta) 0 0; sin(theta) cos(theta) 0 0; 0 0 1 0; 0 0 0 1];

%Traslación de una distancia d en la dirección del eje zi-1
T_z_d=[1 0 0 0; 0 1 0 0;0 0 1 d; 0 0 0 1];

%Traslación de una distancia a en el eje xi
T_x_a=[1 0 0 a; 0 1 0 0;0 0 1 0; 0 0 0 1];

%Rotación de un ángulo alpha en el eje xi
T_x_alpha=[1 0 0 0; 0 cos(alpha) -sin(alpha) 0; 0 sin(alpha) cos(alpha) 0; 0 0 0 1];

%Posmultiplicación de las matrices homogéneas anteriores
T=T_z_theta*T_z_d*T_x_a*T_x_alpha;

end

