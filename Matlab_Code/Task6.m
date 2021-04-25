clc
clear 
close all

load('Data/Pase_CN_1s.mat')


%% NUMERO DE IMAGENES Y PESO

R = 6371e3;                                                                % [m]
l = pi*R;
bandas = 1;
Nfotos = l/300/bandas;

datos = 18.5e3;

f_raw = datos/Nfotos;
comp_rate = 0.8;
f_comp = f_raw*comp_rate;


%% NUMERO DE IMÁGENES

for a = 1:length(Pase)
    Pase(a).D.Download_raw = Pase(a).D.media_Pase/f_raw;
    Pase(a).D.Download_comp = Pase(a).D.media_Pase/f_comp;
end