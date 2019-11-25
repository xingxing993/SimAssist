function sabt = regblock_lookupnd
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Lookup_n-D');

sabt.RoutineMethod = @routine_lookupnd;
sabt.RoutinePattern = '^(lookup|lu|l)';
sabt.RoutinePriority = 60;

sabt.MajorProperty = {'BreakpointsForDimension1','_X';'Table',''};
sabt.DictRenameMethod = {'Table','BreakpointsForDimension1','BreakpointsForDimension2','BreakpointsForDimension3','BreakpointsForDimension4'};

sabt.DefaultParameters = {...
%     'AttributesFormatString', sprintf('X:%%<BreakpointsForDimension1>\nY:%%<Table>'), ...
    'ExtrapMethod','Clip'};

sabt.PropagateUpstreamStringMethod = @upstream_propagate;
sabt.PropagateDownstreamStringMethod = 'Table';
sabt.InportStringMethod = @getinportstring_lookupnd;
sabt.OutportStringMethod = 'Table';
sabt.AnnotationMethod = @lookupnd_annotation;
sabt.RefineMethod = @refine_method;

sabt.BlockPreferOption.Annotation = true; % turn on annotation for this block type
sabt.BlockPreferOption.Refine = false; % turn off refine to avoid evaluation error

sabt.BlockSize = [50, 50];
end

function actrec = upstream_propagate(blkhdl, instr)
actrec = saRecorder;
ndimstr = get_param(blkhdl, 'NumberOfTableDimensions');
if ndimstr=='1'
    actrec.SetParam(blkhdl, 'BreakpointsForDimension1', [instr, '_X'], 'Table', instr);
end
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tbl = get_param(blkhdl,'Table');
if ~isempty(tbl) && tbl(1)~='['
    actrec.SetParam(blkhdl, 'Name', sprintf('Lookup_%s',tbl));
    actrec.SetParam(blkhdl, 'BreakpointsForDimension1', [tbl, '_X']);
end
end

function [actrec, success] = routine_lookupnd(cmdstr, console)
actrec = saRecorder; success = false;
btobj = console.MapTo('Lookup_n-D');

cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
ndimstr = cmdpsr.OptionStr(1);
if isnan(str2double(ndimstr))
    success = false;
    return;
end


cmdpsr.OptionStr(1)=''; % remove dimension specification string (only '1' or '2' for now)
cmdpsr.OptionStr = strtrim(cmdpsr.OptionStr);
[vals, bclean] = cmdpsr.ParseMultiValues; % intended for no more that three values
if ~bclean
    [actrec, success] = deal(saRecorder, false); return;
end

pvpair = {'NumberOfTableDimensions', ndimstr};
% assign to lookup table value for different cases
if isempty(vals)
elseif numel(vals)==1
    if ndimstr=='1'
        pvpair =[pvpair, 'Table', vals{1}, ...
            'BreakpointsForDimension1', [vals{1}, '_X']];
    elseif ndimstr == '2'
        pvpair =[pvpair, 'Table', vals{1}, ...
            'BreakpointsForDimension1', [vals{1}, '_X'], ...
            'BreakpointsForDimension2', [vals{1}, '_Y']];
    else
    end
elseif numel(vals)==2
    if ndimstr=='1'
        pvpair =[pvpair, 'Table', vals{1}, ...
            'BreakpointsForDimension1', vals{2}];
    elseif ndimstr == '2'
        pvpair =[pvpair, 'Table', vals{1}, ...
            'BreakpointsForDimension1', [vals{2}, '_X'], ...
            'BreakpointsForDimension2', [vals{2}, '_Y']];
    else
    end
elseif numel(vals)==3
    if ndimstr=='1'
        pvpair =[pvpair, 'Table', vals{1}, ...
            'BreakpointsForDimension1', vals{2}];
    elseif ndimstr == '2'
        pvpair =[pvpair, 'Table', vals{1}, ...
            'BreakpointsForDimension1', vals{2}, ...
            'BreakpointsForDimension2', vals{3}];
    else
    end
else
end
actrec + btobj.GenericContextAdd(pvpair{:});
success = true;

end

function thestr = getinportstring_lookupnd(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
thestr = get_param(parblk, ['BreakpointsForDimension', int2str(ptnum)]);
end

function lookupnd_annotation(blkhdl)
actrec = saRecorder;
ndimstr = get_param(blkhdl, 'NumberOfTableDimensions');
if ndimstr=='1'
    attrstr = sprintf('X:%%<BreakpointsForDimension1>\nY:%%<Table>');
elseif ndimstr=='2'
    attrstr = sprintf('X:%%<BreakpointsForDimension1>\nY:%%<BreakpointsForDimension2>\nZ:%%<Table>');
else
end
actrec.SetParam(blkhdl, 'AttributesFormatString', attrstr);
end

