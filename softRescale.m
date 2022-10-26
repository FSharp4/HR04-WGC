function rescaledData = softRescale(data,minimum, maximum)
%SOFTRESCALE Summary of this function goes here
%   Detailed explanation goes here
actualMinimum = min(data);
actualMaximum = max(data);
scaleMinimum = max(actualMinimum, minimum);
scaleMaximum = min(actualMaximum, maximum);
rescaledData = rescale(data, scaleMinimum, scaleMaximum);
end

