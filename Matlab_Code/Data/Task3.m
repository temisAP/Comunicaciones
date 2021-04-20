%%%%%%%%%%% T A S K    3 %%%%%%%%%%%%%%
clear all
clc

%% Constantes
c = 3e8;            % [m/s] Speed light
k = 1.38064852e-23; % [m2kg/s2K] 

%% Data
D_antenna = 5;      % [m]
T_antenna = 40;     % [K]
rend_antenna = 0.6; % [-] Antenna efficiency
B = 300e6;          % [Hz] Bandwidth 
f = 10e9;           % [Hz] X band frequency
NF = 2;             % [dB] Receiver noise figure
T0 = 290;           % [K] 
EIRP = 22;          % [dBW]
La = 3;             % [dB] Losses due to gas abps, rain attenuation... 
load('Angulos.mat');
load('Access.mat');


%% Antenna gain
lambda = c/f;
G = 10*log10(rend_antenna*(pi*D_antenna/lambda)^2);


%% Noise temperature of receiver
T_receiver = T_antenna + T0*(10^(NF/10)-1); % [K]


%% G/T ground station
GT = G - 10*log10(T_receiver);              % [dB]


%% Free space losses during the pass each 10 seconds

for s = 1:length(Angulos)
    for i = 1:length(Angulos(s).range)
        R = Angulos(s).range(i)*1000;
        Lp(i,s) = 20*log10(4*pi*R/lambda);
    end
end


%% C/N of the link

for s = 1:length(Angulos)
    for i = 1:length(Angulos(s).range)
        CN(i,s) = EIRP + GT - Lp(i,s) - La - 10*log10(k) - 10*log10(B);
    end
end

%% PLOTS
time = [0:10:Access(1).duration(1)*60];
for s = 1:length(Access)
    h = figure(s);
    hold on
    [hAx,hLine1,hLine2] = plotyy(Angulos(s).t_num(1:Angulos(s).indice(1)) , ...
        Angulos(s).range(1:Angulos(s).indice(1)), ...
        Angulos(s).t_num(1:Angulos(s).indice(1)), CN((1:Angulos(s).indice(1)),s));
    xlabel('Tiempo de ')
    ylabel(hAx(1),'Range [km]') % left y-axis
    ylabel(hAx(2),'C/N [dB]') % right y-axis
    grid on; box on;
end



% PLOT 60 dias
% h = figure();
% hold on
% for s = 1:1
%     [hAx,hLine1,hLine2] = plotyy(Angulos(s).t , Angulos(s).range, Angulos(s).t, CN(:,s));
% end
% xlabel('UTC Time')
% ylabel(hAx(1),'Range [km]') % left y-axis
% ylabel(hAx(2),'C/N [dB]') % right y-axis
% grid on; box on;