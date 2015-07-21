function sabt = regblock_switch
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Switch');

sabt.RoutinePattern = '^(switch|sw)';
sabt.RoutineMethod = @routine_switch;

sabt.DefaultParameters = {'Criteria', 'u2 ~= 0'};

sabt.InportStringMethod = 1; % pass through
sabt.OutportStringMethod = 3; % pass through the 3rd inport

sabt.RefineMethod = @refine_method;
sabt.AnnotationMethod = '%<Criteria>';
sabt.DataTypeMethod = [];

sabt.ConnectPort = [2, 1];

sabt.BlockSize = [20, 60];

end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
actrec.SetParamHighlight(blkhdl,'Criteria','u2 ~= 0');
end


function [actrec, success] =routine_switch(cmdstr, console)
btobj = console.MapTo('Switch');
bkup = btobj.ConnectPort;

cmdpsr = saCmdParser(cmdstr, btobj.RoutinePattern);
if ismember(cmdpsr.OptionStr, {'1', '3'})
    btobj.ConnectPort = [str2double(cmdpsr.OptionStr), 1];
else
    if isempty(cmdpsr.OptionStr)||isequal(cmdpsr.OptionStr,'2')
        btobj.ConnectPort(2)=0; % disable insert to line behavior
    else
        [actrec, success] = deal(saRecorder, false); return;
    end
end
[actrec, success] = Routines.simple(btobj, '', '');
btobj.ConnectPort = bkup; % RESTORE
end