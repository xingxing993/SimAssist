function [actrec, success] = majorprop_value(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
[result, bclean] = cmdpsr.ParseValueString;
if bclean
    if ~isempty(result)
        pvpair = {varargin{:}, btobj.MajorProperty, result};
    else
        pvpair = varargin;
    end
    actrec = btobj.GenericContextAdd(pvpair{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end