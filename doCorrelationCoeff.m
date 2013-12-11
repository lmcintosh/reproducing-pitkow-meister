function [] = doCorrelationCoeff()

%gain = 8;
%K = 30;

thetaVec = linspace(0,4,20);
%thetaVec = 1.5;
CoeffList = linspace(-0.6,0.6,2);
gainList = linspace(0.1,10,20);
%CoeffList = 0.6;

CoeffVec = zeros(length(thetaVec),length(gainList),length(CoeffList));

for n = 1:length(thetaVec)
    
    theta = thetaVec(n);
    
    for j = 1:length(gainList)
        
        gain = gainList(j);
        
        for i = 1:length(CoeffList)
            
            c = CoeffList(i);
            
            [Coeff] = correlationCoeff(gain,theta,c);
            
            CoeffVec(n,j,i) = Coeff;
        end
    end
    
end
keyboard
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FIGURE 4D
lowThresh1 = squeeze(CoeffVec(1,1,:));
lowThresh2 = squeeze(CoeffVec(2,2,:));
highThresh1 = squeeze(CoeffVec(3,1,:));
highThresh2 = squeeze(CoeffVec(4,2,:));

figure(1)
plot(CoeffList,squeeze(lowThresh1),'--b','Linewidth',2)
hold on
plot(CoeffList,squeeze(lowThresh2),'b','Linewidth',2)
plot(CoeffList,squeeze(highThresh1),'--b','Linewidth',4)
plot(CoeffList,squeeze(highThresh2),'b','Linewidth',4)
plot(CoeffList,CoeffList,'k','Linewidth',3)

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
plot(thetaVec,CoeffVec(:,1)/CoeffList(1),'k','Linewidth',3)
hold on
plot(thetaVec,CoeffVec(:,2)/CoeffList(2),'k','Linewidth',3)
hold off
%}

keyboard