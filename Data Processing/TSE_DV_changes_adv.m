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


iterledger = [];
indexledger = [];
numledger = [];

for i = [2,5,7,10,14,17,20,22,25,29,32] %hardcoded for number of files
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
    
    indexledger = [indexledger a];
    iterledger = [iterledger; iteravg_non0];
    numledger = [numledger; numchanged_non0];
end

figure;
plot(indexledger,iterledger,'.k')
hold on
coeffs = polyfit(indexledger,iterledger,1);
xfit = 1:1:max(indexledger);
yfit = coeffs(1).*xfit + coeffs(2);
plot(xfit,yfit,'-b')
xlabel('Design Iteration')
ylabel('Percent Change in Design Variables')
title('Adversarial Design Rounds')
axis([0, 1.1*max(indexledger), 0, 1.1*max(iterledger)])
saveas(gcf,'percentchangeadv.fig')
saveas(gcf,'percentchangeadv.png')


itergain = coeffs(1);

figure;
plot(indexledger,numledger,'.k')
hold on
coeffs = polyfit(indexledger,numledger,1);
xfit = 1:1:max(indexledger);
yfit = coeffs(1).*xfit + coeffs(2);
plot(xfit,yfit,'-b')
xlabel('Design Iteration')
ylabel('Number of Design Variables Changed')
title('Adversarial Design Rounds')
axis([0, 1.1*max(indexledger), 0, 1.1*max(numledger)])
saveas(gcf,'numchangedadv.fig')
saveas(gcf,'numchangedadv.png')

numgain = coeffs(1);

fontname('Arial')

avgiter = mean(iteravg_non0);
avgnumchanged = mean(numchanged_non0);

results = [avgiter, std(iteravg_non0), avgnumchanged, std(numchanged_non0), itergain, numgain]

writematrix(results,'results2.csv')
%%
