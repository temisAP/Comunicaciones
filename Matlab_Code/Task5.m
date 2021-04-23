clc
clear 
close all

load('Data/MODCOD.mat')
load('Data/Pase_CN_1s.mat')

B = 300e6;                                                                 % Bandwidth [MHz]  
for a = 1:length(Pase)
    for p = 1:length(Pase(a).t)
        % Intervalo de tiempo de 1 s
        Pase(a).D.total_Pase(p) = sum( B*Pase(a).MCef{p}/8);               % [Mbits]
    end
    Pase(a).D.media_Pase = mean( Pase(a).D.total_Pase);                    % [Mbits]
    Pase(a).D.total = sum(  Pase(a).D.total_Pase );                        % [Mbits]
end