classdef saBlock < saProtoBlock
    %SA_SLBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        BlockType
        PropertyList % in order
               
        % PROPERTIES USED IN ADD OPERATION
        SourcePath
        DefaultParameters = {} %{PROP1, VALUE1, PROP2, VALUE2, ...}
    end
    
    methods
        function obj = saBlock(varargin) %{BlockType, MaskType}
            % Syntax summary: 
            % obj = saBlock(blocktype);
            % obj = saBlock(blockpath);
            % obj = saBlock(blockhandle);
            obj.ObjectType = 'block';
            % if given both block type and mask type
            if isstr(varargin{1})&&isempty(strfind(varargin{1}, '/')) % BlockType
                if ~strcmp(varargin{1}, '#NO_MATCH#')
                    obj.MapKey = varargin{1};
                    obj.SourcePath = varargin{1}; % built-in blocks
                    obj.BlockType = varargin{1};
                else
                    obj.MapKey = '#NO_MATCH#';
                    obj.SourcePath = '';
                    obj.BlockType = '';
                end
            else % Handle or SourcePath
                mapkey = saGetBlockMapKey(varargin{1});
                if ~isempty(mapkey)
                    obj.MapKey = mapkey;
                else % failed to locate the block, return an empty object
                    return;
                end
                obj.BlockType = get_param(varargin{1}, 'BlockType');
                refblk = get_param(varargin{1}, 'ReferenceBlock');
                if isempty(refblk)
                    obj.SourcePath = getfullname(varargin{1});
                else
                    obj.SourcePath = refblk;
                end
            end
            obj.InitializeProperties;
        end
        
        %%
        function InitializeProperties(obj)
            srcpath = obj.GetSourcePath;
            if isempty(srcpath) return; end
            % MajorProperty
            dlgparas = get_param(srcpath,'DialogParameters');
            if ~isempty(dlgparas)
                dlgparas = fieldnames(dlgparas);
            else
                dlgparas={};
            end
            if ~isempty(dlgparas)
                obj.MajorProperty = dlgparas{1};
            end
            % ConnectPort
            ptcnts = get_param(srcpath, 'Ports');
            obj.ConnectPort = double(logical(ptcnts(1:2)));
        end
        %%
        function Inherit(obj, parobj, varargin)
            if isempty(varargin)
                props = fieldnames(obj);
            else
                props = varargin;
            end
            props = setdiff(props,...
                {'MapKey', 'BlockType','SourcePath',...
                'Dictionary','ShowWaitbarThreshold', 'StrReplaceDefaults'});
            flds = fieldnames(parobj);
            for i=1:numel(props)
                if ismember(props{i}, flds)
                    obj.(props{i}) = parobj.(props{i});
                end
            end
        end
        %%
        function UseProto(obj, protoobj)
            obj.Inherit(protoobj, protoobj.ProtoProperty{:});
        end
    end
end
