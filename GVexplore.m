clear
clc
close all

%This code generates the plots and vehicle indices used in the performance
%space analysis portion of the design experiment. Twenty solutions are
%generated from sampling the input space, and plotted in bi-objective
%performance space plots. The vehicle index contains the inputs for each of
%the twenty solutions. To improve the intelligibility and usefulness of the
%vehicle index in analyzing solutions, each input variable is categorized 
% into 5 bins - for example, a vehicle whose torque output is at or near
% the upper bound is classified as being "Very High Output." This allows
% the user to more easily identify what inputs their selected solution is
% composed of, rather than having to interpret the numeric values of the
% inputs.

%% Inputs
n = 20; %number of solutions to generate
n = n/2; %divide by half because i generate two triangular dists and smush them together
twbounds = [100 200];
wbbounds = [80 100];
rhbounds = [65 85];
susptravelbounds = [6 24];
maxtorquebounds = [400 750];
gearingbounds = [2 6];
tirediambounds = [30 50];
energycapbounds = [850 1700];
framerailbounds = [0.25 1];
bodypanelbounds = [0.125 2];

b = [twbounds; wbbounds; rhbounds; susptravelbounds; maxtorquebounds;...
    gearingbounds; tirediambounds; energycapbounds; framerailbounds;...
    bodypanelbounds];


r = 0.2*(b(:,2) - b(:,1));
%Each input space is chopped up into 5 categories using this "r" interval

%% Sampling inputs

%Since each objective is a linear min-max problem, sampling from uniform
%distributions creates a lot of "mediocre" solutions. For the sake of
%generating plots that have some very good and very bad solutions with a
%small number of samples (these plots display n = 20 solutions), it is
%better to sample more heavily near the upper and lower bounds of each
%input. Two right-triangular distributions are used, one with mode at the
%lower bound, one with mode at upper. Samples are taken from the combined 
% M-shaped distribution

twlower = makedist('Triangular','a',twbounds(1),'b',twbounds(1),'c',0.5*sum(twbounds));
twupper = makedist('Triangular','a',0.5*sum(twbounds),'b',twbounds(2),'c',twbounds(2));
tw = [random(twlower,n,1); random(twupper,n,1)];
tw = tw(randperm(length(tw)));

wblower = makedist('Triangular','a',wbbounds(1),'b',wbbounds(1),'c',0.5*sum(wbbounds) - 0.);
wbupper = makedist('Triangular','a',0.5*sum(wbbounds),'b',wbbounds(2),'c',wbbounds(2));
wb = [random(wblower,n,1); random(wbupper,n,1)];
wb = wb(randperm(length(wb)));

rhlower = makedist('Triangular','a',rhbounds(1),'b',rhbounds(1),'c',0.5*sum(rhbounds));
rhupper = makedist('Triangular','a',0.5*sum(rhbounds),'b',rhbounds(2),'c',rhbounds(2));
rh = [random(rhlower,n,1); random(rhupper,n,1)];
rh = rh(randperm(length(rh)));

susptravellower = makedist('Triangular','a',susptravelbounds(1),'b',susptravelbounds(1),'c',0.5*sum(susptravelbounds));
susptravelupper = makedist('Triangular','a',0.5*sum(susptravelbounds),'b',susptravelbounds(2),'c',susptravelbounds(2));
susptravel = [random(susptravellower,n,1); random(susptravelupper,n,1)];
susptravel = susptravel(randperm(length(susptravel)));

maxtorquelower = makedist('Triangular','a',maxtorquebounds(1),'b',maxtorquebounds(1),'c',0.5*sum(maxtorquebounds));
maxtorqueupper = makedist('Triangular','a',0.5*sum(maxtorquebounds),'b',maxtorquebounds(2),'c',maxtorquebounds(2));
maxtorque = [random(maxtorquelower,n,1); random(maxtorqueupper,n,1)];
maxtorque = maxtorque(randperm(length(maxtorque)));

