%% Función para la normalización de las variables cartesianas de la trayectoria
function [ vCartNorm ] = normalizarPrueba( vCartRed,ylimmin,ylimmax,xmin,xmax,ymin,ymax,orient)

%Las variables de posición se normalizan en el rango de trabajo del robot
vCartNorm(1,:)=ylimmin+(ylimmax-ylimmin)*(vCartRed(1,:)-xmin)/(xmax-xmin);
vCartNorm(2,:)=ylimmin+(ylimmax-ylimmin)*(vCartRed(2,:)-ymin)/(ymax-ymin);

%La variable de orientación se normaliza en el rango de orientación máxima
%y mínima determinados durante la generación de datos para el entrenamiento
vCartNorm(3,:)=ylimmin+(ylimmax-ylimmin)*(vCartRed(3,:)-orient(1))/(orient(2)-orient(1));

end

