clc
clear all
close all

%% LEER DATOS

filename = 'Elevation.xlsx';
xlRange = 'A2:D2';
sheets = [1,2,3];
names = {'10 deg', '20 deg', '30 deg'};
angulo = [10, 20, 30];

%% ELEVATION 

Angulos = struct();

for s = 1:length(sheets)
    [data,txtdata] = xlsread(filename,sheets(s));
    
    Angulos(s).Name = names{s};
    Angulos(s).t = datetime(txtdata(2:end,1),'InputFormat','dd MMM yyyy HH:mm:ss,SSS'); 
    %Angulos(s).t_num = datenum(string(Angulos(s).t), 'dd-mmm-yyyy HH:MM:SS');
    Angulos(s).azimuth = data(:,1);
    Angulos(s).elevation = data(:,2);
    Angulos(s).range = data(:,3);  
    
    % Filtrar angulos de elevacion por encima de la especificación
    %{
    idx = Angulos(s).azimuth > angulo(s);
    Angulos(s).t(idx) = [];
    Angulos(s).azimuth(idx) = [];
    Angulos(s).elevation(idx) = [];
    Angulos(s).range(idx) = [];
    %}
    
    
    
end

save('Angulos.mat', 'Angulos')

%% PLOT

rep = 'y';
if rep == 'y'
    
    % All
    figure(1)
    hold on
    for s = 1:length(sheets)
        plot(Angulos(s).t , Angulos(s).azimuth,  'DisplayName', ['Azimuth ', Angulos(s).Name])
        plot(Angulos(s).t , Angulos(s).elevation,  'DisplayName', ['Elevation ', Angulos(s).Name])
        plot(Angulos(s).t , Angulos(s).range,  'DisplayName', ['Range ', Angulos(s).Name])           
    end
    legend('Location','bestoutside')
    grid on; box on;
    
    % Azimuth
    figure(2)
    hold on
    for s = 1:length(sheets)
        plot(Angulos(s).t , Angulos(s).azimuth,  'DisplayName', ['Azimuth ', Angulos(s).Name])
    end
    legend('Location','bestoutside')
    grid on; box on;
    
    %Elevation
    figure(3)
    hold on
    for s = 1:length(sheets)
       plot(Angulos(s).t , Angulos(s).elevation,  'DisplayName', ['Elevation ', Angulos(s).Name])
    end
    legend('Location','bestoutside')
    grid on; box on;
    
    % Range
    figure(4)
    hold on
    for s = 1:length(sheets)
       plot(Angulos(s).t , Angulos(s).range,  'DisplayName', ['Range ', Angulos(s).Name])           
    end
    legend('Location','bestoutside')
    grid on; box on;
    
end

%% ACCESOS

filename = 'Access.xlsx';
xlRange = 'A2:D2';
sheets = [1,2,3];
names = {'10 deg', '20 deg', '30 deg'};
angulo = [10, 20, 30];

for s = 1:length(sheets)
    [data,txtdata] = xlsread(filename,sheets(s));
    
    Access(s).Name = names{s};
    Access(s).start = datetime(txtdata(2:end,1),'InputFormat','dd MMM yyyy HH:mm:ss,SSS'); 
    Access(s).end = datetime(txtdata(3:end,1),'InputFormat','dd MMM yyyy HH:mm:ss,SSS'); 
    Access(s).num = data(:,1);
    Access(s).duration = data(:,4)/60;
    Access(s).average = 0;
    
    % Average duration
    for i = 1:length(Access(s).num)
        Access(s).average = Access(s).average + Access(s).duration(i);
    end
    Access(s).average = Access(s).average/length(Access(s).duration);
    
end

save('Access.mat', 'Access')
