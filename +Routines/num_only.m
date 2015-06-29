function [actrec, success] = num_only(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
[num, bclean] = cmdpsr.ParseInteger;
if bclean
    actrec = btobj.GenericContextAdd(num, varargin{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end