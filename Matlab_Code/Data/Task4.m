clc
clear all
close all


load('MODCOD.mat')
load('Pase_CN.mat')

CN = 10*sin(linspace(0,pi,101))+2;

idx = zeros(length(modcod),size(CN,2));
mod = zeros(size(CN));

for i = 2:length(modcod)-1
    
    idx(i,:) = modcod(i,2) < CN & modcod(i+1,2) >= CN;
    mod(idx(i,:)==1) = modcod(i,1);
    
    
    
end
