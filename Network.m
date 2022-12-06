classdef Network
    %NETWORK OOP representation of cellular network for WGC-PD project
    %   Represents the network via an array of cells and short collection
    %   of overarching parameters
    %
    %   - SigmaShadow (determines distribution of lognormal constants for
    %     fading calculations)
    %   - PathLossExponent (largely determines decay rate with distance for
    %     large-scale fading)

    properties
        Cells = [];
        SigmaShadow = 1;
        PathLossExponent = 3;
        M = 8;
    end

    methods

        function obj = Network(r, k, l, m)
            %NETWORK Construct a cellular network for WGC-PD simulations
            %   Constructs a network of k cells, with radius r, having l
            %   users.
            obj.M = m
            obj.Cells = NetworkCell(r, k, l);
        end

        function users = getUsers(obj)
            nUsers = cumsum([obj.Cells.nUsers()]);
            shift = [0, nUsers(1:end - 1)];
            users = zeros(nUsers(end), 2);

            for ii = 1:length(obj.Cells)
                users(shift(ii) + 1:nUsers(ii), :) = obj.Cells(ii).Users;
            end

        end

        function stations = getBaseStations(obj)
            stations = zeros(length(obj.Cells), 2);

            for ii = 1:length(obj.Cells)
                stations(ii, :) = obj.Cells(ii).BaseStation;
            end

        end

        function sample = randomLogNormal(obj, m, n)
            if nargin == 1
                sample = exp(randn() * obj.SigmaShadow / 10);
            elseif nargin == 2
                sample = exp(randn(m) * obj.SigmaShadow / 10);
            else
                sample = exp(randn(m, n) * obj.SigmaShadow / 10);
            end

        end

        function coefficient = calculateLSFC(obj, jj, kk, ii)
            % CALCULATELSFC Function for calculating Large-Scale Fading
            %   Coefficient
            %
            %   Finds the LSFC for user j in cell k to base station i,
            %   within network obj.
            z = obj.randomLogNormal();
            user = obj.Cells(kk).Users(jj, :);
            station = obj.Cells(ii).BaseStation;
            r = vecnorm(user - station);
            R = obj.Cells(ii).Radius;
            coefficient = z / (r / R)^obj.PathLossExponent;
        end

        function lsfcs = calculateLSFCs(obj)
            % CALCULATELSFCS Function for calculating ALL Large-Scale
            %   Fading Coefficients within a network obj.
            %
            %   Returned as a m x n x n array where n is the number of
            %   cells and m is the number of users within a cell.
            %   The array is indexed such that the lsfc of user j in cell k
            %   against base station i can be found at index (j, k, i)
            nCells = length(obj.Cells);
            nUsersPerCell = length(obj.Cells(1).Users);
            lsfcs = zeros(nUsersPerCell, nCells, nCells);
            stations = obj.getBaseStations();
            tmp = zeros(2, nUsersPerCell, nCells);

            for kk = 1:length(obj.Cells)
                z = obj.randomLogNormal(nUsersPerCell, nCells);
                users = obj.Cells(kk).Users;
                tmp(1, :, :) = users(:, 1) - stations(:, 1)';
                tmp(2, :, :) = users(:, 2) - stations(:, 2)';
                r = squeeze(vecnorm(tmp));
                R = obj.Cells(1).Radius;
                lsfcs(:, kk, :) = z ./ (r / R).^obj.PathLossExponent;
            end
        end

        function lsfcs = fallbackLSFCs(obj)
            % Used for testing calculateLSFCs.
            % Shown to be equivalent through testing.
            nCells = length(obj.Cells);
            nUsersPerCell = length(obj.Cells(1).Users);
            lsfcs = zeros(nUsersPerCell, nCells, nCells);
            for jj = 1:nUsersPerCell
                for kk = 1:nCells
                    for ii = 1:nCells
                        lsfcs(jj, kk, ii) = obj.calculateLSFC(jj, kk, ii);
                    end
                end
            end
        end


        function trace = tracePerimeters(obj, onFigure)
            trace = obj.Cells.tracePerimeter(onFigure);
        end

        function zeta = pilotContaminationSeverity(obj, jj, kk, jj2, kk2)
            zeta = obj.calculateLSFC(jj2, kk2, jj) ^ 2 / ...
                obj.calculateLSFC(jj, kk, jj) ^ 2 + ...
                obj.calculateLSFC(jj, kk, jj2) ^ 2 / ...
                obj.calculateLSFC(jj2, kk2, jj2) ^ 2;
        end

        function zetas = pilotContaminationSeverities(obj, twoDimensional)
            k = length(obj.Cells(1).Users);
            l = length(obj.Cells);
            lsfc = obj.calculateLSFCs();
            if nargin > 1 && twoDimensional == true
                zetas = zeros(k*l, k*l);
                for jj = 1:k % Iterate over user in cell
                    for kk = 1:l % Iterate over cell
                        for jj2 = 1:k
                            if jj2 == jj
                                continue
                            end
                            for kk2 = 1:l
                                index1 = (kk - 1) * k + jj;
                                index2 = (kk2 - 1) * k + jj2;
                                zetas(index1, index2) = ...
                                    lsfc(jj2, kk2, jj) ^ 2 / ...
                                    lsfc(jj, kk, jj) ^ 2 + ...
                                    lsfc(jj, kk, jj2) ^ 2 / ...
                                    lsfc(jj2, kk2, jj2) ^ 2;
                            end
                        end
                    end
                end
            else
                zetas = zeros(k, l, k, l);
                for jj = 1:k
                    for kk = 1:l
                        for jj2 = 1:k
                            for kk2 = 1:l
                                zetas(jj, kk, jj2, kk2) = ...
                                    lsfc(jj2, kk2, jj) ^ 2 / ...
                                    lsfc(jj, kk, jj) ^ 2 + ...
                                    lsfc(jj, kk, jj2) ^ 2 / ...
                                    lsfc(jj2, kk2, jj2) ^ 2;
                            end
                        end
                    end
                end
            end
        end

        function zetas = fallbackPCS(obj)
            k = length(obj.Cells(1).Users);
            l = length(obj.Cells);
            zetas = zeros(k, l, k, l);
            for jj = 1:k
                for kk = 1:l
                    for jj2 = 1:k
                        for kk2 = 1:l
                            zetas(jj, kk, jj2, kk2) = obj.pilotContaminationSeverity(jj, kk, jj2, kk2);
                        end
                    end
                end
            end
        end
    end
end
