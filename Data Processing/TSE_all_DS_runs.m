clear
clc
close all
%% Intro
% This code plots each round of each group's design space iteration time
% individually and outputs a .csv with data for each group and round


%%
xlsx = '.xlsx';
fig = '.fig';
png = '.png';
run = 'run';

dvrange = [100
            100
            20
            18
            350
            4
            20
            850]';


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

    dv = [];
    deltadv = [];
    itersum = [];
    numchanged = [];
    iteravg = [];

    dv = T(:,4:11); %design variables for each iteration
    for j = 2:size(dv,1)
        deltadv(j-1,:) = dv(j-1,:) - dv(j,:);
        %change in design variables between iterations
        deltadv(j-1,:) = abs(deltadv(j-1,:)./dvrange);
        %normalizing change in design variable using design variable upper
        %and lower bounds - essentially a percent change

        %next bit of code finds the average change in design variables
        %considering ONLY the non-zero dv changes. 
        itersum(j) = sum(deltadv(j-1,:));
        %sum of all design variable percent changes
        numchanged(j) = length(nonzeros(deltadv(j-1,:)));
        %number of design variables changed on the current iteration
        iteravg(j) = itersum(j)/numchanged(j);
        %percent change vs number of changed design variables - this
        %ignores the unchanged design variable. We are interested in both
        %how many design variables a group changes per iteration, on
        %average. We are also interested in, if a design variable IS
        %changed, how much is it changed, on average
        if isnan(iteravg(j))
            %if no design variables (of the 8 we check) are changed, the
            %iteration average throws a NaN -> we just make it go away by
            %calling it zero...
            iteravg(j) = 0;
        end
    end

    iteravg_non0 = nonzeros(iteravg);
    numchanged_non0 = nonzeros(numchanged);
    %These two vectors are used for plotting. They have each iteration's
    %avg number of design variables changed and the average percent change
    %of each design variable
 
    avgnumchanged(i) = mean(nonzeros(numchanged));
    avgchange(i) = mean(nonzeros(deltadv));
    %these two vectors have each design round's (aggregate of all
    %iterations) avg number of design variables changed and avg percent
    %change in those design variables
    
    a = 1:1:length(iteravg_non0);
    %index for plotting and fitting

    % This chunk of code plots the average percent change in design
    % variables per iteration
    %---------------------------------------------
    figure;
    plot(a,iteravg_non0,'.k')
    axis([0 max(a) 0 1.1*max(iteravg_non0)])
    hold on
    coeffs = polyfit(a,iteravg_non0,1);
    iteravggain = coeffs(1);
    yfit = coeffs(1).*a + coeffs(2);
    plot(a,yfit,'-b')
    xlabel('Design Iteration')
    ylabel('Percent Change in Design Variables')
    plotname = append('Group ',team(i),' - ',framing(i));
    title(plotname)

    percentchange = 'percentchange';
    filename = append(name,percentchange,fig);
    saveas(gcf,filename)

    filename = append(name,percentchange,png);
    saveas(gcf,filename)

    %---------------------------------------------


    % This chunk of code plots the average number of design variables
    % changed per iteration
    %-----------------------------------------------
    figure;
    plot(a,numchanged_non0,'.k')
    axis([0 max(a) 0 1.1*max(numchanged_non0)])
    hold on
    coeffs = polyfit(a,numchanged_non0,1);
    numchangedgain = coeffs(1);
    yfit = coeffs(1).*a + coeffs(2);
    plot(a,yfit,'-b')
    xlabel('Design Iteration')
    ylabel('Number of Design Variables Changed')
    plotname = append('Group ',team(i),' - ',framing(i));
    title(plotname)

    numchanged = 'numchanged';
    filename = append(name,numchanged,fig);
    saveas(gcf,filename)

    filename = append(name,numchanged,png);
    saveas(gcf,filename)

    %------------------------------------------------

    

    %Uncomment the chunk of code below to plot time per iteration plots but
    %NOT save them. We already plotted and saved as of 12/11/2025
    %--------------------------------------------

    % figure;
    % plot(index,tsteps,'.k')
    % hold on
    % coeffs = polyfit(index,tsteps,1);
    % yfit = coeffs(1).*index + coeffs(2);
    % plot(index,yfit,'-b')
    % 
    % ylabel('Time [s]')
    % xlabel('Design Iterations')
    % 
    % plotname = append('Group ',team(i),' - ',framing(i));
    % title(plotname)
    % 
    % fontname('Arial')
    %
    %--------------------------------------------------
    

    % Uncomment the chunk below to time per iteration plots too - this will
    % save 33 files to whatever working folder you're in, beware
    %-------------------------
    % figname = append(name,fig);
    % pngname = append(name,png);
    % saveas(gcf,figname)
    % saveas(gcf,pngname)
    %-------------------------
    
    tavg = mean(tsteps);
    numsteps = length(tsteps);
    timegain = coeffs(1);
    timestddev = std(tsteps);
    results(i,:) = [i tavg numsteps timegain timestddev avgnumchanged(i) avgchange(i) iteravggain numchangedgain];
end

%writematrix(results,'results.csv')
%%
