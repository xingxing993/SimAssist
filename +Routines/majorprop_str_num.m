function [actrec, success] = majorprop_str_num(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
[result, bclean] = cmdpsr.ParseStringAndInteger;
if bclean
    if ~isempty(result.String)
        option.PropagateString = false;
        pvpair = {varargin{:}, btobj.MajorProperty, result.String};
    else
        option.PropagateString = true;
        pvpair = varargin;
    end
    actrec = btobj.GenericContextAdd(result.Integer, option, pvpair{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end