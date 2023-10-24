clc;
clear all;
velocidad_inicial = 150; %Variable que se puede cambiar
diametro_proyectil = 0.1;%Variable que se puede cambiar
densidad_proyectil = 2700;%Variable que se puede cambiar
angulo_salida = pi/4; %Variable que se puede cambiar
altura_volcan = 2000; %Variable que se puede cambiar
coeficiente_de_fricion = 0.35;%Variable que se puede cambiar
densidad_de_aire = 1.1455;%Variable que se puede cambiar
dt = 0.1; %Variable que se puede cambiar
m = 4/3*pi*(diametro_proyectil/2)^3*densidad_proyectil; %se asume que el proyectil es una esfera
g = -9.81;
area_transversal = (diametro_proyectil/2)^2*pi;
velocidad_inicial_y = velocidad_inicial * sin(angulo_salida);
velocidad_inicial_x = velocidad_inicial * cos(angulo_salida);
t = [0];
x = [0];
y = [altura_volcan];
a_x = [0];
a_y = [0];
v_x = [velocidad_inicial_x];
v_y = [velocidad_inicial_y];
 disp('El tiempo que se tarda en correr el programa depende en la magnitude de dt, espere pacientemente')
 hold on
velocidad_impacto_y_1 = sqrt(velocidad_inicial_y^2+2*g*(-1*altura_volcan))*-1;
tiempo_total_1 = (velocidad_impacto_y_1 - velocidad_inicial_y)/g;
t_1 = linspace(0,tiempo_total_1,25);
x_1 = velocidad_inicial_x * t_1;
y_1 = altura_volcan + velocidad_inicial_y * t_1 + 0.5*g*t_1.^2;
plot(x_1,y_1,'o-g')
 plot(x(end),y(end),'.r')
 axis([0 max(x_1) 0 max(y_1)])
 title('Simulación con Resistencia del aire')
 xlabel('Alcance')
 ylabel('Altura')
 
while not(y(end)<0)
    disp(['Valor de x: ',num2str(x(end)),'  Valor de y: ',num2str(y(end))])
    t(end+1) = t(end) + dt;
    a_x(end+1) = (1/m)*(-0.5*densidad_de_aire*coeficiente_de_fricion*area_transversal*(sqrt(v_x(end)^2+v_y(end)^2))*v_x(end));
    a_y(end+1) = (1/m)*(-0.5*densidad_de_aire*coeficiente_de_fricion*area_transversal*(sqrt(v_x(end)^2+v_y(end)^2))*v_y(end)+m*g);
    v_y(end+1) = v_y(end) + a_y(end)*dt;
    v_x(end+1) = v_x(end) + a_x(end)*dt;
    x(end+1) = x(end) + v_x(end)*dt;
    y(end+1) = y(end) + v_y(end)*dt;
    plot(x(end),y(end),'.r')
    legend('Sin Resistencia','Con Resistencia')
    pause(0.0001)
end
disp('--------------------------------------------------------')
altura_maxima = max(y);
tiempo_altura_max = t(find(y==max(y)));
alcance_maximo = max(x);
%sin resistencia del aire
disp('Para la gráfica con resistencia de aire con los siguientes parámetros: ')
disp(['Velocidad inicial: ', num2str(velocidad_inicial),', Ángulo de Salida: ', num2str(angulo_salida),', Diámetro: ', num2str(diametro_proyectil)])
disp(['Densidad: ', num2str(densidad_proyectil),', Altura del Volcán: ', num2str(altura_volcan),', Coeficiente de fricción: ', num2str(coeficiente_de_fricion)])
disp(['Densidad del aire: ', num2str(densidad_de_aire),', Delta t: ', num2str(dt)])
disp(['La altura máxima es de: ',num2str(altura_maxima),' metros y ocurre ',num2str(tiempo_altura_max),' segundos después del inicio del transcurso' ])
disp(['El punto de impacto es: ',num2str(alcance_maximo), ' metros de distancia del volcán'])
disp(['El tiempo total de recorrido fue: ',num2str(t(end)), ' segundos'])
disp('Para la gráfica sin resistencia de aire: ')
disp(['La altura máxima es de: ',num2str(max(y_1)),' metros y ocurre ',num2str(t_1(find(y_1==max(y_1)))),' segundos después del inicio del transcurso' ])
disp(['El punto de impacto es: ',num2str(max(x_1)), ' metros de distancia del volcán'])
disp(['El tiempo total de recorrido fue: ',num2str(tiempo_total_1), ' segundos'])