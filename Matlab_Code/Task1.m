%%%%%%%%%%% T A S K    1 %%%%%%%%%%%%%%
clear all
clc
%% LEER DATOS del EXCEL

filename = 'Data/Access_1s.xlsx';
xlRange = 'A2:D2';
sheets = [1,2,3];
names = {'10 deg', '20 deg', '30 deg'};
angulo = [10, 20, 30];
Range = struct();

for s = 1:length(sheets)
    [data,txtdata] = xlsread(filename,sheets(s));
    
    Range(s).Name = names{s};
    Range(s).t = datetime(txtdata(2:end,1),'InputFormat','dd MMM yyyy HH:mm:ss,SSS'); 
    Range(s).km = data(:,3);
end