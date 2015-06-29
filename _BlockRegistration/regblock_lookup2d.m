function sabt = regblock_lookup2d
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Lookup2D');
sabt.RoutineMethod = 'multiprop';
sabt.RoutinePattern = '^(l2|lookup2d|lu2d)';



sabt.ConnectPort = [0, 1];
sabt.MajorProperty = {'Table',''; 'RowIndex','_X';'ColumnIndex','_Y'};
sabt.DictRenameMethod = {'Table','RowIndex','ColumnIndex'};
sabt.DefaultParameters = {...
    'AttributesFormatString', sprintf('X:%%<x>\nY:%%<y>\nZ:%%<t>'), ...
    'LookUpMeth','Interpolation-Use End Values'};


sabt.PropagateUpstreamStringMethod = [];
sabt.PropagateDownstreamStringMethod = 'Table';
sabt.InportStringMethod = @inport_string;
sabt.OutportStringMethod = 'Table';
sabt.AnnotationMethod = sprintf('X:%%<x>\nY:%%<y>\nZ:%%<t>');
sabt.RefineMethod = @refine_method;

sabt.BlockSize = [50, 50];
sabt.AutoSizeMethod = [];

sabt.BlockPreferOption.Annotation = true; % turn on annotation for this block type
sabt.BlockPreferOption.Refine = false; % turn off refine to avoid evaluation error
sabt.BlockPreferOption.AutoSize = false; % turn off refine to avoid evaluation error

sabt.DefaultDataType = 'Inherit: Same as first input';

end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
tbl = get_param(blkhdl,'Table');
if ~isempty(tbl) && tbl(1)~='['
    actrec.SetParam(blkhdl, 'Name', sprintf('Lookup_%s',tbl));
    actrec.SetParam(blkhdl, 'RowIndex', [tbl, '_X'], 'ColumnIndex', [tbl, '_Y']);
end
end


function thestr = inport_string(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
if ptnum==1
    thestr = get_param(parblk,'RowIndex');
elseif ptnum==2
    thestr = get_param(parblk,'ColumnIndex');
else
end
end