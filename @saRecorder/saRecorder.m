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
        
        function Dummy(obj)
            sa = saAction('Dummy');
            obj.PushItem(sa);
        end
    end %methods
end %classdef




