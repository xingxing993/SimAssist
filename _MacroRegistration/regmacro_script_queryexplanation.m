function sam = regmacro_script_queryexplanation
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_queryexplanation');
sam.Pattern = '^\?';
sam.Callback = @script_queryexplanation;

end

function [actrec, success] =script_queryexplanation(cmdstr, console)
actrec=saRecorder;success = false;

nameprop={
    'Constant',     'Value';
    'Goto',         'GotoTag';
    'From',         'GotoTag';
    'SubSystem',    'Name';
    'Lookup',       'Table';
    'Lookup2D',     'Table';
    'UnitDelay',    'X0';
    'Interpolation_n-D','Table';
    'Prelookup',    'BreakpointsData';
    'Inport',       'Name';
    'Outport',      'Name';
    'DataStoreMemory', 'DataStoreName';
    'DataStoreWrite', 'DataStoreName';
    'DataStoreRead', 'DataStoreName';
    };
blktype=get_param(gcb,'BlockType');
p=nameprop(strcmp(blktype, nameprop(:,1)),:);
opt = strtrim(cmdstr(2:end));
if ~isempty(opt) && opt(1) == '>' % > means modify the block annotation
    opt = opt(2:end);
    opt_anno = true;
else
    opt_anno = false;
end
if ~isempty(p)||~isempty(opt)
    inca = []; idxtry = 1;
    incavers = {'INCA.INCA', 'INCA.INCA.6', 'INCA.INCA.7', 'INCA.INCA.8'};
    while isempty(inca) && idxtry<numel(incavers)
        try
            inca=actxserver(incavers{idxtry});
        end
    end
    if isempty(inca) return; end
    exp=inca.GetOpenedExperiment;
    if isempty(exp) return; end
    if ~isempty(opt)
        elname = opt;
    else
        elname = get_param(gcbh,p{2});
    end
    el = exp.GetExperimentElement(elname);
    if ~isempty(el)
        desc = el.GetAsap2Label.GetComment;
        h=helpdlg(desc);
        set(h,'Units','normalized');
        pos=get(h,'Position');
        pos(1:2)=[0.4,0.6];
        set(h,'Position',pos);
        if opt_anno
            actrec.SetParam(gcbh, 'AttributesFormatString',desc);
        end
    end
end
success = true;
end