%% Código para la prueba de la red generada con trayectorias de orientación 
%% variable, primero se muestra la trayectoria circular, luego la trayectoria
%% rectangular; por último se muestra el último eslabón en una orientación en
%% específico.
%% Círculo con orientación variable
%UNIVERSIDAD NACIONAL DE TRUJILLO
%INGENIERÍA MECATRÓNICA - CONTROL AVANZADO
%CINEMÁTICA INVERSA DE ROBOT MANIPULADOR 3GDL. 
%APRENDIZAJE BACK PROPAGATION. 
%FECHA: 

%Se genera el círculo definiendo su centro y radio dentro del espacio de
%trabajo del robot
wtp=0:0.01:2*pi;
center=[0.5,2.45];
radius=0.05;
xp=center(1)+radius*cos(wtp);
yp=center(2)+radius*sin(wtp);

%Se genera una función senoidal para la orientación variable, definimos el
%centro y la amplitud 
centro=2.07;
amplitud=0.1;
funct=centro+amplitud*sin(wtp);

%Se crea la matriz de variables cartesianas deseadas para la red neuronal 
%compuesta por las posiciones x,y del círculo generado y la función 
%senoidal para la orientación
in=[xp;yp;funct];


xmin=0.3;
xmax=0.7;
ymin=2.3;
ymax=2.6;

%Se normalizan y redondean las variables cartesianas para poder ingresarlas
%en la red neuronal
[ cartPrueba ] = normalizarPrueba( in,-0.9,0.9,xmin,xmax,ymin,ymax,orient);
entradaNet=round(cartPrueba *100000)/100000;

load('RedNeuronal_Entrenada.mat', 'net');
%Ingresamos los datos a la red y almacenamos la salida
outputNet=net(cartPrueba);

%Se denormalizan los datos obtenidos de la red neuronal para formar las
%variables articulares en radianes
[ outputAngle ] = denormalizar( outputNet,-0.9,0.9,theta1,theta2,theta3);

%Se usan las variables articulares para generar las variables cartesianas
%obtenidas
[ outputCart ] = CD3prueba( outputAngle );

%Se visualizan las variables cartesianas deseadas y obtenidas
figure(1)
plot(in(1,:),in(2,:),'b','LineWidth',2);
hold on
axis('equal')
grid on
plot(outputCart(1,:),outputCart(2,:),'r--','LineWidth',2);
axis([0.4 0.6 2.35 2.55 ]);
axis('equal')
xlabel('X[m]','FontSize',17, 'FontWeight', 'bold');
ylabel('Y[m]','FontSize',17, 'FontWeight', 'bold');
legend({'Trayectoria deseada','Trayectoria obtenida'},'FontSize',20,'Location','northwest')
set(gca, 'fontsize', 15)

figure(2)
plot(wtp,in(3,:),'b','LineWidth',2);
ylim([ orient(1) orient(2) ]);
xlim([ 0 6.3 ]);

hold on
grid on
plot(wtp,outputCart(3,:),'r--','LineWidth',2); 
xlabel('wt [rad]','FontSize',17, 'FontWeight', 'bold');
ylabel('\Theta [rad]','FontSize',17, 'FontWeight', 'bold');
legend({'Orientación deseada','Orientación obtenida'},'FontSize',20,'Location','northwest')
set(gca, 'fontsize', 15)

%Se obtiene la Raíz del Error Cuadrático Medio Normalizado para cada una 
%de las variables cartesianas 
RNMSECVX=RECMN(in(1,:),outputCart(1,:));
RNMSECVY=RECMN(in(2,:),outputCart(2,:));
RNMSECVO=RECMN(in(3,:),outputCart(3,:));

% Mostrar resultados en consola
fprintf('----------------------------------------\n');
fprintf('RESULTADOS DE LA TRAYECTORIA CIRCULAR:\n');
fprintf('----------------------------------------\n');
fprintf('Error NRMSE en X: %.4f%%\n', RNMSECVX*100);
fprintf('Error NRMSE en Y: %.4f%%\n', RNMSECVY*100);
fprintf('Error NRMSE en Orientación: %.4f%%\n', RNMSECVO*100);
fprintf('----------------------------------------\n');
 
  %% Segunda parte : RectanguloVar
%Se genera el rectángulo dentro del espacio de trabajo del robot
xs1=0.35:0.3/629:0.60;
ys1=2.35*ones(1,length(xs1));
ys2=2.35:0.3/629:2.50;
xs2=0.60*ones(1,length(ys2));
xs3=0.60:-0.3/629:0.35;
ys3=2.50*ones(1,length(xs3));
ys4=2.50:-0.3/629:2.35;
xs4=0.35*ones(1,length(ys4));
xp=[xs1 xs2 xs3 xs4];
yp=[ys1 ys2 ys3 ys4];

%Se genera una función senoidal para la orientación variable, definimos el
%centro y la amplitud 
wtp=linspace(0,2*pi,length(xp));
centro=2.07;
amplitud=0.15;
funct=centro+amplitud*sin(wtp);

%Se crea la matriz de variables cartesianas deseadas para la red neuronal 
%compuesta por las posiciones x,y del rectángulo generado y la función 
%senoidal para la orientación
in=[xp;yp;funct];


%Se normalizan y redondean las variables cartesianas para poder ingresarlas
%en la red neuronal
[ cartPrueba ] = normalizarPrueba( in,-0.9,0.9,xmin,xmax,ymin,ymax,orient);
entradaNet=round(cartPrueba *100000)/100000;

