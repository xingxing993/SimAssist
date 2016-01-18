classdef saAnnotation < saObject
    %SA_SLBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MajorProperty = 'Text';
        SetPropertyMethod = 'Text';
    end
    
    properties (Constant)
        Dictionary = SACFG_DICTIONARY;
    end
    
    methods
        function obj = saAnnotation(varargin)
            obj = obj@saObject('annotation');
            obj.MapKey = 'annotation';
        end

        function actrec = DictRename(obj, hdl)
            %
            actrec = saRecorder;
            nam=get_param(hdl,'Text');
            newnam=saDictRenameString(nam,obj.Dictionary);
            actrec.SetParam(hdl, 'Text', newnam);
        end
        
        function actrec = ReplaceStr(obj, hdl, oldstr, newstr)
            %
            actrec = saRecorder;
            nam = get_param(hdl, 'Text');
            if isempty(nam)
                return;
            end
            if strcmp(oldstr, '^') % add prefix
                newnam = [newstr, nam];
            elseif strcmp(oldstr, '$') % append suffix
                newnam = [nam, newstr];
            else
                newnam = regexprep(nam, oldstr, newstr);
            end
            actrec.SetParam(hdl, 'Text',newnam);
        end
    end
end
