% Lead Zirconate Titanate
% Type 5H4E (Industry Type 5H, Navy Type VI)
%
% Piezoelectric
%
% K_3 Relative Dielectric constant (at 1 KHz)
% d_33, d_31 Piezoelectric strain coefficient [m/V]
% g_33, g_31 Piezoelectric Voltage coefficient [Vm/N]
% k_33, k_31 Coupling Coefficient
% E_p Polarization field
% E_c Initial Depolarization field
%
% Mechanical
%
% rho Density [Kg/m^3]
% Q Mechanical
% Y_3,Y_1 Elastic Modulus [N/m^2]
%
% Thermal
%
% T_e Thermal expansion coefficient [m/m grader]
% T_c Curie Temperature [grader]
%
%% Constants

clear all;
close all;

%produktblad
whole_length = 0.0318;
l = 0.0267;
measure_point = l;
width = 0.0032;
w_i = [width,width,width];
higth = 0.00013; %each
h_i = [higth,higth,higth];
h_j = h_i;

K_3 = 3800;
epsilon_33 = K_3; %TODO:?
d_33 = 650*10^(-12);
d_31 = [-320*10^(-12),0,-320*10^(-12)];
g_33 = 19.0*10^(-3);
g_31 = -9.5*10^(-3);
k_33 = 0.75;
k_31 = 0.44;
E_p = 1.5*10^6;
E_c = 3.0*10^5;
rho = [7800,8400,7800];
Q = 32;
Y_3 = 5.0*10^10;
Y_1 = 6.2*10^10;
s_33 = 1/Y_3; %TODO:? 
s_11 = [1/Y_1,9.0909e-12,1/Y_1]; %TODO:brass plockad fr�n wikipedia
T_e = 3*10^(-6);
T_c = 230;

%table 6.1
%syms a
%vpasolve(1+cos(a).*cosh(a)==0,a, [0 10],'random',true)
%result solved from (6.24) 1+cos(kl)cosh(kl)=0

k_ml = [1.8751,4.6941,7.8548,10.9955,14.137];

m = sum(rho*l.*width.*higth);

%bokens v�rlden
% l = 20*10^-3;
% w_i = [8,8,8,8,8,8,8].*10^-3;
% h_i = [100,200,48,48,48,48,48].*10^-6;
% h_j = h_i; %[100,200]*10^-6;
% s_11 = [6.369,17.857,14.144,14.144,14.144,14.144,14.144].*10^-12;
% rho = [8300,1998,8100,8100,8100,8100,8100];
% m=0.439*10^-3;
% l=17.3*10^-3;
% d_31 = [0,0,-350*10^(-12),-350*10^(-12),-350*10^(-12),...
%     -350*10^(-12),-350*10^(-12)];
%% Book equations

%% 4.23
%4.23
del1 = zeros(size(h_j));

for n = (1:length(h_j));
    del1(n) = (w_i(n)/s_11(n))*h_i(n)*sum(h_j(1:n));
end

z_streck = -((sum((w_i./s_11).*h_i.^2))-(2*sum(del1)))/...
    (2*sum((w_i./s_11).*h_i));

%% 6.10-11,6.29
%6.10-11
k = k_ml./l;

x=(0:1*10^-5:measure_point);

kx_1 = k(1)*x;
kx_2 = k(2)*x;
kx_3 = k(3)*x;
kx_4 = k(4)*x;
kx_5 = k(5)*x;

c_wave = 1/2*(cosh(k_ml)-cos(k_ml));
s_wave = 1/2*(sinh(k_ml)-sin(k_ml));

c_wave_1 = 1/2*(cosh(kx_1)-cos(kx_1));
s_wave_1 = 1/2*(sinh(kx_1)-sin(kx_1));

c_wave_2 = 1/2*(cosh(kx_2)-cos(kx_2));
s_wave_2 = 1/2*(sinh(kx_2)-sin(kx_2));

c_wave_3 = 1/2*(cosh(kx_3)-cos(kx_3));
s_wave_3 = 1/2*(sinh(kx_3)-sin(kx_3));

c_wave_4 = 1/2*(cosh(kx_4)-cos(kx_4));
s_wave_4 = 1/2*(sinh(kx_4)-sin(kx_4));

c_wave_5 = 1/2*(cosh(kx_5)-cos(kx_5));
s_wave_5 = 1/2*(sinh(kx_5)-sin(kx_5));

C_wave = 1/2*(cosh(k_ml)+cos(k_ml));
S_wave = 1/2*(sinh(k_ml)+sin(k_ml));