gearinglower = makedist('Triangular','a',gearingbounds(1),'b',gearingbounds(1),'c',0.5*sum(gearingbounds));
gearingupper = makedist('Triangular','a',0.5*sum(gearingbounds),'b',gearingbounds(2),'c',gearingbounds(2));
gearing = [random(gearinglower,n,1); random(gearingupper,n,1)];
gearing = gearing(randperm(length(gearing)));

tirediamlower = makedist('Triangular','a',tirediambounds(1),'b',tirediambounds(1),'c',0.5*sum(tirediambounds));
tirediamupper = makedist('Triangular','a',0.5*sum(tirediambounds),'b',tirediambounds(2),'c',tirediambounds(2));
tirediam = [random(tirediamlower,n,1); random(tirediamupper,n,1)];
tirediam = tirediam(randperm(length(tirediam)));

energycaplower = makedist('Triangular','a',energycapbounds(1),'b',energycapbounds(1),'c',0.5*sum(energycapbounds));
energycapupper = makedist('Triangular','a',0.5*sum(energycapbounds),'b',energycapbounds(2),'c',energycapbounds(2));
energycap = [random(energycaplower,n,1); random(energycapupper,n,1)];
energycap = energycap(randperm(length(energycap)));

frameraillower = makedist('Triangular','a',framerailbounds(1),'b',framerailbounds(1),'c',0.5*sum(framerailbounds));
framerailupper = makedist('Triangular','a',0.5*sum(framerailbounds),'b',framerailbounds(2),'c',framerailbounds(2));
framerail = [random(frameraillower,n,1); random(framerailupper,n,1)];
framerail = framerail(randperm(length(framerail)));

bodypanellower = makedist('Triangular','a',bodypanelbounds(1),'b',bodypanelbounds(1),'c',0.5*sum(bodypanelbounds));
bodypanelupper = makedist('Triangular','a',0.5*sum(bodypanelbounds),'b',bodypanelbounds(2),'c',bodypanelbounds(2));
bodypanel = [random(bodypanellower,n,1); random(bodypanelupper,n,1)];
bodypanel = bodypanel(randperm(length(bodypanel)));

inputs = [tw wb rh susptravel maxtorque gearing tirediam energycap framerail bodypanel];

%% Categorizing inputs and constructing Vehicle Index

very = "Very ";
id = ["Narrow"	"Moderate Width"	"Wide"
        "Short"	"Moderate Length"	"Long"
        "Short Roof"	"Moderate Height Roof"	"Tall Roof"
        "Short Travel"	"Moderate Travel"	"Long Travel"
        "Low Output"	"Moderate Output"	"High Output"
        "Long Gearing"	"Moderate Gearing"	"Short Gearing"
        "Small Tire"	"Medium Tire"	"Large Tire"
        "Low Energy Capacity"	"Moderate Energy Capacity"	"High Energy Capacity"
        "Light-Duty Frame"	"Medium-Duty Frame"	"Heavy-Duty Frame"
        "Lightly Armored"	"Moderately Armored"	"Heavily Armored"];
% Terms used in the vehicle index to classify inputs

id = [append(very,id(:,1)) id append(very,id(:,3))];

%this loop goes element by element through the input matrix and assigns
%each input its corresponding classification
for i = 1:size(inputs,1)
    for j = 1:size(inputs,2)
        if inputs(i,j) >= b(j,1) && inputs(i,j) < b(j,1) + r(j)
            vehid(i,j) = id(j,1);
        elseif inputs(i,j) >= b(j,1) + r(j) && inputs(i,j) < b(j,1) + 2*r(j)
            vehid(i,j) = id(j,2);
        elseif inputs(i,j) >= b(j,1) + 2*r(j) && inputs(i,j) < b(j,1) + 3*r(j)
            vehid(i,j) = id(j,3);
        elseif inputs(i,j) >= b(j,1) + 3*r(j) && inputs(i,j) < b(j,1) + 4*r(j)
            vehid(i,j) = id(j,4);
        else
            vehid(i,j) = id(j,5);
        end
    end
end

%%

i = []; j=[];

%Evaluate each solution using the "GVfun.m" performance model
for i = 1:length(inputs)
    perf(i,:) = GVfun(inputs(i,:));
end

