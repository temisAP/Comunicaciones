clc
clear all
close all


load('MODCOD.mat')
load('Pase_CN.mat')

CN = Pase(1).CN{Pase(1).max_idx};
idx = zeros(size(CN,1));
%mod = zeros(length(idx),1);

    idx = [modcod(1,1) <= CN]';
    mod(idx==1) = modcod(1,1);
for i = 2:length(modcod)-1
    
    idx = [modcod(i,1) <= CN & modcod(i-1,1) >= CN]';
    mod(idx==1) = modcod(i,1);
    
end

figure()
    hold on
    plot(Pase(1).t{Pase(1).max_idx}, mod)
    plot(Pase(1).t{Pase(1).max_idx}, Pase(1).CN{Pase(1).max_idx})
