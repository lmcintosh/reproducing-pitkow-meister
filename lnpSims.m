function [thetaVec, gainVec, I, numSpikes] = lnpSims()

% make frames from image sequence
input        = pinkST();
image_height = size(input,1);
image_width  = size(input,2);
T            = size(input,3); % number of frames
Ts           = 0.03;        % bin size in seconds
time         = T*Ts;

% how many neurons?
numNeurons = 1;

% center-surround parameters
max_rf_radius       = 10;
center_rate_density = 0.5;
filterHeightP       = 7;
filterWidthP        = 7;
centerRadiusP       = 2;
surroundRadiusP     = 4;
on_centerP  = center_surround(filterHeightP,filterWidthP,centerRadiusP,surroundRadiusP,center_rate_density);
off_centerP = center_surround(filterHeightP,filterWidthP,centerRadiusP,surroundRadiusP,-center_rate_density);

filterHeightM   = 15;
filterWidthM    = 15;
centerRadiusM   = 3;
surroundRadiusM = 7;
on_centerM  = center_surround(filterHeightM,filterWidthM,centerRadiusM,surroundRadiusM,center_rate_density);
off_centerM = center_surround(filterHeightM,filterWidthM,centerRadiusM,surroundRadiusM,-center_rate_density);

% sweep space of nonlinearities
thetaVec  = linspace(0.1,3,30);
gainVec   = logspace(0.01,1,30);
I         = zeros(length(thetaVec),length(gainVec),numNeurons);
numSpikes = zeros(length(thetaVec),length(gainVec),numNeurons);

for i = 1:length(thetaVec)
    i %so I know how much longer I have to wait...
    for j = 1:length(gainVec)
        for n = 1:numNeurons
            % let's just do all large ON cells with biphasic temporal filters first
            spatialFiltered = zeros(image_height, image_width, T);
            location        = floor(rand(2,1).*([image_height image_width]'-2*max_rf_radius)) + max_rf_radius;
            filterRadius    = floor(filterHeightM/2);
            weights         = zeros(image_height+filterHeightM,image_width+filterWidthM);
            weights(location(1):location(1)+filterHeightM-1,location(2):location(2)+filterWidthM-1) = on_centerM;
            weights         = weights(filterRadius:image_height+filterRadius-1,filterRadius:image_width+filterRadius-1);
            oneDinput       = zeros(T,1);

            for t = 1:T
                spatialFiltered(:,:,t) = input(:,:,t).*weights;
                tmp = spatialFiltered(:,:,t);
                oneDinput(t) = sum(tmp(:));
            end

            [spikes, nonlinearOutput] = lnp(oneDinput, 'binLength', Ts, 'gain', 1.0/gainVec(j), 'threshold', thetaVec(i), 'peakFiringRate', 30, 'plots', 0); 
            spikes(spikes>1)          = 1;
            [~, I(i,j,n)]             = muti(spikes,oneDinput,2,2);
            numSpikes(i,j,n)          = sum(spikes);
        end
    end
end

