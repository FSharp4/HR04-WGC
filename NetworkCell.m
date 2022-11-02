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
    end
end
