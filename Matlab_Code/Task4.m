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
                
                
                if  round(tlastchoose) == t_choose
                    
                    pasos_bajada = pasos_bajada + 1;
                    
                    if round(tlastmod) >= tmod
                        % Si las tres siguientes no dan problema
                        pos = find(modcod(:,2) <= CN(t) == 1);
                        
                        % Si no hay que cambiar la modulación en los
                        % siguientes tres pasos se mantiene 
                        if modcod(pos(1),2) == Pase(a).MC{p}(t-1) &&...
                                Pase(a).MC{p}(t-1) <= Pase(a).CN{p}(t+t_choose-1) &&...
                                Pase(a).MC{p}(t-1) <= Pase(a).CN{p}(t+2*t_choose-1) && ...
                                Pase(a).MC{p}(t-1) <= Pase(a).CN{p}(t+3*t_choose-1)
                            Pase(a).MC{p}(t:t+3*t_choose-1) = Pase(a).MC{p}(t-1);
                            Pase(a).MCef{p}(t:t+3*t_choose-1) = Pase(a).MCef{p}(t-1);                
                            t = t+3*t_choose-1;
                        else
                            Pase(a).MC{p}(t) = modcod(pos(1),2);
                            Pase(a).MCef{p}(t) = modcod(pos(1),3);
                            tlastmod = 0;
                        end
                        
                    elseif round(tlastmod) < tmod
                        if modcod(pos(1),2) == Pase(a).MC{p}(t-1) &&...
                                Pase(a).MC{p}(t-1) <= Pase(a).CN{p}(t+t_choose-1) &&...
                                Pase(a).MC{p}(t-1) <= Pase(a).CN{p}(t+2*t_choose-1) && ...
                                Pase(a).MC{p}(t-1) <= Pase(a).CN{p}(t+3*t_choose-1)
                            Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                            Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                            
                        end
                    end
                end
                
                if round(tlastchoose) == t_choose
                    tlastchoose = 0;
                end
                
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
