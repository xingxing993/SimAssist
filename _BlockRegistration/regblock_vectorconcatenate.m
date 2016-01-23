function sabt = regblock_vectorconcatenate
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Concatenate');
sabt.RoutineMethod = 'dynamicinport';
sabt.RoutinePattern = '^vecconcat|concat';
sabt.RoutinePara.InportProperty = 'NumInputs';


sabt.OutportStringMethod = @inport_string;

sabt.SourcePath = 'Concatenate';
sabt.BlockSize = [5, 70];


sabt.LayoutSize.PortSpacing = 30;
sabt.PlusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '+', operand);
sabt.MinusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '-', operand);
sabt.AnnotationMethod = @annotate;
end

function str = inport_string(pthdl, appdata)
parblk = get_param(pthdl, 'Parent');
ptnum = get_param(pthdl, 'PortNumber');
outstr = cellstr(appdata.Console.GetDownstreamString(parblk));
str = [outstr, '_D', int2str(ptnum)];
end


function actrec = operator_plus_minus(blkhdl, operator, operand)
actrec = saRecorder;
input0 = str2double(get_param(blkhdl,'NumInputs'));
if operator=='+' sn = 1;
else sn = -1;
end
if isempty(operand) % default add/minus 1
    input1 = max(input0 + sn, 1);
    actrec.SetParam(blkhdl, 'NumInputs', int2str(input1));
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
            actrec.SetParam(blkhdl, 'NumInputs', int2str(input1));
            pts = get_param(blkhdl, 'PortHandles');% auto line
            actrec.MultiAutoLine(tgtobjs, pts.Inport(end-dn+1:end));
        end
        actrec.SetParam(blkhdl, 'NumInputs', int2str(input1));
    elseif operator=='-'&& isequal(operand, '-')
        input1 = max(input0 + sn, 1);
        actrec.SetParam(blkhdl, 'NumInputs', int2str(input1));
    else
        operand = str2double(operand);
        if isnan(operand) || isempty(operand)
            return;
        else
            input1 = max(input0 + sn*(operand), 1);
        end
        actrec.SetParam(blkhdl, 'NumInputs', int2str(input1));
    end
end
end

function actrec = annotate(blkhdl)
actrec = saRecorder;
numipt = get_param(blkhdl, 'NumInputs');
mode = get_param(blkhdl,'Mode');
dim  = get_param(blkhdl,'ConcatenateDimension');
if strcmp(mode, 'Vector')
    attrstr = '1D-Vector: %<NumInputs>*N';
else
    if dim=='1'
        attrstr = 'Matrix: [%<NumInputs>, N]';
    elseif dim=='2'
        attrstr = 'Matrix: [N, %<NumInputs>]';
    else
        attrstr = 'Matrix';
    end
end
actrec.SetParam(blkhdl, 'AttributesFormatString', attrstr);
end