clc
clear all
close all

%% LEER DATOS

filename = 'Elevation.xlsx';
xlRange = 'A2:D2';
sheets = [1,2,3];
names = {'10 deg', '20 deg', '30 deg'};

%% ELEVATION 

Elevation = struct();

for s = 1:length(sheets)
    [data,txtdata] = xlsread(filename,sheets(s));
    
    Elevation(s).Name = names{s};
    Elevation(s).t = datetime(txtdata(2:end,1),'InputFormat','dd MMM yyyy HH:mm:ss,SSS'); 
    Elevation(s).azimuth = data(:,1);
    Elevation(s).elevation = data(:,2);
    Elevation(s).range = data(:,3);   
    
end

%% PLOT

rep = 'n';
if rep == 'y'
    
    % All
    figure(1)
    hold on
    for s = 1:length(sheets)
        plot(Elevation(s).t , Elevation(s).azimuth,  'DisplayName', ['Azimuth ', Elevation(s).Name])
        plot(Elevation(s).t , Elevation(s).elevation,  'DisplayName', ['Elevation ', Elevation(s).Name])
        plot(Elevation(s).t , Elevation(s).range,  'DisplayName', ['Range ', Elevation(s).Name])           
    end
    legend('Location','bestoutside')
    grid on; box on;
    
    % Azimuth
    figure(2)
    hold on
    for s = 1:length(sheets)
        plot(Elevation(s).t , Elevation(s).azimuth,  'DisplayName', ['Azimuth ', Elevation(s).Name])
    end
    legend('Location','bestoutside')
    grid on; box on;
    
    %Elevation
    figure(3)
    hold on
    for s = 1:length(sheets)
       plot(Elevation(s).t , Elevation(s).elevation,  'DisplayName', ['Elevation ', Elevation(s).Name])
    end
    legend('Location','bestoutside')
    grid on; box on;
    
    % Range
    figure(4)
    hold on
    for s = 1:length(sheets)
       plot(Elevation(s).t , Elevation(s).range,  'DisplayName', ['Range ', Elevation(s).Name])           
    end
    legend('Location','bestoutside')
    grid on; box on;
    
end