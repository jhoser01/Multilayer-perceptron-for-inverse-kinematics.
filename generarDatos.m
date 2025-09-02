%% Función para la generación de datos en los rangos determinados para las 
%% variables articulares
function [ v_cartesianas,v_articulares ]=generarDatos( paso,theta1,theta2,theta3 )

%Definición de las longitudes de los eslabones
L1=1;
L2=1;
L3=1;

%Parámetros de Denavit-Hartenberg, el parámetro theta se define dentro del
%bucle
d=[0;0;0];
a=[L1;L2;L3];
alpha=[0;0;0];

%Se hace recorrer cada variable articular en los pasos preestablecidos
%dentro del rango que se definió
i=1;
for th1=theta1(1):paso:theta1(2)
    for th2=theta2(1):paso:theta2(2)
       for th3=theta3(1):paso:theta3(2)
           
           %Matrices de Denavit-Hartenberg
            T01=denavit(th1,d(1),a(1),alpha(1));
            T12=denavit(th2,d(2),a(2),alpha(2));
            T23=denavit(th3,d(3),a(3),alpha(3));
            T03=T01*T12*T23;

            %Ecuaciones de la cinemática directa
            x=T03(1,4);
            y=T03(2,4);
            orientacion=th1+th2+th3;           
            v_articulares(:,i)=[th1;th2;th3];
            v_cartesianas(:,i)=[x;y;orientacion];                             
          i=i+1;
        end
    end
end
end

