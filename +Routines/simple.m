function [actrec, success] = simple(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
bclean = isempty(cmdpsr.OptionStr);
if bclean
    actrec = btobj.GenericContextAdd(varargin{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end