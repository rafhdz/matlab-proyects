% Kevin Garcia Sotelo A01198951 
% Rafael Lorenzo Hernández Zambrano A00836774
% Arnulfo Iván Treviño Cavazos A01285311
% David Enrique Garcia Cruz A00838450
% Jacobo Gonzalez Kormendy A00838160

clc;
clear; 

%Información proporcionada por el usuario 
v_input = input("Insertar velocidad inicial en el circuito :");

A=[1000 100 10 1;27000 900 30 1;13824000 57600 240 1;21952000 78400 280 1];
y=[170; 255; 200; 240];

x=inv(A)*y;
coef=x;

%Estructura de la función 
yf=@(x) coef(1).*x.^3+coef(2).*x.^2+coef(3).*x+coef(4);

% Dibuja la figura inicial
figure('DoubleBuffer','on')
% Pelota en la posición inicial
hg=plot(10,170,'o','MarkerSize',25,'MarkerFaceColor','r');
set(hg,'EraseMode','normal'); 

hold on


xv=linspace(10,280,100);
plot(xv,yf(xv),'linewidth',10,'color','k')
plot(10,170, 'w--') % Punto dado

plot(30,255,'w--') % Punto propuesto

plot(240,200,'w--') % Punto propuesto

plot(280,240,'w--') % Punto dado

% Polinomio
poli= [coef(1) coef(2) coef(3) coef(4)]

% Funciones utilizadas y sus derivadas
de=polyder(poli);
der2=polyder(de);

yfde= @(x) (de(1).*x.^2)+(de(2).*x)+de(3);
yfder2= @(x) (der2(1).*x)+der2(2);

% Longitud de arco y area de curvatura
Lrc= @(x) sqrt(1+(yfde(x)).^2);
LongArco = integral(Lrc,10,280);

pucr = roots(de);


%Puntos criticos 1 y 2
rCurva = @(x) ((1+yfde(x).^2).^(3/2))/abs(yfder2(x));
radC = rCurva(pucr);

% Radio de corverutra del punto (90, 350)
p2 = nsidedpoly(1000, 'Center', [90 325.4557], 'Radius', 24.5443);
plot(p2, 'FaceColor', 'b')
axis equal

% Radio de corverutra del punto (240,200)
p = nsidedpoly(1000, 'Center', [240 224.5443], 'Radius', 24.5443);
plot(p, 'FaceColor', 'b')
axis equal

%Puntos de derrape:

lim= 10:280;
cont= 1;
valix = [0 0 0 0 ];

%Establecer los puntos 
for i = 11:1:280
    der2 = rCurva(i-1);
    de = rCurva(i);
    if der2 > 50 && de < 50
        valix(cont) = i;
        cont = cont + 1;
    elseif der2 < 50 && de > 50
        valix(cont) = i;
        cont = cont + 1;
    end
end

%Crear representación grafica 
hold on
for i = 1:4
    plot(valix(i),yf(valix(i)),'kx')
end

%Rectas tangencial:

% Datos importantes de la tangente
xv2=linspace(10,200,100);
xv3=linspace(10,280,100);
xv4=linspace(10,200,100);
xv5=linspace(200,280,100);
xv
ev1=yf(valix(1));
evd1=yfde(valix(1));
ev3=yf(valix(3));
evd3=yfde(valix(3));

%A partir del punto 1
tan=ev1+evd1*(xv2-valix(1));
plot(xv2,tan)

%A partir del punto 3
tan3=ev3+evd3*(xv3-valix(3));
plot(xv3,tan3)

%Puntos perpendiculares:

%A partir del punto 1
perp=ev1+(-1/evd1)*(xv2-valix(1))
plot(xv4,perp)
%A partir del punto 3
perp3=ev3+(-1/evd3)*(xv5-valix(3))
plot(xv5,perp3)

% Gradas:
r = patch([0 0 80 80 0 ], [ 0 10 10 0 0], [.5 0 .5]);
r2 = patch([0 0 80 80 0 ], [ 0 10 10 0 0], [.5 0 .5]);
rotate(r,[0 0 1],330,[450 -300 0]) %aproximadamente 20m
rotate(r2,[0 0 1],42, [-430 255 0]) %aproximadamente 20m
hold on

%puntos de referencia de las gradas
%[54.36 356.94 0] a exactamente 20m
%[240.18 194.9 0] a exactamente 20m
%r = rectangle('Position',[54.36 356.94 80 10]);
%r2 = rectangle('Position',[240.18 194.9 80 10]);

%establecimiento de variable y constantes en el programa 
g = 9.81;
u_cinetica = 0.7;
u_estatica = 0.9;
distance = (v_input^2)/(2*u_estatica*g);
vel_max = @(i) sqrt(g*u_estatica*rCurva(i))-v_input;
vel_der = fzero(vel_max,50);
m_vehiculo = 800;
e_cinetica = 0.5 * m_vehiculo * (v_input^2);

if (v_input < sqrt(g*u_estatica*radC(3))) %el coche se mantiene en la pista
    str1 = "Velocity "+v_input+" [ms]";
    text(200,425,str1);
    str4 = "Radio de la curva 1: "+ radC(3) + " [m]";
    text(200,350,str4);
    str5 =  "Radio de la curva 2: "+ radC(4) + " [m]";
    text(200,325,str5);
    for i= 1:280 %se desarrolla la animación normalmente
        set(hg,'XData',xv(i),'YData',yf(xv(i)) );
        drawnow;
        pause(0.002);
    end
else
    str1 = "Velocity "+v_input+" [ms]"; %el coche se derrapa de la pista
    text(200,425,str1); %etiquetas con la información
    str2 = "Calor: "+e_cinetica+ " [J]";
    text(200,400,str2);
    str3= "Distancia "+ distance + " [m]";
    text(200,375,str3);
    str4 = "Radio de la curva 1: "+ radC(3) + " [m]";
    text(200,350,str4);
    str5 =  "Radio de la curva 2: "+ radC(4) + " [m]";
    text(200,325,str5);
    xvx = linspace(vel_der,+(vel_der*4),100); 
    primer_e= yf(vel_der);
    der_e = yfde(vel_der);
    recta_tangente = primer_e + der_e * (xvx-vel_der);
    hold on
    plot(xvx,recta_tangente, "m--",'LineWidth',2,'Color','g')
    hold on
    for i=1:280 %la animación comienza de forma normal 
        set(hg,'XData',xv(i),'YData',yf(xv(i)) );
        drawnow;
        pause(0.05)
        if( xv(i) > vel_der ) %al detectar una adnormalidad se rompe la animación
            xv(i)
            break;
        end
    end
    for i=1 : distance*5 %recta cuando el coche sale de la pista 
         set(hg,'XData', xvx(i),'YData', recta_tangente(i));
         drawnow;
         pause(0.001)
    end
end