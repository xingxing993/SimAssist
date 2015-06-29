function sabt = regblock_buscreator
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('BusCreator');

sabt.RoutineMethod = 'dynamicinport';
sabt.RoutinePattern = '^(bc|buscreator)';
sabt.RoutinePara.InportProperty = 'Inputs';

sabt.ArrangePortMethod{1} = 1;

sabt.InportStringMethod = @getportstring_buscreator; % pass through the 3rd inport
sabt.PropagateDownstreamStringMethod = @propagate_downstream_buscreator;

sabt.BlockSize = [5, 70];

sabt.LayoutSize.PortSpacing = 30;

sabt.PlusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '+', operand);
sabt.MinusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '-', operand);

sabt.CleanMethod = @clean;
sabt.AutoSizeMethod = -1;
end

function actrec = clean(blkhdl)
actrec = saRecorder;
lns = get_param(blkhdl, 'LineHandles');
input1 = sum(lns.Inport>0);
actrec.SetParam(blkhdl, 'Inputs', int2str(input1));
end


function actrec = operator_plus_minus(blkhdl, operator, operand)
actrec = saRecorder;
input0 = str2double(get_param(blkhdl,'Inputs'));
if operator=='+' sn = 1;
else sn = -1;
end
if isempty(operand) % default add/minus 1
    input1 = max(input0 + sn, 1);
    actrec.SetParam(blkhdl, 'Inputs', int2str(input1));
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
            actrec.SetParam(blkhdl, 'Inputs', int2str(input1));
            pts = get_param(blkhdl, 'PortHandles');% auto line
            actrec.MultiAutoLine(tgtobjs, pts.Inport(end-dn+1:end));
        end
        actrec.SetParam(blkhdl, 'Inputs', int2str(input1));
    elseif operator=='-'&& isequal(operand, '-')
        input1 = max(input0 + sn, 1);
        actrec.SetParam(blkhdl, 'Inputs', int2str(input1));
    else
        operand = str2double(operand);
        if isnan(operand) || isempty(operand)
            return;
        else
            input1 = max(input0 + sn*(operand), 1);
        end
        actrec.SetParam(blkhdl, 'Inputs', int2str(input1));
    end
end
end


function thestr = getportstring_buscreator(pthdl)
ptnum = get_param(pthdl, 'PortNumber');
parblk = get_param(pthdl, 'Parent');
pttyp = get_param(pthdl, 'PortType');
bussigs = saBusTraceForward(parblk);
thestr = bussigs{min(ptnum, end)};
end


function actrec = propagate_downstream_buscreator(blkhdl)
actrec = saRecorder;
bussigs = saBusTraceForward(blkhdl);
if numel(bussigs)<1
    return;
else
    actrec.SetParam(blkhdl, 'Inputs', int2str(numel(bussigs)));
    oldpos=get_param(blkhdl,'Position');ht=oldpos(4)-oldpos(2);
    newht=max(20*numel(bussigs),ht); % line space at least 20
    newpos=[oldpos(1:3),oldpos(2)+newht];
    actrec.SetParam(blkhdl,'Position',newpos);
    lnhdls=get_param(blkhdl,'LineHandles');
    pthdls=get_param(blkhdl,'PortHandles');
    tmppos=get_param(pthdls.Inport(1),'Position');
    x_pt=max(tmppos(1)-150,0);
    for kk=1:numel(pthdls.Inport) %add line and name it for each inport
        if lnhdls.Inport(kk)>0
            actrec.SetParam(lnhdls.Inport(kk), 'Name', bussigs{kk});
        else
            ptpos=get_param(pthdls.Inport(kk),'Position');
            actrec.AddLine(gcs,[[x_pt,ptpos(2)];ptpos],bussigs{kk});
        end
    end
end
end
