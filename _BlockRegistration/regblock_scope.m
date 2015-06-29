function sabt = regblock_scope
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Scope');

sabt.RoutineMethod = @routine_scope;
sabt.RoutinePara.InportProperty = 'NumInputPorts';
sabt.RoutinePattern = '^scope';
sabt.RoutinePrompts = {'scope', 'scopes'};

sabt.ConnectPort = [1, 0];

sabt.MajorProperty = 'NumInputPorts';

sabt.InportStringMethod = @inport_string;

sabt.BlockSize = [30, 35];
sabt.AutoSizeMethod = @resize;

sabt.LayoutSize.HorizontalMargin = 25;
sabt.LayoutSize.PortSpacing = 15;
sabt.LayoutSize.ToLineOffset = [50 100];

sabt.DefaultParameters = {'LimitDataPoints', 'off'};
end

function actrec = resize(blkhdl, szlayout)
actrec = saRecorder;
ptcnt = get_param(blkhdl, 'Ports');

oldpos = get_param(blkhdl, 'Position');
h2 = (ptcnt(1)+1)*szlayout.PortSpacing+5; % ##
newpos = oldpos;
newpos(4) = newpos(2)+h2;
actrec.SetParam(blkhdl, 'Position', newpos);
end

function str = inport_string(pthdl)
parblk = get_param(pthdl, 'Parent');
parname = get_param(parblk, 'Name');
portnum = get_param(pthdl, 'PortNumber');
str = [parname, '_', int2str(portnum)];
end


function [actrec, success] =adder_scope(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Scope');
regtmp = regexp(cmdstr, '^scope(s)?\s*(\d*)', 'tokens','once');
optstr = strtrim(regexprep(cmdstr, '^scopes?\s*', ''));
if ~isempty(regtmp{1}) % if use single port scope
    actrec + Routines.num_only(btobj, optstr, '');
else
    actrec + Routines.dynamicinport(btobj, optstr, '');
end
success = true;
end