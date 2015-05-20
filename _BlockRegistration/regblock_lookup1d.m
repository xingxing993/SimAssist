function sabt = regblock_lookup1d
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Lookup');

sabt.RoutineType = 'multiprop';
sabt.RoutinePattern = '^(l1|lookup|lu1d)';

sabt.MajorProperty = {'Table','';'InputValues','_X'};
sabt.DictRenameMethod = {'Table','InputValues'};

sabt.DefaultParameters = {...
    'AttributesFormatString', sprintf('X:%%<InputValues>\nY:%%<Table>'), ...
    'LookUpMeth','Interpolation-Use End Values'};

sabt.PropagateUpstreamStringMethod = @upstream_propagate;
sabt.PropagateDownstreamStringMethod = 'Table';
sabt.InportStringMethod = 'InputValues';
sabt.OutportStringMethod = 'Table';
sabt.AnnotationMethod = sprintf('X:%%<InputValues>\nY:%%<Table>');
sabt.RefineMethod = @refine_method;

sabt.BlockPreferOption.Annotation = true; % turn on annotation for this block type
sabt.BlockPreferOption.Refine = false; % turn off refine to avoid evaluation error

sabt.BlockSize = [50, 50];

sabt.DefaultDataType = 'Inherit: Same as input';

end

function actrec = upstream_propagate(blkhdl, instr)
actrec = saRecorder;
actrec.SetParam(blkhdl, 'InputValues', [instr, '_X'], 'Table', instr);
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tbl = get_param(blkhdl,'Table');
if ~isempty(tbl) && tbl(1)~='['
    actrec.SetParam(blkhdl, 'Name', sprintf('Lookup_%s',tbl));
    actrec.SetParam(blkhdl, 'InputValues', [tbl, '_X']);
end
end