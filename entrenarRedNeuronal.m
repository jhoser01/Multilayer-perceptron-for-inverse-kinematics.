%% Código para el entrenamiento de la red neuronal
%UNIVERSIDAD NACIONAL DE TRUJILLO
%INGENIERÍA MECATRÓNICA - CONTROL AVANZADO
%CINEMÁTICA INVERSA DE ROBOT MANIPULADOR 3GDL. 
%APRENDIZAJE BACK PROPAGATION. 
%FECHA: 
%..................................................................................
%Se llaman las variables de entrada, salida de la generación de datos
 x= dlmread('VarCartesianas.txt');
 t=dlmread('VarArticulares.txt');

 %Se define el tipo de red neuronal a usar así como el tipo de
 %entrenamiento a usar,
 %Para Gradiente Descendente Simple : 'traingd'
 %Para Gradiente Descendente con Momento : 'traingdm'
net = feedforwardnet([15, 12],'trainlm'); % el número 4 se ve modificado en los parámetros que se configuran después

%Se define el número de capas de la red neuronal 
net.numLayers = 3;

%Se define el número de neuronas en cada una de las capas de la red, tener
%en cuenta que para este caso como se tienen tres salidas la segunda capa
%debe tener tres neuronas.
net.layers{1}.size = 17;
net.layers{2}.size = 15;
net.layers{3}.size = 3;

%Se define la función de transferencia a usar en cada una de las capas de
%la red neuronal,
%Para tangente hiperbólica :'tansig'
%Para una función lineal :'purelin'
%Para Log Sigmoid: 'logsig' 
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
net.layers{3}.transferFcn = 'purelin';

%Prevenir sobreajuste
net.performParam.regularization = 0.2;     % Factor de regularización L2

%Se asigna un sesgo para cada una de las capas de la red neuronal
 net.biasConnect=[1;1;1];
 
%La salida de la red neuronal se le asigna a la segunda capa de la red  
 net.outputConnect= [ 0 0 1];

%Se conecta la salida de la primera capa con la entrada de la segunda 
 net.layerConnect=[ 0 0 0;
                    1 0 0
                    0 1 0];

 %Configuración de conexión de entrada
 net.inputConnect = [1; 0; 0];

%Se bloquea la generación de números aleatorios para que todas las redes 
%tengan los mismos pesos iniciales                  
rng(4151941);

%Inicialización de los pesos y sesgos de red neuronal
net.initFcn='initlay';
net.layers{:}.initFcn='initwb';
net.inputWeights{:,:}.initFcn='rands';
net.layerWeights{:,:}.initFcn='rands';
net.biases{:}.initFcn='rands';

%Se asigna el porcentaje de datos para los datos de entrenamiento,
%validación y prueba, esta división se hace de forma ordenada, no aleatoria
net.divideFcn =  'divideint';
net.divideParam.trainRatio = 80/100;
net.divideParam.valRatio = 10/100;
net.divideParam.testRatio = 10/100;

%Configuración de los parámetros de la red neuronal
net.trainParam.show = 5;

%Configuración de la tasa de aprendizaje
%net.trainParam.lr = 0.0015;

%Configuración del momento, para entrenamiento mediante Gradiente
%Descendente Simple este parámetro no existe
%net.trainParam.mc=0.95;

%Configuración de las condiciones de parada del entrenamiento
%Parada por número de iteraciones
net.trainParam.epochs = 50;

%Parada por desempeño en el entrenamiento
net.trainParam.goal = 1e-7;

% 2. Ajustar parámetros críticos de entrenamiento
net.trainParam.mu = 0.001;                  % Parámetro inicial de LM
net.trainParam.mu_dec = 0.1;                % Factor de decremento de mu
net.trainParam.mu_inc = 10;                 % Factor de incremento de mu


%Parada por tiempo de entrenamiento
net.trainParam.time = Inf;

%Parada por validación
net.trainParam.max_fail = 5;

%Parada por error alcanzado
net.trainParam.min_grad = 1e-6;

%Se asigna la función para evaluar el desempeño,
%Error Cuadrático Medio : 'mse'
net.performFcn = 'mse';
net.performParam.normalization = 'none'; 

%Inicialización de la red neuronal
net=init(net);

%Entrenamiento de la red neuronal, se almacenan tanto la red entrenada como
%datos durante el entrenamiento
[net,tr] = train(net,x,t);

save('RedNeuronal_Entrenada.mat', 'net'); 
save('RedNeuronal_Entrenada.mat', 'tr', '-append');
%%
% wtp=0:0.01:2*pi;
% center=[0.5,2.45];
% radius=0.05;
% xp=center(1)+radius*cos(wtp);
% yp=center(2)+radius*sin(wtp);
% 
% %Se genera una función senoidal para la orientación variable, definimos el
% %centro y la amplitud 
% centro=2.07;
% amplitud=0.1;
% funct=centro+amplitud*sin(wtp);
% 
% %Se crea la matriz de variables cartesianas deseadas para la red neuronal 
% %compuesta por las posiciones x,y del círculo generado y la función 
% %senoidal para la orientación
% in=[xp;yp;funct];
% outputNet=net(cartPrueba);
