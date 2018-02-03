function sabt = regblock_constant
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Constant');

sabt.RoutineMethod = 'majorprop_value';
sabt.RoutinePattern = '^(constant|const|cnst)';

sabt.ConnectPort = [0, 1];

sabt.MajorProperty = 'Value';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateDownstreamStringMethod = @dwnstream_prop;
sabt.OutportStringMethod = @outportstr;
sabt.AnnotationMethod = 'DT: %<OutDataTypeStr>';
sabt.RefineMethod = @refine_constant;

sabt.BlockSize = [70, 25];
sabt.LayoutSize.CharWidth = 6;

sabt.AutoSizeMethod = -2; % leftwards expand to show string

sabt.DefaultDataType = 'Inherit: Inherit from ''Constant value''';
sabt.DataTypeMethod = -1;

sabt.GetBroMethod = @get_bro_blocks;
end


function actrec = refine_constant(blkhdl)
actrec = saRecorder;
actrec.SetParamHighlight(blkhdl, 'Name', get_param(blkhdl, 'Value'));
end

function broblks = get_bro_blocks(blkhdl)
parsys = get_param(blkhdl, 'Parent');
val = get_param(blkhdl,'Value');
broblks = find_system(parsys,'SearchDepth',1,'FindAll','on','FollowLinks','on','BlockType','Constant','Value',val);
end


function str = outportstr(hdl, appdata)
rawstr = get_param(get_param(hdl,'Parent'), 'Value');
str = regexprep(rawstr, '^K([A-Z]+_)', 'V$1');
end

function dwnstream_prop(blkhdl, instr)
valstr = regexprep(instr, '^V([A-Z]+_)', 'K$1');
set_param(blkhdl, 'Value',valstr);
end