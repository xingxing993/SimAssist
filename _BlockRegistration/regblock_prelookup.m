function sabt = regblock_prelookup
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('PreLookup');
sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^(pl|prelookup)';


sabt.ConnectPort = [1, 0];

sabt.MajorProperty = 'BreakpointsData';
sabt.DictRenameMethod = {'BreakpointsData'};
sabt.DefaultParameters = {...
    'AttributesFormatString',sprintf('%%<BreakpointsData>\n%%<IndexSearchMethod>'),...
    'BeginIndexSearchUsingPreviousIndexResult','on',...
    'ProcessOutOfRangeInput','Clip to range'};

sabt.PropagateUpstreamStringMethod = 'BreakpointsData';
sabt.OutportStringMethod = @outport_string;
sabt.AnnotationMethod = sprintf('%%<BreakpointsData>\n%%<IndexSearchMethod>');

sabt.BlockSize = [80, 40];

end


function outstr = outport_string(pthdl)
parblk = get_param(pthdl, 'Parent');
ptnum = get_param(pthdl, 'PortNumber');
suffix = {'_k','_f'};
bpname = get_param(parblk, 'BreakpointsData');
outstr = [bpname, suffix{ptnum}];
end