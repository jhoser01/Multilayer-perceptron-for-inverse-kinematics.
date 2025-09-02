%% Función para determinar las variables cartesianas obtenidas a partir 
%% de variables articulares usando el método Denavit-Hartenberg
function [ outputCart ] = CD3prueba( outputAngle, L1, L2, L3 )
    % CD3prueba - Cinemática Directa para robot 3GDL
    % 
    % Uso:
    %   outputCart = CD3prueba(outputAngle)        % Usa valores por defecto (1,1,1)
    %   outputCart = CD3prueba(outputAngle, 5,4,2) % Con longitudes personalizadas
    
    % Manejo de argumentos opcionales (como en Python)
    if nargin < 4
        if nargin < 3
            if nargin < 2
                % Valores por defecto (1m cada eslabón)
                L1 = 1;
                L2 = 1;
                L3 = 1;
            end
        end
    end
    
    % Variables articulares
    th1 = outputAngle(1,:);
    th2 = outputAngle(2,:);
    th3 = outputAngle(3,:);

    % Parámetros Denavit-Hartenberg
    d = [0; 0; 0];
    a = [L1; L2; L3];  % Usa las longitudes proporcionadas
    alpha = [0; 0; 0];
    
    outputCart = zeros(3, size(outputAngle,2));
    
    for i = 1:size(outputAngle,2)
        % Matrices de transformación
        T01 = denavit(th1(i), d(1), a(1), alpha(1));
        T12 = denavit(th2(i), d(2), a(2), alpha(2));
        T23 = denavit(th3(i), d(3), a(3), alpha(3));
        T03 = T01 * T12 * T23;

        % Posición (x,y)
        outputCart(1,i) = T03(1,4);
        outputCart(2,i) = T03(2,4);
        
        % Orientación (suma angular)
        outputCart(3,i) = th1(i) + th2(i) + th3(i);
        
        % Normalizar orientación a [0, 2pi)
        outputCart(3,i) = mod(outputCart(3,i), 2*pi);
    end
end

