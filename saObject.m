classdef saObject < handle
    %SA_SLOBJECT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Console % Console object
        MapKey % Unique key in the collected map
        
        ObjectType
    end
    
    methods
        function obj = saObject(varargin)
            obj.ObjectType = varargin{1};
        end
        
        function tf = isa(obj, type)
            tf = strcmpi(obj.ObjectType, type);
        end
    end
    
end

