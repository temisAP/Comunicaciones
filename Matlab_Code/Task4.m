clc
clear all
close all


load('Data/MODCOD.mat')
load('Data/Pase_CN_1s.mat')

t_choose = 10;  %s
t_mod    = 30;  %s

for a = 1:length(Pase)
    for p = 1:length(Pase(a).CN)
        
        % Comienzo de transmision -> CN creciente
        tlastmod = 0;
        tlastchoose = 0;
        tpase = Pase(a).t{p};
        DT = tpase(2) - tpase(1);
        CN = Pase(a).CN{p};
        
        Pase(a).MC{p} = zeros(size(Pase(a).t{p}));% modcod(id,2);
        Pase(a).MCef{p} = zeros(size(Pase(a).t{p}));% modcod(id,3);
        
        pos = find([modcod(:,2) <= CN(1)]'==1);
        Pase(a).MC{p}(1) = modcod(pos(1),2);
        Pase(a).MCef{p}(1) = modcod(pos(1),3);
        tmedios = round(length(tpase)/2);
        pasos_bajada = 0;
        
        % Inicializacion de switches
        sw_salto = 0;
        dT = t_mod;
        
        for t = 2:length(tpase)
            
            tlastmod = tlastmod + DT;
            tlastchoose = tlastchoose + DT;
            
            %%% Subida
            if CN(t) > CN(t-1)
                
                if round(tlastmod) < t_mod
                    Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                    Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                elseif round(tlastmod) >= t_mod && round(tlastchoose) == t_choose
                    pos = find([modcod(:,2) <= CN(t)]'==1);
                    if modcod(pos(1),2) == Pase(a).MC{p}(t-1)
                        Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                        Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                    else
                        Pase(a).MC{p}(t) = modcod(pos(1),2);
                        Pase(a).MCef{p}(t) = modcod(pos(1),3);
                        tlastmod = 0;
                    end
                elseif round(tlastmod) >= t_mod && round(tlastchoose) ~= t_choose
                    %disp(['No has considerado lo que pasa en t=',num2str(t),' tlastmod =', num2str(tlastmod), 'tlastchoose =', num2str(tlastchoose)])
                    Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                    Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                end
            end
            
            
            %%% Bajada
            if CN(t) < CN(t-1)
                
                pasos_bajada = pasos_bajada + 1;
                
                if sw_salto == 0 
                    % Salto si llega al limite de modulacion
                    if length(tpase) - t < t_mod
                        dT = length(tpase) - t;
                    else
                        dT = t_mod;
                    end
                    tlastmod = 0;
                    pos = find(modcod(:,2) <= CN(t+dT) == 1);
                    Pase(a).MC{p}(t) = modcod(pos(1),2);
                    Pase(a).MCef{p}(t:t) = modcod(pos(1),3);
                    nextmod = modcod(pos(2),2);
                    nexteff = modcod(pos(2),3);
                    sw_salto = 1;
                                       
                elseif sw_salto == 1 && round(tlastmod) < dT
                    % han pasado 30 s y todavia puede transmitir con esa mod
                    Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                    Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                    
                elseif round(tlastmod) >= dT && round(tlastchoose) == t_choose 
                    % Salta a la siguiente modulacion
                    pos = find(modcod(:,2) <= CN(t) == 1);
                    if modcod(pos(1),2) == Pase(a).MC{p}(t-1)
                        Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                        Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                    else
                        Pase(a).MC{p}(t) = modcod(pos(1),2);
                        Pase(a).MCef{p}(t) = modcod(pos(1),3);
                        % Si en el paso anterior se había pasado hay que
                        % reescribir
                        if Pase(a).MC{p}(t-1) > Pase(a).CN{p}(t-1)
                            
                            n_escalones = 1;
                            if Pase(a).MC{p}(t-1) == Pase(a).CN{p}(t-1-t_choose)
                                n_escalones = 2;
                            end
                            if Pase(a).MC{p}(t-1) == Pase(a).CN{p}(t-1-2*t_choose)
                                n_escalones = 3;
                            end
                        
                            Pase(a).MC{p}(t-n_escalones*t_choose:t) = Pase(a).MC{p}(t);
                            Pase(a).MCef{p}(t-n_escalones*t_choose:t) = Pase(a).MCef{p}(t);
                        end
                        sw_salto = 0;
                    end
                elseif round(tlastmod) >= dT && round(tlastchoose) ~= t_choose
                    % han pasado 30 s pero todavia no se puede cambiar 
                    Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                    Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                    
                end
        
            end
            
            if round(tlastchoose) == t_choose
                tlastchoose = 0;
            end
            
        end
        
    end
end

for a = 1:1
    for p = 1:3
        figure()
        hold on
        plot(Pase(a).t{p}, Pase(a).MC{p}, 'DisplayName', 'Modulacion')
        plot(Pase(a).t{p}, Pase(a).MCef{p}, 'DisplayName', 'Eficiencia')
        plot(Pase(a).t{p}, Pase(a).CN{p}, 'DisplayName', 'C/N')
        legend()
        title(['Angulo ' num2str(a) ' Pase ' num2str(p)])
    end
end

save('Data/Pase_CN_1s.mat', 'Pase')