c_wave_d = 1/2*(sinh(k_ml)+sin(k_ml));
s_wave_d = 1/2*(cosh(k_ml)-cos(k_ml));

C_wave_d = 1/2*(sinh(k_ml)-sin(k_ml));
S_wave_d = 1/2*(cosh(k_ml)+cos(k_ml));

%6.29
X_m = c_wave-s_wave .* (C_wave ./ S_wave); % x = l
X_m_1 = c_wave_1-s_wave_1 * (C_wave(1) / S_wave(1)); % x <= l
X_m_2 = c_wave_2-s_wave_2 * (C_wave(2) / S_wave(2));
X_m_3 = c_wave_3-s_wave_3 * (C_wave(3) / S_wave(3));
X_m_4 = c_wave_4-s_wave_4 * (C_wave(4) / S_wave(4));
X_m_5 = c_wave_5-s_wave_5 * (C_wave(5) / S_wave(5));

%X_m_d = c_wave_d-(s_wave_d.*(C_wave./S_wave) + s_wave.*((C_wave_d.*S_wave - C_wave.*S_wave_d)./(S_wave.^2))); % x = l

X_m_d = k.*(S_wave - c_wave.*C_wave./S_wave);

%% 4.32 
%4.32
del2 = zeros(size(h_j));

for n = (1:length(h_j));
    del2(n) = (w_i(n)/s_11(n))*(3*h_i(n)*(z_streck-sum(h_j(1:n)))*...
        (z_streck-sum(h_j(1:n-1)))+h_i(n)^3);
end

C = 1/3 * sum(del2);

%% 5.92

%5.92
my = sum(rho.*h_i.*w_i); %b�da ger samma
%my = m/l;

%% 6.25
%6.25
w_m = ((k_ml.^2)./(l^2))*sqrt(C/my);

%% 6.71

%6.71
%freq = (1:7.7245:500000); 
freq = (20:0.045306122448980:20000);
%ex_freq = 1.1*10^3; %TODO: �NDRA TILL BEROENDE AV INSIGNAL
%ex_freq = 7.1*10^3;
ex_freq = 1.1*10^3;
ny_m = (ex_freq*2*pi)./w_m;
ny_m_1 = (freq*2*pi)./w_m(1);
ny_m_2 = (freq*2*pi)./w_m(2);
ny_m_3 = (freq*2*pi)./w_m(3);
ny_m_4 = (freq*2*pi)./w_m(4);
ny_m_5 = (freq*2*pi)./w_m(5);

%% 6.83

%6.83
alpha_m_kml = (sin(k_ml).*sinh(k_ml))./(sinh(k_ml)+sin(k_ml));

%% 6.96

%6.96
del3 = zeros(size(h_j));

for n = (1:length(h_j));
    del3(n) = ((d_31(n)*w_i(n))/(s_11(n)*h_i(n))).*...
        (2*z_streck*h_i(n) - 2*h_i(n)*sum(h_j(1:n))+h_i(n)^2);
end

m_piezo = (1/2)*sum(abs(del3)); %TODO: absolutbeloppet �r p�hittat sj�lv!!!!!!!

%% 9.16
%r_a = 4.528; %[Ns/m^2]  %BOKENS

fi1 = 0.02099e-3; %Values from step measurement
fi2 = 0.001417e-3;
tau1 = 1.015; %[s]      %4.474e4; samples from the same measurement
tau2 = 1.099; %[s]      %4.845e4;
q=18; %periods
tau_d_m= tau2-tau1; %[s]

r = (2*m)/tau_d_m * log(fi1/fi2); %[Ns/m] 
r_a = r/l; %[Ns/m^2]


% Values from plot
% fi1 = 0.01143e-3;
% fi2 = 0.0007973e-3;
% tau1 = 1.035; %[s]      %4.474e4; Samples
% tau2 = 1.105; %[s]
% 
% q=15; %periods
% tau_d_m= tau2-tau1; %[s]
% r = (2 * m)/tau_d_m * log(fi1/fi2)*2 %[Ns/m]
% r_a = r/l; %[Ns/m^2]

%% 9.20

u_0 = 2; %[V]

egen_1_l = ((X_m(1)*k_ml(1)*alpha_m_kml(1)*u_0)./...
    ((w_m(1)^2)*sqrt((1-ny_m_1.^2).^2+((2*r_a*ny_m_1)/(w_m(1)*my)).^2)));

egen_2_l = ((X_m(2)*k_ml(2)*alpha_m_kml(2)*u_0)./...
    ((w_m(2)^2)*sqrt((1-ny_m_2.^2).^2+((2*r_a*ny_m_2)/(w_m(2)*my)).^2)));

