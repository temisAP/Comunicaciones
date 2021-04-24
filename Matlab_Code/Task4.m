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
        

        tlastchoose = 0;
        tlastmod = 0;
        
        for t = 2:length(tpase)
          
            if CN(t) > CN(t-1)               
                if tlastchoose == t_choose
                    if tlastmod < t_mod
                        Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                        Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                    else
                        pos = find([modcod(:,2) <= CN(t)]'==1);
                        if modcod(pos(1),2) == Pase(a).MC{p}(t-1)
                            Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                            Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                        else                        
                            Pase(a).MC{p}(t) = modcod(pos(1),2);
                            Pase(a).MCef{p}(t) = modcod(pos(1),3);
                            tlastmod = 0;
                        end
                    end
                    tlastchoose = 0;
                else
                    Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                    Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);

                end
            
            % Bajada
            elseif CN(t) <= CN(t-1)
                try
                    if length(tpase) - t < 30
                        dT = length(tpase) - t;
                    else
                        dT = 30;
                    end
                    if tlastchoose == t_choose
                        % Ya se puede cambiar de modulacion
                        if tlastmod < t_mod
                            % Si no han pasado 30 s no se cambia 
                            Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                            Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                        else
                            pos = find(modcod(:,2) <= CN(t+dT) == 1);
                            if modcod(pos(1),2) == Pase(a).MC{p}(t-1)
                                Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                                Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                            else
                                Pase(a).MC{p}(t) = modcod(pos(1),2);
                                Pase(a).MCef{p}(t) = modcod(pos(1),3);
                                tlastmod = 0;
                            end
                        end
                        tlastchoose = 0;
                    else
                        Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                        Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                    end
                catch

                    
                    
                   
                end

            end
 
            tlastmod = tlastmod + 1;
            tlastchoose = tlastchoose + 1;
        end
    end
end

    
for a = 1:3
    for p = 1:3
        figure()
            hold on
            plot(Pase(a).t{p}, Pase(a).MC{p}, 'LineWidth', 2, 'DisplayName', 'Modulacion')
            plot(Pase(a).t{p}, Pase(a).MCef{p}, 'DisplayName', 'Eficiencia')
            plot(Pase(a).t{p}, Pase(a).CN{p}, 'DisplayName', 'C/N')
            %legend()
            title(['Angulo ' num2str(a) ' Pase ' num2str(p)])
            for i = 1:9
                plot([0:600], modcod(i,2)*ones(1,601),'k')
            end

    end
end

save('Data/Pase_CN_1s.mat', 'Pase')