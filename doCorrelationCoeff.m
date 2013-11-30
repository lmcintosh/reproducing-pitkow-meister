function [] = doCorrelationCoeff()

gain = 8;

thetaVec = linspace(0.01,4,20);
%thetaVec = 1.5;
CoeffList = linspace(-0.6,0.6,2);
%CoeffList = 0.6;

CoeffVec = zeros(length(thetaVec),length(CoeffList));

for n = 1:length(thetaVec)
    
    theta = thetaVec(n);
    
    for i = 1:length(CoeffList)
        
        c = CoeffList(i);
        
        [Coeff] = correlationCoeff(gain,theta,c);
        
        CoeffVec(n,i) = Coeff;
    end
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIGURE 4C
%{
plot(CoeffList,CoeffVec,'k','Linewidth',3)
hold on
plot(CoeffList,CoeffList,'b','Linewidth',2)
plot(zeros(1,200),linspace(-1,1,200),'r','Linewidth',2)
plot(linspace(-1,1,200),zeros(1,200),'r','Linewidth',2)
hold off
%}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIGURE 4D
%{
plot(thetaVec,CoeffVec,'k',Linewidth',3)
%}

keyboard