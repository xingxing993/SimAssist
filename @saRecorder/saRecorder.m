classdef saRecorder < handle
    properties
        ActionList
    end
    methods
        function obj = saRecorder(varargin)
            obj.ActionList = [];
        end
        
        function tf = isempty(obj)
            tf = isempty(obj.ActionList);
        end
    end %methods
end %classdef




