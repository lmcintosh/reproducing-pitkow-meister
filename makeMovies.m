stim = pinkST();
T = size(stim,3);

fig1         = figure(1);
pause(25)
winsize      = get(fig1,'Position');
winsize(1:2) = [0,0];
numframes    = size(stim,3);

A = moviein(numframes,fig1,winsize);
set(fig1,'NextPlot','replacechildren')




% center-surround parameters
filterHeightM   = 15;
filterWidthM    = 15;
centerRadiusM   = 3;
surroundRadiusM = 7;
on_centerM  = center_surround(filterHeightM,filterWidthM,centerRadiusM,surroundRadiusM,center_rate_density);
off_centerM = center_surround(filterHeightM,filterWidthM,centerRadiusM,surroundRadiusM,-center_rate_density);

spatialFiltered = zeros(image_height, image_width, T);
location        = floor(rand(2,1).*([image_height image_width]'-2*max_rf_radius)) + max_rf_radius;
filterRadius    = floor(filterHeightM/2);
weights         = zeros(image_height+filterHeightM,image_width+filterWidthM);
weights(location(1):location(1)+filterHeightM-1,location(2):location(2)+filterWidthM-1) = on_centerM;
weights         = weights(filterRadius:image_height+filterRadius-1,filterRadius:image_width+filterRadius-1);
oneDinput       = zeros(T,1);

for i = 1:numframes
    subplot(2,3,1)
    colormap gray;
    imagesc(stim(:,:,i));
    title('Naturalistic stimulus')

    subplot(2,3,2)
    colormap gray;
    imagesc(stim(:,:,i).*weights);
    title('Stimulus weighted by receptive field')

    subplot(2,3,3)
    tmp = stim(:,:,i).*weights;
    oneDinput(i) = sum(tmp(:));
    plot(1:T,oneDinput)
    title('Linear Output after center-surround')

    subplot(2,3,4)
    kernel = linearKernel(1,-0.5,1,30);
    linearOutput = conv(oneDinput,kernel,'same');
    plot(1:T,linearOutput)
    title('Linear Output after biphasic filter')

    subplot(2,3,5)
    nonlinearOutput = sigmoid(linearOutput,'gain',100,'threshold',1.5,'maximum',30);
    nonlinearOutput = col(nonlinearOutput);
    normConstant    = sum(nonlinearOutput);
    nonlinearOutput = 1.1*nonlinearOutput/normConstant;
    plot(1:T,nonlinearOutput)
    title('Output after sigmoid nonlinearity')

    subplot(2,3,6)
    spikeTrain = poissrnd(length(oneDinput)*0.015*nonlinearOutput);
    ts = 0:length(spikeTrain)-1;
    spikes = ts(find(spikeTrain));
    for j = 1:length(spikes)
        line([spikes(j),spikes(j)],[0,1],'Color','k');
    end



    A(:,i) = getframe(fig1,winsize);
end

movie(fig1,A,1,3,winsize)

mpgwrite(A,jet,'stimulus.mpg');
