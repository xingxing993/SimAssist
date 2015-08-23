function [actrec, success] = majorprop_str_num(btobj, cmdstr, pattern, varargin)
cmdpsr = saCmdParser(cmdstr, pattern);
[result, bclean] = cmdpsr.ParseValuesAndInteger;
if bclean
    if ~isempty(result.Values)
        option.PropagateString = false;
        if numel(result.Values)==1
            pvpair = {varargin{:}, btobj.MajorProperty, result.Values{1}};
        else
            pvpair = {varargin{:}, btobj.MajorProperty, result.Values};
        end
    else
        option.PropagateString = true;
        pvpair = varargin;
    end
    if isempty(result.Integer) n0 = 0;
    else n0 = result.Integer;
    end
    num = max(n0,numel(result.Values));
    actrec = btobj.GenericContextAdd(num, option, pvpair{:});
    success = true;
else
    [actrec, success] = deal(saRecorder, false);
end
end