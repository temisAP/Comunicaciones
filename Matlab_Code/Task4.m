clc
clear all
close all


load('Data/MODCOD.mat')
load('Data/Pase_CN_1s.mat')

modcod = zeros(length(MODCOD),3);
for i = 1:length(MODCOD)
modcod(i,1) = MODCOD(i).Index;
modcod(i,2) = MODCOD(i).CN;
modcod(i,3) = MODCOD(i).Efficiency;
end

t_choose = 10;  %s
t_mod    = 30;  %s

%% Cálculo

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

%% Plot    

for a = 1:3
    for p = 1:3
        figure()
            hold on
            plt(1) = stairs(Pase(a).t{p}, Pase(a).MC{p}, 'LineWidth', 1.2, 'DisplayName', 'Modulacion [dB]');
            plt(2) = stairs(Pase(a).t{p}, Pase(a).MCef{p}, 'DisplayName', 'Eficiencia [bps/Hz]');
            plt(3) = stairs(Pase(a).t{p}, Pase(a).CN{p}, 'DisplayName', 'C/N [dB]');
            for i = 1:9
                plot([0:length(Pase(a).t{p})], modcod(i,2)*ones(1,length(Pase(a).t{p})+1),'--', 'LineWidth', 0.5, 'Color','k')
            end
            f = get(gca,'Children');
            legend([plt(1:3)])
            xlabel('Tiempo [s]')
            title(['Angulo ' num2str(a) ' Pase ' num2str(p)])

    end
end

%% Table

for a = 1:length(Pase)
    
    clear tables
    for p = 1:length(Pase(a).CN)
        
        tpase = length(Pase(a).t{p});
        
        for idx = 1:length(MODCOD)           
            fnd = find(Pase(a).MC{p} == MODCOD(idx).CN);
            duraciones(idx) = length(fnd);
            porcentajes(idx) = duraciones(idx)/tpase * 100;
        end
              
     tables{p} = struct('Modulacion',{MODCOD(:).Label},'Duracion',num2cell(duraciones),'Porcentaje',num2cell(porcentajes));

    end
    
    Pase(a).MODCOD_table = {tables{:}};
    
end

%%

for a = 1:length(Pase)
        
end
     
save('Data/Pase_CN_1s.mat', 'Pase')