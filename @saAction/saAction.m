classdef saAction < handle
    properties
        Type = ''
        Handle = -1
        Property = []
        OldValue = ''
        NewValue = ''
        Data = []
    end
    methods
        function obj=saAction(type, varargin)
            obj.Type=type;
            if nargin<2
                return;
            end
            switch obj.Type
                case 'set_param'
                    obj.set_param(varargin{:});
                case 'set_param_stateflow'
                    obj.set_param_stateflow(varargin{:});
                case 'add_block'
                    obj.add_block(varargin{:});
                case 'add_line'
                    obj.add_line(varargin{:});
                case 'delete_line'
                    obj.delete_line(varargin{:});
                case 'replace_block'
                    obj.replace_block(varargin{:});
                otherwise
            end
        end
    end
    methods(Access = private)
        set_param(obj,varargin)
        set_param_stateflow(obj,varargin)
        add_block(obj,varargin)
        add_line(obj, sys, varargin)
        replace_block(obj,varargin)
        delete_line(obj,varargin)
        
        undo_delete_line(obj)
        undo_set_param(obj)
        undo_set_param_stateflow(obj)
        undo_add_block(obj)
        undo_add_line(obj)
        undo_replace_block(obj)
        
        redo_set_param(obj)
        redo_delete_line(obj)
        redo_replace_block(obj)
        redo_set_param_stateflow(obj)
        redo_add_block(obj)
        redo_add_line(obj)
    end
end

