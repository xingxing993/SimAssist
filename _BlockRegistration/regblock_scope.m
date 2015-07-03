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

sabt.PlusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '+', operand);
sabt.MinusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '-', operand);

sabt.ArrangePortMethod{1} = 1;
sabt.CleanMethod = @clean;

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


function [actrec, success] =routine_scope(cmdstr, console)
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

function actrec = operator_plus_minus(blkhdl, operator, operand)
actrec = saRecorder;
input0 = str2double(get_param(blkhdl,'NumInputPorts'));
if operator=='+' sn = 1;
else sn = -1;
end
if isempty(operand) % default add/minus 1
    input1 = max(input0 + sn, 1);
    actrec.SetParam(blkhdl, 'NumInputPorts', int2str(input1));
else
    if operator=='+'&& isequal(operand, '+') % '++' auto increase accroding to selection
        tgtobjs = saFindSystem(gcs,'line_sender');
        if isempty(tgtobjs)
            input1 = max(input0 + 1);
        else
            tmp=get_param(cellstr(get_param(tgtobjs,'Parent')), 'Handle');
            tgtobjs = setdiff([tmp{:}], blkhdl);
            dn = numel(tgtobjs);
            input1 = max(input0 + dn);
            actrec.SetParam(blkhdl, 'NumInputPorts', int2str(input1));
            pts = get_param(blkhdl, 'PortHandles');% auto line
            actrec.MultiAutoLine(tgtobjs, pts.Inport(end-dn+1:end));
        end
        actrec.SetParam(blkhdl, 'NumInputPorts', int2str(input1));
    elseif operator=='-'&& isequal(operand, '-')
        input1 = max(input0 + sn, 1);
        actrec.SetParam(blkhdl, 'NumInputPorts', int2str(input1));
    else
        operand = str2double(operand);
        if isnan(operand) || isempty(operand)
            return;
        else
            input1 = max(input0 + sn*(operand), 1);
        end
        actrec.SetParam(blkhdl, 'NumInputPorts', int2str(input1));
    end
end
end

function actrec = clean(blkhdl)
actrec = saRecorder;
lns = get_param(blkhdl, 'LineHandles');
input1 = sum(lns.Inport>0);
actrec.SetParam(blkhdl, 'NumInputPorts', int2str(input1));
end