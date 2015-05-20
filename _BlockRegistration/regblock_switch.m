function sabt = regblock_switch
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Switch');

sabt.DefaultParameters = {'Criteria', 'u2 ~= 0'};

sabt.InportStringMethod = 1; % pass through
sabt.OutportStringMethod = 3; % pass through the 3rd inport

sabt.RefineMethod = @refine_method;
sabt.AnnotationMethod = '%<Criteria>';

sabt.ConnectPort = [2, 1];

sabt.BlockSize = [20, 60];

end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
actrec.SetParamHighlight(blkhdl,'Criteria','u2 ~= 0');
end