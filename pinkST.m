function mov = pinkST()

d = 250;
T = 100;
fig = 0;

% parameters
v = 0.1;

% create the filter
%time = linspace(0,0.1,1);

% generate fourier coefficients
F = rand(d,d,T);
[xm, ym] = meshgrid(linspace(-1,1,d));

% generate 1/f shape
mask = repmat(1./(sqrt(xm.^2 + ym.^2) + 1e-3), 1, T);
mask = reshape(mask, size(mask,1), size(mask,1), T);
    
% modulate fourier coefficients
Fmod = abs(F).*mask.*exp(2*pi*1i*rand(d,d,T));
    
% filter
for p1 = 1:d
    for p2 = 1:d
        
        % pick a tau
        tau = 1./(mask(p1,p2,1) * v);
        time = 0:(5*tau);
        
        % convolve in time
        pij = conv(squeeze(Fmod(p1,p2,:)), exp(-time./tau), 'same');
        
        % store filtered coefficients
        F(p1,p2,:) = pij;
        
    end
end

% create the movie
mov = zeros(d,d,T);
for tidx = 1:T
    
    % take the inverse fourier transform
    mov(:,:,tidx) = real(ifft2(ifftshift(F(:,:,tidx))));
    
end


if fig
    figure(1);
    colormap gray;

    for tidx = 1:size(mov,3) 
        imagesc(mov(:,:,tidx));
        pause(0.15);
        title(tidx);
        drawnow;
    end
end
