function baseStations = calculateBSPos(n)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
currentBaseStation = [0, 0];
baseStations = zeros(n, 2);
side = 1;
ring = 2;
sideIndex = 2;
cellIndex = 2;
currentBaseStation = currentBaseStation + [1.5, sqrt(3) / 2];
while cellIndex <= n
    baseStations(cellIndex, :) = currentBaseStation;
    sideIndex = sideIndex + 1;
    
    if (sideIndex > ring)
        sideIndex = 2;
        side = side + 1;
    end

    switch side
        case 1
            currentBaseStation = currentBaseStation + [1.5, -sqrt(3) / 2];
        case 2
            currentBaseStation = currentBaseStation + [0, -sqrt(3)];
        case 3
            currentBaseStation = currentBaseStation + [-1.5, -sqrt(3) / 2];
        case 4
            currentBaseStation = currentBaseStation + [-1.5, sqrt(3) / 2];
        case 5
            currentBaseStation = currentBaseStation + [0, sqrt(3)];
        case 6
            currentBaseStation = currentBaseStation + [1.5, sqrt(3) / 2];
        case 7
            currentBaseStation = currentBaseStation + [1.5, sqrt(3) / 2];
            sideIndex = 2;
            side = 1;
            ring = ring + 1;
    end
    
    cellIndex = cellIndex + 1;
end
end

