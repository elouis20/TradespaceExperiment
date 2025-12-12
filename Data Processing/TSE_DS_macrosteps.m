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

counter = 0;

figure;
for i = [3,6,8,11,13,18,21,23,26,28,33] %hardcoded for number of files
    tsteps = [];
    counter = counter+1;
    num = num2str(i);
    name = append(run,num);
    filename = append(name,xlsx);
    T = readtable(filename);
    T = table2array(T);
    tsteps = T(:,15).*86400;
    tsteps = tsteps(2:end);
    index = 1:1:length(tsteps);

    checksum = [];
    checksumCC = [];
    checksumSD = [];
    dv = [];
    deltadv = [];
    SDindex = [];
    CCindex = [];
    SDtsteps = [];
    CCtsteps = [];


    dv = T(:,4:11); %design variables for each iteration

    a=0;b=0;
    handoff = 0;
    for j = 2:length(tsteps)
        deltadv(j-1,:) = dv(j-1,:) - dv(j,:);
        checksumCC = sum(deltadv(j-1,1:3));
        checksumSD = sum(deltadv(j-1,4:8));
        checksum(j) = abs(checksumCC) - abs(checksumSD);

        if checksum(j) >= 0
            a=a+1;
            CCindex(a) = index(j);
            CCtsteps(a) = tsteps(j);
        else
            b=b+1;
            SDindex(b) = index(j);
            SDtsteps(b) = tsteps(j);
        end

        if checksum(j-1) >= 0 && checksum(j) < 0
            handoff = handoff+1;
        elseif checksum(j-1) < 0 && checksum(j) >= 0
            handoff = handoff+1;
        else
            handoff = handoff;
        end
    end
    
    if checksum(1) + checksum(2) < 0
        handoffcounter(counter) = handoff - 1;
    else
        handoffcounter(counter) = handoff;
    end



    scatter(CCindex,counter*ones(1,length(CCindex)),30,'ob','filled')
    hold on
    scatter(SDindex,counter*ones(1,length(SDindex)),30,'or','filled')
    hold on
    
    labelnum = num2str(handoffcounter(counter));
    textlabel = 'Handoffs: ';
    textlabel = append(textlabel,labelnum);

    text(length(checksum) + 2,counter,textlabel)

    axis([0 85 0 12])

    % figure;
    % plot(index,tsteps,'.k')
    % hold on
    coeffs = polyfit(index,tsteps,1);
    % yfit = coeffs(1).*index + coeffs(2);
    % plot(index,yfit,'-b')
    
    yticks([1:1:11])
    yticklabels({'#954','#1000','#4025','#4075','#5025','#6025','#8051','#8052','#9053','#9055','#9056'})
    ylabel('Group Number')
    xlabel('Design Iterations')

    title('Handoffs Between Working Groups - Siloed Round')
    legend('Chassis and Cabin','Suspension and Driveline')

    fontname('Arial')
    
    
end

saveas(gcf,'Handoff.fig')
saveas(gcf,'Handoff.png')
%%
