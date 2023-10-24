clc
clear
[z,v,t] = runge_final(1,1,7.95e9,5,0.01);
plot(t,z,'b')
hold on
plot(t,v,'g')

function [z,v,t] = runge_final(m,I,d,R,h)
    z = 100;
    v = 0;
    t = 0;
    cont = 0;
    while and(z(end)>0,cont<1e4)
        %--------------------------------
        zant = z(end);
        vant = v(end);
        K1 = aceleracion(m,I,d,R,zant);
        %--------------------------------
        zK1 = zant + h/2*vant;
        vK1 = vant + h/2*K1;
        K2 = aceleracion(m,I,d,R,zK1);
        %--------------------------------
        zK2 = zant+h/2*vK1;
        vK2 = vant + h/2*K2;
        K3 = aceleracion(m,I,d,R,zK2);
        %--------------------------------
        zK3 = zant+h*vK2;
        vK3 = vant+h*K3;
        K4 = aceleracion(m,I,d,R,zK3);
        %--------------------------------
        zsig = zant + h*(vant+2*vK1+2*vK2+vK3)/6;
        vsig = vant + h*(K1+2*K2+2*K3+K4)/6;
        %--------------------------------
        z = [z zsig];
        v = [v vsig];
        t = [t t(end)+h];
        cont= cont + 1;
        
    end
end

function a=aceleracion(m,I,d,R,z) % sub función
    a = (3*d*(4*pi*1e-7)*R^2*I)/(2*m)*z/((R^2+z^2)^(5/2))-10;
end