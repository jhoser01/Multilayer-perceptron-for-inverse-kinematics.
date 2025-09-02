%% Código para probar trayectoria desde CSV con red neuronal
% UNIVERSIDAD NACIONAL DE TRUJILLO
% INGENIERÍA MECATRÓNICA - CONTROL AVANZADO
% CINEMÁTICA INVERSA DE ROBOT MANIPULADOR 3GDL

% -------------------------------------------------------------------------
%% 1. Cargar trayectoria desde archivo CSV
% -------------------------------------------------------------------------
% Leer archivo CSV (asumir formato: x,y,z)
trayectoria_data = readmatrix('SITEM_positions.csv');

% Extraer componentes (z no se usa ya que el robot opera en plano XY)
xp = trayectoria_data(:,1)';  % Vector fila de coordenadas X
yp = trayectoria_data(:,2)';  % Vector fila de coordenadas Y
num_puntos = length(xp);      % Número total de puntos

% Definir orientación (variable senoidal)
wtp = linspace(0, 2*pi, num_puntos);  % Parámetro angular
centro = 2.07;                       % Orientación base (rad)
amplitud = 0.15;                      % Amplitud de variación
funct = centro + amplitud*sin(wtp);  % Orientación variable

% Crear matriz de entrada para la red neuronal
in = [xp; yp; funct];  % Matriz 3×num_puntos: [X; Y; Orientación]

% -------------------------------------------------------------------------
%% 2. Normalización de datos de entrada
% -------------------------------------------------------------------------
% Suponiendo que tienes estos valores de los datos de entrenamiento:
%   xmin, xmax: rango de valores X durante entrenamiento
%   ymin, ymax: rango de valores Y durante entrenamiento
%   orient_min, orient_max: rango de orientación durante entrenamiento

xmin=0.3;
xmax=0.7;
ymin=2.3;
ymax=2.6;
% Normalizar datos de prueba (función personalizada)
[cartPrueba] = normalizarPrueba(in, -0.9, 0.9, xmin, xmax, ymin, ymax, orient);

% Redondeo para precisión controlada
entradaNet = round(cartPrueba * 100000) / 100000;

% -------------------------------------------------------------------------
%% 3. Predicción con red neuronal
% -------------------------------------------------------------------------
% Cargar red neuronal entrenada (si no está en workspace)
% load('red_robot_entrenada.mat', 'net');

% Realizar predicción
outputNet = net(cartPrueba);

% -------------------------------------------------------------------------
%% 4. Procesamiento de salida
% -------------------------------------------------------------------------
% Desnormalizar ángulos articulares
[outputAngle] = denormalizar(outputNet, -0.9, 0.9, theta1, theta2, theta3);

L1_custom = 1;  % Longitud eslabón 1 [m]
L2_custom = 1;  % Longitud eslabón 2 [m]
L3_custom = 1;  % Longitud eslabón 3 [m]

[outputCart] = CD3prueba(outputAngle, L1_custom, L2_custom, L3_custom);
% Calcular trayectoria real mediante cinemática directa

% -------------------------------------------------------------------------
%% 5. Visualización de resultados
% -------------------------------------------------------------------------
% Calcular límites automáticos para gráficos
x_margin = 0.1 * (max(xp) - min(xp));
y_margin = 0.1 * (max(yp) - min(yp));
xmin_plot = min(xp) - x_margin;
xmax_plot = max(xp) + x_margin;
ymin_plot = min(yp) - y_margin;
ymax_plot = max(yp) + y_margin;

%% Figura 1: Trayectoria en espacio XY
figure(1)
set(gcf, 'Position', [100, 100, 800, 600])  % Tamaño personalizado
plot(in(1,:), in(2,:), 'b', 'LineWidth', 2.5, 'DisplayName', 'Trayectoria deseada');
hold on
plot(outputCart(1,:), outputCart(2,:), 'r--', 'LineWidth', 1.8, 'DisplayName', 'Trayectoria obtenida');
grid on
axis equal  % Mantener proporciones reales
axis([xmin_plot xmax_plot ymin_plot ymax_plot]);
xlabel('X [m]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Y [m]', 'FontSize', 14, 'FontWeight', 'bold');
title('Comparación de Trayectorias en Espacio Cartesiano', 'FontSize', 16);
legend('show', 'Location', 'best', 'FontSize', 12);
set(gca, 'FontSize', 12, 'GridAlpha', 0.3);

%% Figura 2: Orientación del efector final
figure(2)
set(gcf, 'Position', [200, 200, 900, 400])  % Tamaño personalizado
plot(wtp, in(3,:), 'b', 'LineWidth', 2.5, 'DisplayName', 'Orientación deseada');
hold on
plot(wtp, outputCart(3,:), 'r--', 'LineWidth', 1.8, 'DisplayName', 'Orientación obtenida');
grid on
xlabel('Parámetro de Trayectoria [rad]', 'FontSize', 14, 'FontWeight', 'bold');
ylabel('Orientación [rad]', 'FontSize', 14, 'FontWeight', 'bold');
title('Control de Orientación del Efector Final', 'FontSize', 16);
legend('show', 'Location', 'best', 'FontSize', 12);
set(gca, 'FontSize', 12, 'GridAlpha', 0.3);
xlim([0, 2*pi]);

% -------------------------------------------------------------------------
%% 6. Cálculo de errores
% -------------------------------------------------------------------------
% Función RECMN asumida (Raíz Error Cuadrático Medio Normalizado)
RNMSERVX = RECMN(in(1,:), outputCart(1,:));
RNMSERVY = RECMN(in(2,:), outputCart(2,:));
RNMSERVO = RECMN(in(3,:), outputCart(3,:));

% Mostrar resultados en consola
fprintf('----------------------------------------\n');
fprintf('RESULTADOS DE LA TRAYECTORIA SITEM:\n');
fprintf('----------------------------------------\n');
fprintf('Error NRMSE en X: %.4f%%\n', RNMSERVX*100);
fprintf('Error NRMSE en Y: %.4f%%\n', RNMSERVY*100);
fprintf('Error NRMSE en Orientación: %.4f%%\n', RNMSERVO*100);
fprintf('----------------------------------------\n');

% -------------------------------------------------------------------------
%% 7. (Opcional) Guardar resultados para análisis posterior
% -------------------------------------------------------------------------
% Guardar datos de salida
results = struct();
results.trayectoria_deseada = in;
results.trayectoria_obtenida = outputCart;
results.angulos_articulares = outputAngle;
results.errores = [RNMSERVX, RNMSERVY, RNMSERVO];

save('resultados_trayectoria_csv.mat', 'results');

% -------------------------------------------------------------------------
%% Funciones auxiliares necesarias (deben estar en tu path)
% -------------------------------------------------------------------------
% Asegúrate de tener estas funciones implementadas:
%   - normalizarPrueba.m
%   - denormalizar.m
%   - CD3prueba.m
%   - RECMN.m