%invert all performance values so they are all minimized objectives
perf = 1./perf;


%%

labels = 1:1:length(perf);
names = {'Top Speed','Acceleration','Off-Road Ability','Operational Range','Low-Speed Maneuverability','Occupant Protection','Maintainability','Rollover Stability','Towing Capacity','Passenger Cabin Space'};
fignum = 0;

%This loop generates the full combinatorial set of possible bi-objective
%sub-problems - for a 10-objective problem, this is 45 subproblems. We plot
%all of them here, and select subsets of them for each round and version of
%the experiment

for j = 1:size(perf,2)
    for k = 1:size(perf,2)
        if j < k
            figure('Position',[100 100 750 750]);

            scatter(perf(:,j),perf(:,k),150,'.k')
            la = "\leftarrow Better ";
            ra = "\rightarrow";
            worse = "Worse ";
            xname = names(j);
            yname = names(k);
            pt1x = append(la,xname);
            pt2x = append(worse,xname,ra);
            pt1y = append(la,yname);
            pt2y = append(worse,yname,ra);
            if j == 5 || j == 10
                space = "   ";
            else
                space = "            ";
            end

            xlbl = append(pt1x,space,pt2x);

            if k == 5 || k == 10
                space = "   ";
            else
                space = "            ";
            end

            ylbl = append(pt1y,space,pt2y);

            if j == 5 || j == 10
                xlabel(xlbl,'FontSize',12)
            else
                xlabel(xlbl,'FontSize',14)
            end

            if k == 5 || k == 10
                ylabel(ylbl,'FontSize',12)
            else
                ylabel(ylbl,'FontSize',14)
            end

            % ylbl = append(pt1y,space,pt2y);
            % xlabel(xlbl)
            % ylabel(ylbl)
            xticklabels('')
            yticklabels('')
            hold on

            for i = 1:length(perf)
                text(perf(i,j) - (0.005*max(perf(:,j))),perf(i,k),num2str(labels(i)),'HorizontalAlignment','right','FontSize',15)
                hold on
            end

            axis([1 1.1*max(perf(:,j)) 1 1.1*max(perf(:,k))])
            fontname('Garamond')
            fontsize('increase')
            fontsize('increase')

            SPname = append(names(j),names(k));
            figstr = "plot.fig";

            filename = append(SPname,figstr);

            %KEEP THIS LINE COMMENTED OUT UNLESS YOU WANT 45 FIGURES SAVED  
            %------------------------------------------------------------
            %saveas(gcf,filename)
            %------------------------------------------------------------
            %KEEP THIS LINE COMMENTED OUT UNLESS YOU WANT 45 FIGURES SAVED
        end
    end
end


%%
%writematrix(inputs,'GVinputs.csv');
results = [];

%Results matrix alternates between numeric values and verbal descripion of
%input. Tried doing it with a for-loop to alternate the rows, but 
% alternating rows of strings and numbers made the .csv contain NaN's. Not
% sure why
results = [inputs(1,:)
            vehid(1,:)
            inputs(2,:)
            vehid(2,:)
            inputs(3,:)
            vehid(3,:)
            inputs(4,:)
            vehid(4,:)
            inputs(5,:)
            vehid(5,:)
            inputs(6,:)
            vehid(6,:)
            inputs(7,:)
            vehid(7,:)
            inputs(8,:)
            vehid(8,:)
            inputs(9,:)
            vehid(9,:)
            inputs(10,:)
            vehid(10,:)
            inputs(11,:)
            vehid(11,:)
            inputs(12,:)
            vehid(12,:)
            inputs(13,:)
            vehid(13,:)
            inputs(14,:)
            vehid(14,:)
            inputs(15,:)
            vehid(15,:)
            inputs(16,:)
            vehid(16,:)
            inputs(17,:)
            vehid(17,:)
            inputs(18,:)
            vehid(18,:)
            inputs(19,:)
            vehid(19,:)
            inputs(20,:)
            vehid(20,:)];
          
%Keep commented out unless you want to save the vehicle index as a .csv
%------------------------------------------------------------------------
%writematrix(results,'GVinputs.csv')
