%%%%%%%%%%% T A S K    2 %%%%%%%%%%%%%%
clc
clear all

load('Data/Access.mat')
h = figure();
    hold on
    for s = 1:length(Access)
    h1 = histogram(Access(s).duration','DisplayName', ['Elevation ', Access(s).Name]);
    end
legend('Location', 'northwest')
axis([0, 12, 0, 500])
ylabel('Number of passes ','Interpreter', 'Latex')
xlabel({'$t$'; '[min]'}, 'Interpreter', 'Latex')
grid on; box on;
%Save_as_PDF(h, 'Figuras/Histograma', 'horizontal');
