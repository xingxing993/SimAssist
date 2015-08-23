function [actrec, success] = majorprop_value(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
[result, bclean] = cmdpsr.ParseMultiValues;
if bclean
    if ~isempty(result)
        option.PropagateString = false;
        if numel(result)==1
            pvpair = {varargin{:}, btobj.MajorProperty, result{1}};
        else
            pvpair = {varargin{:}, btobj.MajorProperty, result};
        end
    else
        option = struct;
        pvpair = varargin;
    end
    num = numel(result);
    actrec = btobj.GenericContextAdd(num, option, pvpair{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end