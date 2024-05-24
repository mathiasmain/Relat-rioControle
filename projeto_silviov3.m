clear all
close all
%Resposta frequencia do kit-Lj
%valores medidos
Vin=4; %tensão de entrada
fhz=    [ 0.1  0.2 0.4 0.8 1.6 3.2 6.4 12.8 25.6 51.2 100 200 400]; %frequencia aplicada em HZ
vout=   [ 3.36 3.36 2.8 1.99 1.16 0.62 0.32 0.16 0.09 0.06 0.04 0.03 0.02]; %tensão de saída no taco 
phase= [-10  -20 -30 -54 -70 -80 -90 -90 -90 -90 -90 -90 -90 ]; %defasagem medida
Ganho_dB=20*log10(vout./Vin);
%cálculo de kg
kg=10^(Ganho_dB(1,1)/20);
%Pelo gráfico -45 graus é o antepenúltimo valor
Wc=fhz (1,4)*2*pi;
%Função de transferência
n=[kg]; d=[1/Wc 1]; g=tf(n,d); bode(n,d); hold on; grid
%figuras de BODE amplitude e fase
figure(2); subplot (2,1,1); semilogx(fhz*2*pi, Ganho_dB); grid; hold on;
semilogx (fhz*2*pi, Ganho_dB, '*k')
subplot(2,1,2); semilogx(fhz*2*pi,phase); grid; hold on
semilogx(fhz*2*pi,phase,'*k')
%Resumo das respostas
g=tf (n,d)
['      rad/s ','   db  ', '    Fase']
[fhz*2*pi;Ganho_dB; phase]'

% Agora iremos colocar um LEAD
close all

gi=tf(10,[1, 0])
gn=series(gi,g)
gmfn=feedback(gn,1)
subplot(2,1,1)
step(gmfn)
subplot(2,1,2)
bode(gn)
MFatual = 41.9
zeta=-log(0.03)/(sqrt(pi^2 + (log(0.03)^2)))
a=zeta
b=a*a
c=b*b
d=sqrt(1+4*c)
e=sqrt(-2*b+d)

MFdesejado= atan(2*zeta/e)*180/pi
% 67.17
Fase_de_seg=10
fi = MFdesejado - MFatual + Fase_de_seg 
fi=37
% beta -> modulo -> freq apra aquele modulo -> T -> wz -> wp ->
% kc para anular o ganho que vai dar
u1 = sin(fi*(pi/180))
beta = (1-u1)/(1+u1)
MargemGanho_db=20*log10(1/sqrt(beta))
wmax = 3.5
T = 1/ ( wmax*sqrt(beta))
wz = 1/T
wp = 1/(beta*T)

kc=wp/wz

Gcomp = tf([wz, kc], [1,wp])
figure(2)
subplot(3,1,1)
step(Gcomp)
subplot(3,1,2)
bode(Gcomp)
subplot(3,1,3)
margin(Gcomp)

