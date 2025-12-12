clear
clc
close all
%% Intro
% This code plots only collaborative rounds


%%
xlsx = '.xlsx';
run = 'run';

versionkey = readtable('VersionKey.xlsx');
team = versionkey(:,2);
team = convertvars(team,'Group','string');
team = table2array(team);
framing = versionkey(:,4);
framing = convertvars(framing,'Framing','string');
framing = table2array(framing);


tstepledger = 0;
indexledger = 0;

figure;
for i = [3,6,8,11,13,18,21,23,26,28,33] %hardcoded for number of files
    num = num2str(i);
    name = append(run,num);
    filename = append(name,xlsx);
    T = readtable(filename);
    T = table2array(T);
    tsteps = T(:,15).*86400;
    tsteps = tsteps(2:end);
    index = 1:1:length(tsteps);

    maxindex(i) = max(index);

    tstepledger = [tstepledger; tsteps];
    indexledger = [indexledger index];
    drawnow
    plot(index,tsteps,'.k')
    hold on

    ylabel('Time [s]')
    xlabel('Design Iterations')

    title('Adversarial w/Siloing Design Space Exploration Iteration Times')

    fontname('Arial')
end

xfit = 1:1:max(indexledger);
coeffs = polyfit(indexledger,tstepledger,1);
yfit = coeffs(1).*xfit + coeffs(2);
plot(xfit,yfit,'-b')

saveas(gcf,'advsilo.fig')
saveas(gcf,'advsilo.png')


%%
tavg = mean(tstepledger);
maxindex = nonzeros(maxindex);
numsteps = mean(maxindex);
timegain = coeffs(1);
timestddev = std(tstepledger);
results = [tavg numsteps timegain timestddev];

writematrix(results,'results.csv')
%%
