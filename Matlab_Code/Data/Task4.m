clc
clear all
close all


load('MODCOD.mat')
load('Pase_CN_1s.mat')


for a = 1:length(Pase)
    for p = 1:length(Pase(a).CN)
        
        % Comienzo de transmision -> CN creciente
        tlastmod = 0;
        tpase = Pase(a).t{p};
        CN = Pase(a).CN{p};
        
        Pase(a).MC{p} = zeros(size(Pase(a).t{p}));% modcod(id,2);
        Pase(a).MCef{p} = zeros(size(Pase(a).t{p}));% modcod(id,3);
        
        pos = find([modcod(:,2) <= CN(1)]'==1);
        Pase(a).MC{p}(1) = modcod(pos(1),2);
        Pase(a).MCef{p}(1) = modcod(pos(1),3);
        tmedios = round(length(tpase)/2);
        
        for t = 2:tmedios
            tlastmod = tlastmod + 1;
            
            if tlastmod < 30
                Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
            else
                pos = find([modcod(:,2) <= CN(t)]'==1);
                Pase(a).MC{p}(t) = modcod(pos(1),2);
                Pase(a).MCef{p}(t) = modcod(pos(1),3);
                tlastmod = 0;
            end
        end
       
        
        % Final de transmision -> CN decreceinte
        max_idx = find([Pase(a).MC{p}(t) <= CN]'==1);
        tbajada = max_idx(end);
        Pase(a).MC{p}(tmedios+1:tbajada) = Pase(a).MC{p}(tmedios);
        Pase(a).MCef{p}(tmedios+1:tbajada) = Pase(a).MCef{p}(tmedios);
                
        % Inicializacion de switches
        sw_salto = 0;
        tlastmod = 0;
        dT = 30;

        for t = tbajada+1:length(tpase)

            tlastmod = tlastmod + 1;
            if sw_salto == 0
                % Salto si llega al limite de modlulacion
                if length(tpase) - t < 30
                    dT = length(tpase) - t;
                else
                    dT = 30;
                end
                tlastmod = 0;
                pos = find(modcod(:,2) <= CN(t+dT) == 1);
                Pase(a).MC{p}(t) = modcod(pos(1),2);
                Pase(a).MCef{p}(t:t) = modcod(pos(1),3);
                sw_salto = 1;

            elseif sw_salto == 1 && tlastmod < dT    
                % han pasado 30 s y todabia puede transmitir con esa mod
                Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);

            else
                % Salta a la siguiente modulacion
                pos = find(modcod(:,2) <= CN(t) == 1);
                if modcod(pos(1),2) == Pase(a).MC{p}(t-1)
                    Pase(a).MC{p}(t) = Pase(a).MC{p}(t-1);
                    Pase(a).MCef{p}(t) = Pase(a).MCef{p}(t-1);
                else             
                    Pase(a).MC{p}(t) = modcod(pos(1),2);
                    Pase(a).MCef{p}(t) = modcod(pos(1),3);
                    sw_salto = 0;
                end
            end
        end
    end
end
    
for a = 1:3
    for p = 1:25:100
        figure()
            hold on
            plot(Pase(a).t{p}, Pase(a).MC{p}, 'DisplayName', 'Modulacion')
            plot(Pase(a).t{p}, Pase(a).MCef{p}, 'DisplayName', 'Eficiencia')
            plot(Pase(a).t{p}, Pase(a).CN{p}, 'DisplayName', 'C/N')
            legend()
            title(['Angulo ' num2str(a) ' Pase ' num2str(p)])
    end
end
