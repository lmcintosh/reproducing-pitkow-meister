function [H, I] = mutiN(a, b, nBins)
    %Function to compute the mutual information between neuron voltage and the input current - with just two bins!
    
    binsA = linspace(min(a), max(a), nBins);
    binsB = linspace(min(b), max(b), nBins);
    
    % Counting
    CountsAB = hist2d(a, b, binsA, binsB, 0);
    CountsA = sum(CountsAB,1); % this sums all the rows, leaving the marginal distribution of voltage
    CountsB = sum(CountsAB,2); % this sums all the cols, leaving the marginal distribution of current
    
    pA  = CountsA/sum(sum(CountsA));
    pB  = CountsB/sum(sum(CountsB));
    pAB = CountsAB/sum(sum(CountsAB));
    
    
    if abs(1 - sum(sum(pA))) > 0.01
        'Probabilities pA do not sum to one '  
        sum(pA)
    elseif abs(1 - sum(sum(pB))) > 0.01
        'Probabilities pB do not sum to one '  
        sum(pB)
    elseif abs(1 - sum(sum(pAB))) > 0.01
        'Probabilities pAB do not sum to one ' 
        sum(pAB)
    end
    
    
    % Entropies
    HA  = 0.0;
    HB  = 0.0;
    HAB = 0.0;
    
    for i = 1:length(pB)
        if pB(i) ~= 0
            HB = HB - pB(i)*log2(pB(i));
        end
    end
    
    for j = 1:length(pA)
        if pA(j) ~= 0
            HA = HA - pA(j) * log2(pA(j));
            for i = 1:length(pB)
                if pAB(i,j) ~= 0
                    HAB = HAB - pAB(i,j) * log2(pAB(i,j));
                end
            end
        end
    end
                    
    H = [HA, HB, HAB];
    I = HA + HB - HAB;
    
