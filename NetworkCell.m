classdef NetworkCell
    % Networks are stored via cells (this class)
    % Points within the cell are stored in absolute positioning.
    % Cells in a network are centered around base stations; the position
    % of the base station is also absolute.
    %
    % No checking is done on user methods to make sure those users are
    % within this cell; this should be done at the caller level.
    properties
        BaseStation = [0, 0];
        Users = [];
        Radius = 1;
    end
    methods 
        function obj = NetworkCell(r, k, l)
            if nargin ~= 0
                baseStations = calculateBSPos(l) * r;
                obj(l) = obj;
                for ii = 1:l
                    obj(ii).BaseStation = baseStations(ii, :);
                    obj(ii).Radius = r;
                    obj(ii).Users = generateHexagonPoints(r, k) + obj(ii).BaseStation;
                end
            end
        end

        function n = nUsers(obj)
            if numel(obj) > 1
                n = zeros(1, numel(obj));
                for ii=1:numel(obj)
                    n(ii) = nUsers(obj(ii));
                end
            else
                n = length(obj.Users);
            end
        end

        function trace = tracePerimeter(obj, onFigure)
            if numel(obj) > 1
                theta = (0:6) * pi / 3;
                R = obj(1).Radius * ones(1, 7);
                trace = zeros(2*numel(obj), 7);
                [X, Y] = pol2cart(theta, R);
                for ii=1:numel(obj)
                    trace(2 * ii - 1, :) = X + obj(ii).BaseStation(1);
                    trace(2 * ii, :) = Y + obj(ii).BaseStation(2);
                end
                if exist('onFigure') && onFigure == true
                    hold on
                    for ii=1:numel(obj)
                        plot(trace(2 * ii - 1, :), trace(2 * ii, :));
                    end
                    hold off
                end
            else
                theta = (0:6) * pi / 3;
                R = obj.Radius * ones(1, 7);
                trace = zeros(2, 7);
                [X, Y] = pol2cart(theta, R);
                trace(1, :) = X;
                trace(2, :) = Y;
                if exist('onFigure') && onFigure == true
                    hold on
                    plot(X, Y)
                    hold off
                end
            end
        end
    end
end
