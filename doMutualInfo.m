function [] = doMutualInfo()
%This function compute the bits/spike as calculated by the MutualInfo.m
%file for various theta and gain parameters


tic
thetaVec = 0.01:0.2:3;
gainVec = 1:0.1:10;
I = zeros(length(thetaVec),length(gainVec));
for n = 1:length(thetaVec)
    theta = thetaVec(n);
    for i = 1:length(gainVec)
        gain = gainVec(i);
        I(n,i) = MutualInfo(theta,gain);
    end
end
toc
keyboard
%plot
contour(thetaVec,1./gainVec,I',100)


return