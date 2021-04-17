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
    data = xlsread(filename,sheets(s));
    
    Elevation(s).Name = names{s};
    %Elevation(s).t = data(:,1); % No se como hacer para que coja esta
    %columna
    Elevation(s).azimuth = data(:,1);
    Elevation(s).elevation = data(:,2);
    Elevation(s).range = data(:,3);
end