%Ingresamos los datos a la red y almacenamos la salida
outputNet=net(cartPrueba);

%Se denormalizan los datos obtenidos de la red neuronal para formar las
%variables articulares en radianes
[ outputAngle ] = denormalizar( outputNet,-0.9,0.9,theta1,theta2,theta3);

%Se usan las variables articulares para generar las variables cartesianas
%obtenidas
[ outputCart ] = CD3prueba( outputAngle );

%Se visualizan las variables cartesianas deseadas y obtenidas
figure(3)
plot(in(1,:),in(2,:),'b','LineWidth',2);
hold on
grid on
plot(outputCart(1,:),outputCart(2,:),'r--','LineWidth',2);
axis([xmin xmax ymin 2.60 ]);
xlabel('X[m]','FontSize',16, 'FontWeight', 'bold');
ylabel('Y[m]','FontSize',16, 'FontWeight', 'bold');
legend({'Trayectoria deseada','Trayectoria obtenida'},'FontSize',20,'Location','northwest')
set(gca, 'fontsize', 14)

figure(4)
plot(wtp,in(3,:),'b','LineWidth',2);
hold on
grid on
plot(wtp,outputCart(3,:),'r--','LineWidth',2); 
axis([0 2*pi orient(1) orient(2) ]);
xlabel('wt [rad]','FontSize',17, 'FontWeight', 'bold');
ylabel('\Theta [rad]','FontSize',17, 'FontWeight', 'bold');
legend({'Orientación deseada','Orientación obtenida'},'FontSize',20,'Location','northwest')
set(gca, 'fontsize', 15)

%Se obtiene la Raíz del Error Cuadrático Medio Normalizado para cada una 
%de las variables cartesianas 
RNMSERVX=RECMN(in(1,:),outputCart(1,:));
RNMSERVY=RECMN(in(2,:),outputCart(2,:));
RNMSERVO=RECMN(in(3,:),outputCart(3,:));
 
% Mostrar resultados en consola
fprintf('----------------------------------------\n');
fprintf('RESULTADOS DE LA TRAYECTORIA RECTANGULAR:\n');
fprintf('----------------------------------------\n');
fprintf('Error NRMSE en X: %.4f%%\n', RNMSERVX*100);
fprintf('Error NRMSE en Y: %.4f%%\n', RNMSERVY*100);
fprintf('Error NRMSE en Orientación: %.4f%%\n', RNMSERVO*100);
fprintf('----------------------------------------\n');

 %%
 %% Visualizar
 %Se definen distancias para el efector final
dis1=0.02;
dis2=0.02;

%Se selecciona uno de los vectores de la matriz de variables articulares 
%para ser representado por el robot
%Parámetros de Denavit-Hartenberg
%% 
theta=[outputAngle(:,1).' ] ;
d    = [0    0   0];
a    = [1    1   1];
alfa = [0    0   0];

% Se asigna el sistema de coordenadas de referencia
x0 = 0; y0 = 0; z0=0;

%Se grafican las variables cartesianas de posición deseadas y obtenidas
figure(1)
xa3=in(1,:);
ya3=in(2,:);
xa4=outputCart(1,:);
ya4=outputCart(2,:);
NameArray = {'Marker','Tag','Color'};
ValueArray = {'.','target','b';'.','tray','r'};
set(plot(xa3,ya3,xa4,ya4,'LineWidth',2),NameArray,ValueArray);
grid on;
xlabel('X[m]','FontSize',16, 'FontWeight', 'bold');
ylabel('Y[m]','FontSize',16, 'FontWeight', 'bold');
hold on;

% Matrices de transformación homogénea 
A01 = denavit(theta(1),   d(1), a(1), alfa(1));
A12 = denavit(theta(2),   d(2), a(2), alfa(2));
A23 = denavit(theta(3),   d(3), a(3), alfa(3));

% Matrices de transformación del primer sistema al segundo y tercero
A02 = A01 * A12;
A03 = A02 * A23;

% Vectores de posición de cada sistema de coordenadas con respecto a la
% base
x1 = A01(1,4); y1 = A01(2,4);
x2 = A02(1,4); y2 = A02(2,4);
x3 = A03(1,4); y3 = A03(2,4);

%Posiciones para representar el efector final
alphaa=sum(theta)-pi/2;
xf2=dis1/(sqrt((atan(alphaa))^2+1))+x3;
yf2=(xf2-x3)*tan(alphaa)+y3;

xf1=-dis1/(sqrt((atan(alphaa))^2+1))+x3;
yf1=(xf1-x3)*tan(alphaa)+y3;

xf3=-dis2/(sqrt(atan(sum(theta))^2+1))+xf2;
yf3=(xf3-xf2)*tan(sum(theta))+yf2;

xf4=-dis2/(sqrt((atan(sum(theta)))^2+1))+xf1;
yf4=(xf4-xf1)*tan(sum(theta))+yf1;


% Dibujo del último eslabón y efector final del robot y las posiciones 
% deseadas y obtenidas

   xa2=[x0 x0 x0 x1 x2 x3 xf2 xf3 xf2 xf1 xf4];
   ya2=[y0 y0 y0 y1 y2 y3 yf2 yf3 yf2 yf1 yf4];

NameArray = {'Marker','Tag','Color'};
ValueArray = {'.','robot',[0 0.4353 0.2392]};
set(plot(xa2,ya2,'LineWidth',2),NameArray,ValueArray);
 axis('equal')
 axis([0.2 0.9 2.2 2.6])

legend({'Trayectoria deseada','Trayectoria obtenida'},'FontSize',18,'Location','northwest')

