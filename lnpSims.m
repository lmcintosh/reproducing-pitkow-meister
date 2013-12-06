function [thetaVec, gainVec, I, I3, numSpikes] = lnpSims()

% make frames from image sequence
input        = pinkST();
image_height = size(input,1);
image_width  = size(input,2);
T            = size(input,3); % number of frames
Ts           = 0.015;        % bin size in seconds
time         = T*Ts;

% how many neurons?
numNeurons = 1;

% center-surround parameters
max_rf_radius       = 10;
center_rate_density = 0.5; % changed from 0.5; in highCenter was 0.7
filterHeightM   = 15;
filterWidthM    = 15;
centerRadiusM   = 3;
surroundRadiusM = 7;
on_centerM  = center_surround(filterHeightM,filterWidthM,centerRadiusM,surroundRadiusM,center_rate_density);
off_centerM = center_surround(filterHeightM,filterWidthM,centerRadiusM,surroundRadiusM,-center_rate_density);

% sweep space of nonlinearities
thetaVec  = linspace(0.1,3,10);
gainVec   = logspace(0.01,1,10);
I         = zeros(length(thetaVec),length(gainVec),numNeurons);
%I2        = zeros(length(thetaVec),length(gainVec),numNeurons);
I3        = zeros(length(thetaVec),length(gainVec),numNeurons);
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
            
            iterations = 2000;
            spikes = zeros(length(oneDinput),iterations);
            for k = 1:iterations
                [spikes(:,k), nonlinearOutput] = lnp(oneDinput, 'binLength', Ts, 'gain',  gainVec(j), 'threshold', thetaVec(i), 'peakFiringRate', 30, 'plots', 0);
            end
            spikes(spikes>1)          = 1;
            avg_spikes                = sum(spikes,2)/iterations;
            [~, I(i,j,n)]             = mutiN(nonlinearOutput,avg_spikes,50);
            %[~, I2(i,j,n)]            = mutiN(nonlinearOutput,oneDinput,50);
            [~, I3(i,j,n)]            = mutiN(avg_spikes,oneDinput,50);
            numSpikes(i,j,n)          = sum(avg_spikes);
        end
    end
end

defaultfigureproperties;
figure; contourf(thetaVec,gainVec,I); colorbar; xlabel('Threshold'); ylabel('1/gain'); title('Bits between Nonlinear output and spike trains');
%figure; contourf(thetaVec,gainVec,I2); colorbar; xlabel('Threshold'); ylabel('1/gain'); title('Bits between 1d input and nonlinear output');
figure; contourf(thetaVec,gainVec,I3); colorbar; xlabel('Threshold'); ylabel('1/gain'); title('Bits between 1d input and spike trains');
figure; contourf(thetaVec,gainVec,I./numSpikes); colorbar; xlabel('Threshold'); ylabel('1/gain'); title('Bits/spike between Nonlinear output and spike trains');
%figure; contourf(thetaVec,gainVec,I2./numSpikes); colorbar; xlabel('Threshold'); ylabel('1/gain'); title('Bits/spike between 1d input and nonlinear output');
figure; contourf(thetaVec,gainVec,I3./numSpikes); colorbar; xlabel('Threshold'); ylabel('1/gain'); title('Bits/spike between 1d input and spike trains');
tilefigs
