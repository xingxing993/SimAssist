function [actrec, success] = dynamicinport(btobj, cmdstr, pattern, varargin)
actrec = saRecorder;

cmdpsr = saCmdParser(cmdstr, pattern);
[numipt, bclean] = cmdpsr.ParseInteger;
if ~bclean
    [actrec, success] = deal(saRecorder, false);
    return;
end

if isempty(numipt)
    tgtobjs = saFindSystem(gcs,'line_sender');
    if isempty(tgtobjs)
        numipt = 1;  autoline = false;
    else
        numipt = int2str(numel(tgtobjs)); autoline = true;
    end
    [actrec2, block] = btobj.AddBlock(varargin{:}, btobj.RoutinePara.InportProperty, int2str(numipt));
    actrec + actrec2;
    if autoline
        actrec.MultiAutoLine(tgtobjs, block);
    end
else
    actrec + btobj.AddBlock(varargin{:}, btobj.RoutinePara.InportProperty, int2str(numipt));
end
success = true;
end