function [N] = hist2D(xVals,yVals,binCx,binCy,doPlot)
% INPUTS: xVals, yVals, binCx, binCy, doPlot (1 is plots on)
% OUTPUTS: N

if exist('doPlot') ~= 1
    doPlot = 0;
end

for ii = 1 : length(binCx)
       
    if ii == 1
        
        rEdge = binCx(ii) + ((binCx(ii+1) - binCx(ii)) / 2);
        binInds = find(xVals<=rEdge);
        
        [N(:,ii),x] = hist(yVals(binInds),binCy);                
                
    elseif ii == length(binCx)
        
        lEdge = binCx(ii) - ((binCx(ii) - binCx(ii-1)) / 2);
        binInds = find(xVals>lEdge);
        
        [N(:,ii),x] = hist(yVals(binInds),binCy); 
        
    else
        
        rEdge = binCx(ii) + ((binCx(ii+1) - binCx(ii)) / 2);
        lEdge = binCx(ii) - ((binCx(ii) - binCx(ii-1)) / 2);
        binInds = find(xVals>lEdge & xVals<=rEdge);       
       
        [N(:,ii),x] = hist(yVals(binInds),binCy); 
        
    end
    
end

if doPlot
    figure
    imagesc(N)
end