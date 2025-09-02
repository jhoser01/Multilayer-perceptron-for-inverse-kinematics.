%% Función para el cálculo de la Raíz del Error Cuadrático Medio Normalizado
function [ salida ] = RECMN( targ, o )
MSEref = mean(var(targ',1));
salida = mse(targ-o)/MSEref;
salida=sqrt(salida);
end


