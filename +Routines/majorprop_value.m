function [actrec, success] = majorprop_value(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
[result, bclean] = cmdpsr.ParseValueString;
if bclean
    if ~isempty(result)
        option.PropagateString = false;
        pvpair = {varargin{:}, btobj.MajorProperty, result};
    else
        option = struct;
        pvpair = varargin;
    end
    actrec = btobj.GenericContextAdd(option, pvpair{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end