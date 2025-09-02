%% Función para denormalizar los datos obtenidos a la salida de la red neuronal
%% a variables cartesianas
function [ outputAngle ] = denormalizar( outputNet,ylimmin,ylimmax,th1,th2,th3)
outputAngle(1,:)=(outputNet(1,:)-ylimmin)*(th1(2)-th1(1))/(ylimmax-ylimmin)+th1(1);
outputAngle(2,:)=(outputNet(2,:)-ylimmin)*(th2(2)-th2(1))/(ylimmax-ylimmin)+th2(1);
outputAngle(3,:)=(outputNet(3,:)-ylimmin)*(th3(2)-th3(1))/(ylimmax-ylimmin)+th3(1);

end

