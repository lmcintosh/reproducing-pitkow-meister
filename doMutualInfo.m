function [] = doMutualInfo()
%This function compute the bits/spike as calculated by the MutualInfo.m
%file for various theta and gain parameters

tic
thetaVec = linspace(0.1,3,60);
gainVec = logspace(0.01,1,60);
I = zeros(length(thetaVec),length(gainVec));
for n = 1:length(thetaVec)
    theta = thetaVec(n);
    n %so I know how much longer I have to wait...
    for i = 1:length(gainVec)
        gain = gainVec(i);
        I(n,i) = MutualInfo(theta,gain);
    end
end
toc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLOT FIGURE 4f

colormap('hot');
axes1 = axes('Parent',figure,'YTick',zeros(1,0),'XTick',[1 2 3],...
    'Layer','top',...
    'FontSize',20,...
    'FontName','Times New Roman');
box(axes1,'on');
hold(axes1,'all');
contourf(thetaVec,log(1./gainVec),I',30)
% Create title
title('Mutual Information','FontSize',20);
% Create xlabel
xlabel('Threshold','FontSize',20);
% Create ylabel
ylabel('1/gain','FontSize',20);
% Create colorbar
colorbar('peer',axes1,'FontSize',20,'FontName','Times New Roman');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

keyboard


return