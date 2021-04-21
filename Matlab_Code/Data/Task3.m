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
load('Pase_1s.mat');
load('MODCOD.mat');



%% CN CALCULATION

% Antenna gain
lambda = c/f;
G = 10*log10(rend_antenna*(pi*D_antenna/lambda)^2);

% Noise temperature of receiver
T_receiver = T_antenna + T0*(10^(NF/10)-1); % [K]

% G/T ground station
GT = G - 10*log10(T_receiver);              % [dB]


% C/N of the link

for s = 1:length(Pase)
    % Free space losses during the pass each 10 seconds
    for i = 1:length(Pase(s).range)
        R = Pase(s).range{i}*1000;
        Lp = 20*log10(4*pi*R/lambda);
        Pase(s).CN{i} = EIRP + GT - Lp - La - 10*log10(k) - 10*log10(B);
    end
end

%% PLOTS

for s = 1:length(Access)
    h = figure(s);
    hold on
    [hAx,hLine1,hLine2] = plotyy(Pase(s).t{Pase(s).max_idx}, ...
        Pase(s).range{Pase(s).max_idx}, ...
        Pase(s).t{Pase(s).max_idx}, Pase(s).CN{Pase(s).max_idx});
    xlabel('Tiempo de ')
    ylabel(hAx(1),'Range [km]') % left y-axis
    ylabel(hAx(2),'C/N [dB]') % right y-axis
    grid on; box on;
end

save('Pase_CN_1s.mat','Pase');

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