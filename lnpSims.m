function [] = lnpSims()

mov = pinkST();

% sweep space of nonlinearities
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

