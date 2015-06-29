function [actrec, success] = multiprop(btobj, cmdstr, pattern, varargin)
% btobj.MajorProperty = {'PROP1','_SUFFIX1'; 'PROP2','_SUFFIX2'; 'PROP3','_SUFFIX3'}
% note that _SUFFIXN can be a function handle takes the basic string as input
actrec = saRecorder; success = false;
% parse input
cmdpsr = saCmdParser(cmdstr, pattern);
[vals, bclean] = cmdpsr.ParseMultiValues; % intended for no more that three values
if ~bclean
     [actrec, success] = deal(saRecorder, false); return;
end

propdef = btobj.MajorProperty;
pvpair = varargin; option = struct;
if isempty(vals)
elseif numel(vals)==1
    for i=1:size(propdef,1)
        if isstr(propdef{i,2})
            pvpair = [pvpair, propdef{i,1}, strcat(vals{1}, propdef{i,2})];
        else
            fh = propdef{i,2};
            pvpair = [pvpair, propdef{i,1}, fh(vals{1})];
        end
    end
    option.PropagateString = false; % turn off propagate behaviour to avoid override
else
    for i=1:numel(vals)
        pvpair = [pvpair, propdef{i,1}, vals{i}];
    end
    option.PropagateString = false; % turn off propagate behaviour to avoid override
end
actrec + btobj.GenericContextAdd(pvpair{:}, option);
success = true;
end