egen_3_l = ((X_m(3)*k_ml(3)*alpha_m_kml(3)*u_0)./...
    ((w_m(3)^2)*sqrt((1-ny_m_3.^2).^2+((2*r_a*ny_m_3)/(w_m(3)*my)).^2)));

egen_4_l = ((X_m(4)*k_ml(4)*alpha_m_kml(4)*u_0)./...
    ((w_m(4)^2)*sqrt((1-ny_m_4.^2).^2+((2*r_a*ny_m_4)/(w_m(4)*my)).^2)));

egen_5_l = ((X_m(5)*k_ml(5)*alpha_m_kml(5)*u_0)./...
    ((w_m(5)^2)*sqrt((1-ny_m_5.^2).^2+((2*r_a*ny_m_5)/(w_m(5)*my)).^2)));

egen_1 = ((X_m_1*k_ml(1)*alpha_m_kml(1)*u_0)/...
    ((w_m(1)^2)*sqrt((1-ny_m(1)^2)^2+((2*r_a*ny_m(1))/(w_m(1)*my))^2)));

egen_2 = ((X_m_2*k_ml(2)*alpha_m_kml(2)*u_0)/...
    ((w_m(2)^2)*sqrt((1-ny_m(2)^2)^2+((2*r_a*ny_m(2))/(w_m(2)*my))^2)));

egen_3 = ((X_m_3*k_ml(3)*alpha_m_kml(3)*u_0)/...
    ((w_m(3)^2)*sqrt((1-ny_m(3)^2)^2+((2*r_a*ny_m(3))/(w_m(3)*my))^2)));

egen_4 = ((X_m_4*k_ml(4)*alpha_m_kml(4)*u_0)/...
    ((w_m(4)^2)*sqrt((1-ny_m(4)^2)^2+((2*r_a*ny_m(4))/(w_m(4)*my))^2)));

egen_5 = ((X_m_5*k_ml(5)*alpha_m_kml(5)*u_0)/...
    ((w_m(5)^2)*sqrt((1-ny_m(5)^2)^2+((2*r_a*ny_m(5))/(w_m(5)*my))^2)));

epsilon_1_n = -((4*m_piezo)/((l^2)*my))*(egen_1);
epsilon_1_p = ((4*m_piezo)/((l^2)*my))*(egen_1);
epsilon_1 = ((4*m_piezo)/((l^2)*my))*(egen_1).*cos(ex_freq*(x*1000));
epsilon_1_l = ((4*m_piezo)/((l^2)*my))*(egen_1_l);

%% 7.98

h_i_o = zeros(size(h_i));
h_i_u = zeros(size(h_i));

for n = 1:length(h_i)
    h_i_o(n) = z_streck - sum(h_i(1:n));
    h_i_u(n) = z_streck - sum(h_i(1:n-1));
end

Y = 1/(-sum((w_i.*d_31).*abs(h_i_o.^2-h_i_u.^2)./(2*s_11.*h_i))); %TODO: Eget p�hitt med absolutbeloppet!!!!!!!!!!!!!!!!

%% 9.28

n_0 = (l^3)/C; %7.40

n_m = (4*n_0)./((k_ml).^4);

%% 9.31

r_star = r/4;

Q_m = 1./(w_m.*n_m.*r_star);
%Q_m = 1./((r*l./(k_ml).^2)*sqrt(1/(C*my))); %ger samma

%% 9.33

freq_Hz = 20:20000;
modes=3;

epsilon_u_piezo = zeros(size(freq_Hz));

for w = freq_Hz;
    epsilon_u_piezo(w) = (1/Y)*sum(((n_m(1:modes).*X_m(1:modes).*X_m_d(1:modes)).*(1-((w*2*pi)./w_m(1:modes)).^2+1i.*((w*2*pi)./w_m(1:modes)).*(1./Q_m(1:modes))))./...
        (((1-((w*2*pi)./w_m(1:modes)).^2).^2)+(((w*2*pi)./w_m(1:modes)).*(1./Q_m(1:modes))).^2));
end

%% 9.27
m_star = m/4;

epsilon_u_piezo_2 = zeros(size(freq_Hz));

for w = freq_Hz; 
    epsilon_u_piezo_2(w) = (1/(1j*(w*2*pi)*Y))*sum((X_m(1:2).*X_m_d(1:2))./((1./(1j*(w*2*pi).*n_m(1:2)))+(1j*(w*2*pi)*m_star)*r_star));
end

