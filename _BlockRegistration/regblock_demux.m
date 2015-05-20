function sabt = regblock_demux
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Demux');

sabt.OutportStringMethod = @outport_string;

sabt.BlockSize = [5, 70];

sabt.DefaultParameters = {'DisplayOption', 'bar'};

sabt.LayoutSize.PortSpacing = 30;

sabt.PlusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '+', operand);
sabt.MinusMethod = @(blkhdl, operand) operator_plus_minus(blkhdl, '-', operand);
end

function str = outport_string(pthdl, appdata)
parblk = get_param(pthdl, 'Parent');
ptnum = get_param(pthdl, 'PortNumber');
instr = cellstr(appdata.Console.GetUpstreamString(parblk));
str = [instr, '_D', int2str(ptnum)];
end


function actrec = operator_plus_minus(blkhdl, operator, operand)
actrec = saRecorder;
output0 = str2double(get_param(blkhdl,'Outputs'));
if operator=='+' sn = 1;
else sn = -1;
end
if isempty(operand) % default add/minus 1
    output1 = output0 + sn;
else
    if isequal(operand, operator)
        output1 = max(output0 + sn, 1);
    else
        operand = str2double(operand);
        if isnan(operand) || isempty(operand)
            return;
        else
            output1 = max(output0 + sn*(operand), 1);
        end
    end
end
actrec.SetParam(blkhdl, 'Outputs', int2str(output1));
end