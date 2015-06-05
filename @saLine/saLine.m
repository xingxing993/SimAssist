classdef saLine < saObject
    %SA_SLBLOCK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        MajorProperty = 'Name';
        
        OutportStringMethod = 'Name';
        InportStringMethod = 'Name';
        
        SetPropertyMethod = 'Name';
        
    end
    
    properties (Constant)
        Dictionary = SACFG_DICTIONARY;
    end
    
    methods
        function obj = saLine(varargin)
            obj = obj@saObject('line');
            obj.MapKey = 'line';
        end

%         function lnhdls = RemoveChildren(obj,lnhdls)
%             lns = lnhdls(strcmp(get_param(lnhdls,'Type'),'line'));
%             lns_rmv = [];
%             for i=1:numel(lns)
%                 if ismember(get_param(lns(i),'LineParent'), objs)
%                     lns_rmv = [lns_rmv, lns(i)];
%                 end
%             end
%             lnhdls = setdiff(lnhdls, lns_rmv);
%         end
    end
end
