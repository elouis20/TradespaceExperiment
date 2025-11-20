function [yy] = GVfun(xx)

%function takes a vector "xx" of 10 design variables, in the same order as 
% in the excel sheet, and outputs a vector "yy" of 10 outputs, in the same
% order as in the excel sheet. Each output is a weighted sum of the input
% vector

tw = [100 200];
wb = [80 100];
rh = [65 85];
susptravel = [6 24];
maxtorque = [400 750];
gearing = [2 6];
tirediam = [30 50];
energycap = [850 1700];
framerail = [0.25 1];
bodypanel = [0.125 2];
%upper and lower bounds for each design variable.
%hardcoded within the function to normalize inputs given in units to a
%non-dimensionalized 0-1 scale
%HARDCODED DO NOT TOUCH

xx(1) = (xx(1) - tw(1))/(tw(2) - tw(1));
xx(2) = (xx(2) - wb(1))/(wb(2) - wb(1));
xx(3) = (xx(3) - rh(1))/(rh(2) - rh(1));
xx(4) = (xx(4) - susptravel(1))/(susptravel(2) - susptravel(1));
xx(5) = (xx(5) - maxtorque(1))/(maxtorque(2) - maxtorque(1));
xx(6) = (xx(6) - gearing(1))/(gearing(2) - gearing(1));
xx(7) = (xx(7) - tirediam(1))/(tirediam(2) - tirediam(1));
xx(8) = (xx(8) - energycap(1))/(energycap(2) - energycap(1));
xx(9) = (xx(9) - framerail(1))/(framerail(2) - framerail(1));
xx(10) = (xx(10) - bodypanel(1))/(bodypanel(2) - bodypanel(1));
%normalization of input vector

weights = [-5	-5	-8	-3	-8	-3	-3	10	0	10
            -3	-5	-8	-3	-8	-3	-3	5	8	10
            -5	-5	-1	-3	0	-3	-3	-10	0	10
            -3	0	10	-1	-1	-3	-5	-8	0	-3
            10	10	5	-5	0	0	-8	0	5	-3
            -10	10	-8	-5	3	0	0	0	8	0
            8	-8	10	-5	-5	0	-5	-5	-3	-1
            -1	-1	0	10	0	0	0	0	3	-1
            -3	-3	3	-3	0	5	-3	-3	10	-1
            -3	-3	3	-3	-3	10	-5	-5	0	-3];
%weights from excel
%HARDCODED DO NOT TOUCH

norm = [18	20	31	10	3	15	0	15	34	30;
        -33	-30	-25	-31	-25	-12	-35	-31	-3	-12];
%normalization constants for the outputs, pulled from excel
%HARDCODED DO NOT TOUCH

topspeed = (sum(xx'.*weights(:,1)) - norm(2,1))/(norm(1,1) - norm(2,1));
acceleration = (sum(xx'.*weights(:,2)) - norm(2,2))/(norm(1,2) - norm(2,2));
offroad = (sum(xx'.*weights(:,3)) - norm(2,3))/(norm(1,3) - norm(2,3));
range = (sum(xx'.*weights(:,4)) - norm(2,4))/(norm(1,4) - norm(2,4));
maneuver = (sum(xx'.*weights(:,5)) - norm(2,5))/(norm(1,5) - norm(2,5));
protection = (sum(xx'.*weights(:,6)) - norm(2,6))/(norm(1,6) - norm(2,6));
maintain = (sum(xx'.*weights(:,7)) - norm(2,7))/(norm(1,7) - norm(2,7));
rollover = (sum(xx'.*weights(:,8)) - norm(2,8))/(norm(1,8) - norm(2,8));
towing = (sum(xx'.*weights(:,9)) - norm(2,9))/(norm(1,9) - norm(2,9));
cabinspace = (sum(xx'.*weights(:,10)) - norm(2,10))/(norm(1,10) - norm(2,10));
%Calculation of outputs. multiplies input vector by weight vector, then
%sums together, then normalizes


yy = [topspeed acceleration offroad range maneuver protection maintain rollover towing cabinspace];
%constructing vector from above outputs

end