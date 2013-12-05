function [thetaVec, gainVec, I, numSpikes] = lnpSims()

% make frames from image sequence
mov          = pinkST();
image_height = size(mov,1);
image_width  = size(mov,2);
T            = size(mov,3);
Ts           = 1.0/5.0;
input        = zeros(image_height, image_width, T/Ts);
for i = 1:T/Ts
    input(:,:,i) = mov(:,:,ceil(i*Ts));
end

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
thetaVec  = linspace(0.1,3,60);
gainVec   = logspace(0.01,1,60);
I         = zeros(length(thetaVec),length(gainVec),numNeurons);
numSpikes = zeros(length(thetaVec),length(gainVec),numNeurons);

for i = 1:length(thetaVec)
    theta = thetaVec(i);
    i %so I know how much longer I have to wait...
    for j = 1:length(gainVec)
        for n = 1:numNeurons
            % let's just do all large ON cells with biphasic temporal filters first
            spatialFiltered = zeros(image_height, image_width, T/Ts);
            location        = floor(rand(2,1).*([image_height image_width]'-2*max_rf_radius)) + max_rf_radius;
            filterRadius    = floor(filterHeightM/2);
            weights         = zeros(image_height+filterHeightM,image_width+filterWidthM);
            weights(location(1):location(1)+filterHeightM-1,location(2):location(2)+filterWidthM-1) = on_centerM;
            weights         = weights(filterRadius:image_height+filterRadius-1,filterRadius:image_width+filterRadius-1);
            oneDinput       = zeros(T/Ts,1);

            for t = 1:T/Ts
                spatialFiltered(:,:,t) = input(:,:,t).*weights;
                tmp = spatialFiltered(:,:,t);
                oneDinput(t) = sum(tmp(:));
            end

            [spikes, nonlinearOutput] = lnp(oneDinput, 'gain', gainVec(j), 'threshold', thetaVec(i), 'peakFiringRate', 1.1, 'plots', 0); 
            [~, I(i,j,n)]             = muti(spikes,oneDinput);
            numSpikes(i,j,n)          = sum(spikes);
    end
end

