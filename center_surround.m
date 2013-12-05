function [ filter_response ] = center_surround( height, width, center_radius, surround_radius, center_rate_density )
%CENTER_SURROUND Summary of this function goes here
%   Detailed explanation goes here
    filter_response = zeros(height,width);
    tweak_factor = 1;
    surround_rate_density = -center_rate_density*center_radius^2/(surround_radius^2-center_radius^2)*tweak_factor;
    for i = 1:height
        for j = 1:width
            if (i-1-height/2)^2 + (j-1-width/2)^2 <= center_radius^2
                filter_response(i,j) = center_rate_density;
            elseif (i-1-height/2)^2 + (j-1-width/2)^2 <= surround_radius^2
                filter_response(i,j) = surround_rate_density;
            end
        end
    end
end

