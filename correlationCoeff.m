function [Coeff] = correlationCoeff(gain,theta,c)

%Peak firing rate
deltaT = 0.05; %s (50 ms); time bin for spike count
mu = 1.1; %Hz, mean firing rate for ganglion cell
KTop = mu*sqrt(2*pi);
KInt = @(r) exp(-0.5*r.^2)./(1+exp(-gain*(r-theta)));
KBottom = integral(KInt,-Inf,Inf);
K = KTop/KBottom;

%<N(x)> = int(N(x)*probabilitydensityfunction)
NInt = @(x,y) nonlinear(x,gain,theta,K).*ProbDensity(x,y,c);
N = integral2(NInt,-Inf,Inf,-Inf,Inf);

%<N(x)^2> = int(N(x)^2*probabilitydensityfunction)
N2Int = @(x,y) (nonlinear(x,gain,theta,K).^2).*ProbDensity(x,y,c);
N2 = integral2(N2Int,-Inf,Inf,-Inf,Inf);

%<N(x)N(y)> = int(N(x)*N(x)*probabilitydensityfunction)
NxyInt = @(x,y) nonlinear(x,gain,theta,K).*nonlinear(y,gain,theta,K).*ProbDensity(x,y,c);
Nxy = integral2(NxyInt,-Inf,Inf,-Inf,Inf);

sigma2 = N2-N.^2;

Coeff = (Nxy - N.^2)/sigma2;


return

function [P] = ProbDensity(x,y,c)

P = (1)/(2*pi*sqrt(1-c^2))*exp(-(x.^2-2*x.*y.*c+y.^2)/(2*(1-c^2)));

return

function [N] = nonlinear(x,gain,theta,K)

N = K./(1+exp(-gain.*(x-theta)));

return