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

%% Sampling inputs


%I may update this code to load data rather than copy pasting from .csv's,
%but this is a small data set for a single paper
inputs = [196	80.2	79.3	22.9	728	5.87	46	1620	0.948	0.98
        110	80.1	65.5	20.8	421	2.15	49	1660	0.939	1.48
        119	80.2	70.2	6.8	543	4.67	48	1560	0.285	0.18
        181	81.2	69.2	9.7	655	2.37	32	1070	0.877	1.99
        192	85.6	65.3	21.1	684	2.61	45	1240	0.783	1.48
        178	81.1	79.1	6.8	409	2.53	47	1530	0.251	0.47
        199	84.2	68.2	22.7	419	2.4	39	1520	0.331	1.74
        176	98.8	69.2	10.8	443	5.08	31	960	0.994	1.67
        195	96.4	66.1	9.3	630	5.12	50	1610	0.741	0.17
        134	83.1	80	18.1	706	5.95	49	1010	0.512	1.75
        107	87.6	78	8.1	750	2.93	30	880	0.335	1.97
        114	99.7	82	18.4	715	2.25	30	980	0.967	0.74
        107	98.2	66.6	23.1	512	5.32	30	1530	0.284	0.84
        110	92	67.4	20.6	517	2.84	33	1210	0.432	1.82
        200	95.1	81.7	20.6	665	5.92	31	1460	0.313	1.67
        124	99.8	82.1	18.8	532	3.62	31	1570	0.782	0.33
        172	94	83.4	9.6	735	5.94	43	1500	0.313	0.78
        192	98	82.4	6.5	442	3.23	35	1120	0.308	1.7
        108	84.8	66.3	9.6	456	5.74	50	1080	0.966	0.84
        102	92.3	76.1	8.6	715	4.79	45	990	0.733	0.28
        ];


%% selected solutions from packets


ofind = [1	2	7	8
        3	5	6	9
        2	4	7	10
        2	5	9	10
        1	3	6	7
        1	4	6	8
        2	3	6	10
        1	5	8	9
        3	4	7	10];
%These are the objective function pairings for each version and round. i.e.
%the first row is Version A, Round 1's obj fn pairings, indexed as they
%appear in the original model ("1" = Top Speed, "2" = Acceleration, so on)

xstar = [13	1	2	7	8
        11	3	5	6	9
        13	2	4	7	10
        3	1	2	7	8
        2	3	5	6	9
        13	2	4	7	10
        3	1	2	7	8
        2	3	5	6	9
        13	2	4	7	10
        11	1	2	7	8
        1	3	5	6	9
        11	2	4	7	10
        1	2	5	9	10
        2	1	3	6	7
        4	1	4	6	8
        20	2	5	9	10
        2	1	3	6	7
        14	1	4	6	8
        20	2	5	9	10
        2	1	3	6	7
        4	1	4	6	8
        20	2	5	9	10
        2	1	3	6	7
        5	1	4	6	8
        17	2	5	9	10
        14	1	3	6	7
        14	1	4	6	8
        20	2	5	9	10
        2	1	3	6	7
        14	1	4	6	8
        10	2	3	6	10
        4	1	5	8	9
        7	3	4	7	10
        11	2	3	6	10
        20	1	5	8	9
        6	3	4	7	10
        4	2	3	6	10
        20	1	5	8	9
        6	3	4	7	10
        11	2	3	6	10
        4	1	5	8	9
        6	3	4	7	10];
%First column contains the numbers selected by groups during each round.
%The columns thereafter are the objective function indices, same as the
%ofind matrix, just assigned to all 14 teams the experiment was conducted
%on



for i = 1:length(inputs)
    output(i,:) = GVfun(inputs(i,:));
end
output = 1./output;
%% Big loop

i = [];
for i = 1:length(xstar)
    ystarfull(i,:) = GVfun(inputs(xstar(i,1),:));
    ystar(i,:) = ystarfull(i,xstar(i,2:5));
end
ystar = 1./ystar;

i = [];
m=[];
n=[];

names = {'Top Speed','Acceleration','Off-Road Ability',...
    'Operational Range','Low-Speed Maneuverability','Occupant Protection'...
    ,'Maintainability','Rollover Stability','Towing Capacity',...
    'Passenger Cabin Space'};

maintitle = ["Version A, Round 1 - Collaborative"
             "Version A, Round 2 - Adversarial"
             "Version A, Round 3 - Adversarial w/ Silo"
             "Version B, Round 1 - Adversarial w/ Silo"
             "Version B, Round 2 - Adversarial"
             "Version B, Round 3 - Collaborative"
             "Version C, Round 1 - Adversarial"
             "Version C, Round 2 - Adversarial w/ Silo"
             "Version C, Round 3 - Collaborative"];

filename = ["VAR1"
           "VAR2"
           "VAR3"
           "VBR1"
           "VBR2"
           "VBR3"
           "VCR1"
           "VCR2"
           "VCR3"];

png = ".png";
fig = ".fig";

for i = 1:length(ofind)
    r = find(ismember(xstar(:,2:5),ofind(i,:),'rows'));
    a = ystar(r,:);


    k = 0;
    figure('Position',[1 1 650 900]);
    
    solns = [output(:,ofind(i,1)) output(:,ofind(i,2)) output(:,ofind(i,3)) output(:,ofind(i,4))];
    pfindex = find_pareto_frontier(solns);
    pf = solns(pfindex,:);
    tiledlayout(3,2, 'Padding', 'none', 'TileSpacing', 'compact'); 
    for m = 1:size(ystar,2)
        for n = 1:size(ystar,2)
            if m < n
                nexttile
                
                k = k+1;
                
                subindex = 1:1:6;
    
                % subplot(3,2,subindex(k))
                scatter(output(:,ofind(i,m)),output(:,ofind(i,n)),150,'.k')
                hold on
                %plot all solutions

                scatter(pf(:,m),pf(:,n),36,'ob','filled')
                hold on
                %indicate Pareto-optimal solutions with blue stars

                scatter(a(:,m),a(:,n),75,'ok','LineWidth',1.5)
                %indicate participant-selected solutions by circling them

                sgtitle(maintitle(i))

                xname = names(ofind(i,m));
                yname = names(ofind(i,n));

                xlabel(xname); ylabel(yname)

                axis([1 1.1*max(output(:,m)) 1 1.1*max(output(:,n))])
                % fontname('Garamond')
                % fontsize('increase')
                % fontsize('increase')

                xticklabels('')
                yticklabels('')
    
            end
        end
    end

    fontname('Garamond')
    fontsize('increase')
    fontsize('increase')
    fontsize('increase')
    fontsize('increase')

    pngname = append(filename(i),png);
    figname = append(filename(i),fig);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Uncomment if you want to save figures - this command will save 18
    %figures into your working directory - beware!

    % saveas(gcf, pngname)
    % saveas(gcf, figname)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end




