function [I] = MutualInfo(theta,gain)
%This function takes parameters theta and gain, which set the nonlinearity,
%and returns the mutual information in bits/spike between the firing rate
%(as determined deterministically from the stimulus) and the number of
%spikes per bin

global deltaT mu

deltaT = 0.05; %s (50 ms); time bin for spike count
mu = 1.1; %Hz, mean firing rate for ganglion cell

%Peak firing rate
KTop = mu*sqrt(2*pi);

KInt = @(r) exp(-0.5*r.^2)./(1+exp(-gain*(r-theta)));
KBottom = integral(KInt,-Inf,Inf);

K = KTop/KBottom;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plot of logistic function
r = -10:0.01:10;
N = K./(1+exp(-gain*(r-theta)));
%plot(r,N)
%keyboard

%Calculation of mutual information, I = H(n) - H(n|rho)

%while loop to calculate infinite sum H(n) = -sum_n=0^inf(p(n)*log2(p(n))

Hn = 0; 
n = 0;
term = 10;
while abs(term) > eps
    term = spikeCountProb(K,theta,gain,n)*...
        log2(spikeCountProb(K,theta,gain,n));
    if isnan(term)
        keyboard
    end
    Hn = Hn+term;
    n = n+1;
    if n> 1000
        keyboard
    end
end

Hn = -Hn;

%calculate Hnrho = int(Hnrho_sum*p(rho)drho
HnrhoInt = @(rho) Hsum(rho).*firingRateDist(K,rho,theta,gain);
Hnrho = integral(HnrhoInt,0.01,K);

%mean spike count
spkCount = 0;
k = 0;
val = 10;
while abs(val) > eps
    val = spikeCountProb(K,theta,gain,k);
    spkCount = spkCount+k*val;
    k = k+1;
end

%Mutual Information
I = Hn - Hnrho;
%bits/spike
I = I/spkCount;
if isnan(I)
    keyboard
end

return

function [prob] = poissonDist(n,rho)
% Eq 9: P(n|rho) = e^(-rho*deltaT)*(rho*deltaT)^n/n!

global deltaT

prob = exp(-rho*deltaT).*(rho*deltaT).^n./factorial(n);

return

function [p] = firingRateDist(K,rho,theta,gain)
%Eq 19: p(rho) = the mess below

pTop = K*exp(-0.5*(1/gain*log2(K./rho-1)-theta).^2);

pBottom = sqrt(2*pi)*gain*rho.^2.*(K./rho-1);

p = pTop./pBottom;

return

function [PofN] = spikeCountProb(K,theta,gain,n)
%p(n) = int [p(n|rho)*p(rho)drho]

PInt = @(rho) poissonDist(n,rho).*firingRateDist(K,rho,theta,gain);
PofN = integral(PInt,0.001,K);

return

%while loop to calculate infinite sum ==>
%sum_i+0^inf(P(n|rho)*log2(P(n|rho))
function [Hnrho_sum] = Hsum(rho)

Hnrho_sum = 0;
i = 0;
value = 10;
while abs(value) > eps
    value = poissonDist(i,rho).*log2(poissonDist(i,rho));
    Hnrho_sum = Hnrho_sum + value;
    i = i+1;
    if i > 1000
        keyboard
    end
end 
 
Hnrho_sum = -Hnrho_sum;
return

