function [spikeTrain,stimulus,nonlinearOutput] = lnp(time,resolution,point,slope,variance,binLength,stimulusType,plots)
% lnp is a linear-nonlinear-poisson cascade model used to model retinal ganglion neurons
% INPUTS: time (duration of output), resolution (length of linear filter),
% point (threshold), slope (slope of threshold), variance, binLength, stimulusType (0,1,or vector), plots 
% OUTPUTS: spikeTrain, stimulus, nonlinearOutput

%time = 1000; % ms
%resolution = 32;
%point = .5*10e4;
%slope = 2;
%binLength = 1;
discount = 0.001;

% create the linear filter
kernel = linearKernel(1,-0.5,1,resolution); % inputs: freq, phase, var, resolution

% create the stimulus
%variance = .1;
meanStim = 0;
if stimulusType == 0
    stimulus = sqrt(variance)*randn(time/binLength,1) + meanStim;
elseif stimulusType == 1
    load pinknoise;
    allowedStart = length(x) - (time/binLength + 1);
    startFrame = ceil(allowedStart*rand(1));
    x(1:startFrame)=[];
    x((time/binLength)+1:end)=[];

    Xstd = std(x);
    stimulus = x.*sqrt(variance)/Xstd;
    stimulus = stimulus - mean(stimulus) + meanStim;
    %stimulus = wiener(mean,0,sqrt(variance),time,0); % random walk stimulus
    % starting pt, drift, standard deviation of samples at time t = 1, how long, figures?
else
    stimulus = stimulusType;
end

% pass the stimulus through the linear filter
linearOutput = conv(stimulus,kernel,'same'); % should this be 'full' to maintain causality, and then snip the end?

% pass the linear filter's output through the nonlinearity/threshold
nonlinearOutput = threshold(linearOutput,point,slope);
nonlinearOutput = col(nonlinearOutput);

% use poisson probability of spiking to generate a spike train
spikeTrain = poissrnd(binLength*nonlinearOutput*discount);
moreSpikes = find(spikeTrain>1);
spikeTrain(moreSpikes) = 1;

ts = 0:length(spikeTrain)-1;
spikes = ts(find(spikeTrain));

if plots ~= 0
    figure; subplot(4,1,1), plot(stimulus), title('Stimulus'),
    subplot(4,1,2), plot(linearOutput), title('Linear Output'),
    subplot(4,1,3), plot(nonlinearOutput), title('Nonlinear Output'),
    subplot(4,1,4), axis([0,time/binLength,0,1]), ...
        for i = 1:length(spikes)
            line([spikes(i),spikes(i)],[0,1],'Color','k');
        end
end

%rasters(spikeTrain)
