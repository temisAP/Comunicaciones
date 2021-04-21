clc
clear all
close all


load('MODCOD.mat')
load('Pase_CN.mat')

CN = Pase(1).CN{Pase(1).max_idx};
idx = zeros(size(CN,1));
%mod = zeros(length(idx),1);

    idx = [modcod(1,1) <= CN]';
    mod(idx==1) = modcod(1,1);
for i = 2:length(modcod)-1
    
    idx = [modcod(i,1) <= CN & modcod(i-1,1) >= CN]';
    mod(idx==1) = modcod(i,1);
    
end

Pase(1).MC{1} = mod;

% Comprobar que los saltos se efectúan cada 30 segundos

DT_min = 30; % s
DT_CN = 0; % Inicializando tiempo desde el último salto

for p=1:length(Pase)                    % Para cada pase y
    for q=1:length(Pase(p).t)           % Para cada grupo     
        tiempos = Pase(p).t{q};         % Coge los tiempos
        MC = Pase(p).MC{q};             % Coge la codificaciones
        
        for t = 2:lenght(tiempos)           % Recórrelos 
            DT = tiempos(t)-tiempos(t-1);   % Calcula el salto de tiempo de este paso
            DT_CN = DT_CN + DT;             % Tiempo desde el último salto de codificación           
            if DT_CN >= DT_min && MC(t) ~=  MC(t-1)         % Si en un tiempo mayor a DT_min hay un cambio de codificación
                DT_CN = 0;                                  % Resetea el tiempo
            elseif DT_CN >= DT_min && MC(t) ~=  MC(t-1)     % Si en un tiempo menor a DT_min hay un cambio de codificación
                Pase(p).MC{q}(t) = Pase(p).MC{q}(t-1);      % Cambia la codificación mayor de las dos
            end            
        end
        
    end
end

figure()
    hold on
    plot(Pase(1).t{Pase(1).max_idx}, mod)
    plot(Pase(1).t{Pase(1).max_idx}, Pase(1).CN{Pase(1).max_idx})
