classdef Network
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Cells = [];
    end
    
    methods
        function obj = Network(r, k, l)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Cells = NetworkCell(r, k, l);
        end

        function users = getUsers(obj)
            nUsers = cumsum([obj.Cells.nUsers()]);
            shift = [0, nUsers(1:end-1)];
            users = zeros(nUsers(end), 2);
            for ii = 1:length(obj.Cells)
                users(shift(ii)+1:nUsers(ii), :) = obj.Cells(ii).Users;
            end
        end
    end
end

