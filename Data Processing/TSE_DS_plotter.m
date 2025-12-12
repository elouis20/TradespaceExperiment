clear
clc
close all
%%
xlsx = '.xlsx';
fig = '.fig';
png = '.png';
run = 'run';

versionkey = readtable('VersionKey.xlsx');
team = versionkey(:,2);
team = convertvars(team,'Group','string');
team = table2array(team);
framing = versionkey(:,4);
framing = convertvars(framing,'Framing','string');
framing = table2array(framing);

for i = 1:33 %hardcoded for number of files
    num = num2str(i);
    name = append(run,num);
    filename = append(name,xlsx);
    T = readtable(filename);
    T = table2array(T);
    tsteps = T(:,15).*86400;
    tsteps = tsteps(2:end);
    index = 1:1:length(tsteps);
    
    figure;
    plot(index,tsteps,'.k')
    hold on
    coeffs = polyfit(index,tsteps,1);
    yfit = coeffs(1).*index + coeffs(2);
    plot(index,yfit,'-b')

    ylabel('Time [s]')
    xlabel('Design Iterations')

    plotname = append('Group ',team(i),' - ',framing(i));
    title(plotname)

    fontname('Arial')
    
    figname = append(name,fig);
    pngname = append(name,png);
    saveas(gcf,figname)
    saveas(gcf,pngname)
    
    tavg = mean(tsteps);
    numsteps = length(tsteps);
    timegain = coeffs(1);
    timestddev = std(tsteps);
    results(i,:) = [i tavg numsteps timegain timestddev];
end

writematrix(results,'results.csv')
%%