%% B1

punkter_y = [20,20,19,17,5,0,-5];
punkter_x = [20,100,400,1000,4000,6000,8000];

%figure(20)
%semilogx(punkter_x,punkter_y)

B_1 = polyval(polyfit(punkter_x,punkter_y,2),1:20000);                          %TODO: m�ste �ndras, v�rdet f�r boken
%hold on;
%semilogx(B_1)
%hold off;


%% 9.34

%B_1 = 20;

B_3 = 5*10^3;                                                                   %TODO: m�ste �ndras, v�rdet f�r boken

%B_0 = B_1 + 20*log10(abs(B_3*epsilon_u_piezo));
B_0 = -60 + 20*log10(abs(B_3*epsilon_u_piezo));

%% plots
% figure(6)
% semilogx(B_0);

% figure(1)
%subplot(1,2,1)
%plot((x*1000),epsilon_1)
%plot(epsilon_1_l(1:10000))
%  hold on
%  plot(epsilon_1_n)
%  plot(epsilon_1_p)
%subplot(1,2,2)
%plot(abs(fft(epsilon_1)));

epsilon_2_n = -((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2);
epsilon_2_p = ((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2);
epsilon_2 = ((4*m_piezo)/((l^2)*my))*(egen_2).*cos(ex_freq*(x*1000));
epsilon_2_l = ((4*m_piezo)/((l^2)*my))*(egen_2_l);

%figure(2)
%plot((x*1000),epsilon_2)
%semilogy(epsilon_2_l)
%hold on
%plot(epsilon_2_n)
%plot(epsilon_2_p)

supervector = ((4*m_piezo)/((l^2)*my))*(egen_1_l+egen_2_l+egen_3_l+egen_4_l+egen_5_l);
supervector_2 = -((4*m_piezo)/((l^2)*my))*(egen_1_l+egen_2_l+egen_3_l+egen_4_l+egen_5_l);
% figure(8)
% plot(supervector)
% figure(9)
% semilogx(mag2db(supervector))


% epsilon_3_n = -((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2 + egen_3);
% epsilon_3_p = ((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2 + egen_3);
% epsilon_3 = ((4*m_piezo)/((l^2)*my))*(egen_3).*cos(ex_freq*(x*1000));
% 
%  figure(3)
% % %plot((x*1000),epsilon_3)
%  hold on
%  plot((x*1000),epsilon_3_n)
%  plot((x*1000),epsilon_3_p)
% 
% 
% epsilon_4_n = -((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2 + egen_3 + egen_4);
% epsilon_4_p = ((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2 + egen_3 + egen_4);
% epsilon_4 = ((4*m_piezo)/((l^2)*my))*(egen_4).*cos(ex_freq*(x*1000));
% 
% figure(4)
% %plot((x*1000),epsilon_4)
% hold on
% plot((x*1000),epsilon_4_n)
% plot((x*1000),epsilon_4_p)
% 
% 
% epsilon_5_n = -((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2 + egen_3 + egen_4 + egen_5);
% epsilon_5_p = ((4*m_piezo)/((l^2)*my))*(egen_1 + egen_2 + egen_3 + egen_4 + egen_5);
% epsilon_5 = ((4*m_piezo)/((l^2)*my))*(egen_5).*cos(ex_freq*(x*1000));
% 
% figure(5)
% %plot((x*1000),epsilon_5)
% hold on
% plot((x*1000),epsilon_5_n)
% plot((x*1000),epsilon_5_p)

%% Bilder fr�n experiment

load('chirp20_20000Hz.mat')
Fs=44100; % Sample frequency (Hz)

Total_samples = MeasureddataExcersion.Total_Samples;

figure(1)
plot((1:Total_samples)/Fs,MeasureddataExcersion.Data(1:Total_samples)*1e-3)
title('Excursion chirp 20-20000Hz')
xlabel('Seconds')
ylabel('Milimeter')
hold on;
plot((1:Total_samples)/Fs,supervector)
plot((1:Total_samples)/Fs,supervector_2)
hold off;

figure(2)
NFFT = 2^nextpow2(Total_samples); % Next power of 2 from length of y
Y = fft(MeasureddataExcersion.Data(1:Total_samples),NFFT)/Total_samples;
f = Fs/2*linspace(0,1,NFFT/2+1);
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('FFT of chirp 20-20000Hz')
xlabel('Frequency (Hz)')
ylabel('|Input(f)|')

figure(3)
semilogx(B_0)
hold on;
db = mag2db(2*abs(Y(1:NFFT/2+1)));
loglog(f,db) 


