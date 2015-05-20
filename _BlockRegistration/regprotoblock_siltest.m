function sabt = regprotoblock_siltest
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saProtoBlock('ricardo_siltest');
sabt.CheckMethod = @check_proto;
sabt.ProtoProperty = {'MajorProperty', 'InportStringMethod', 'OutportStringMethod',...
    'PropagateUpstreamStringMethod', 'PropagateDownstreamStringMethod'};

sabt.MajorProperty = 'varname';

sabt.InportStringMethod = 'varname';
sabt.OutportStringMethod = 'varname';
sabt.PropagateUpstreamStringMethod = @set_string;
sabt.PropagateDownstreamStringMethod = @set_string;
end

function tf = check_proto(blkhdl)
msktyp = get_param(blkhdl, 'MaskType');
if ~isempty(regexp(msktyp,'^Test\s', 'once'))
    tf = true;
else
    tf = false;
end
end


function actrec = set_string(blkhdl, str)
actrec = saRecorder;
objparas = get_param(blkhdl, 'ObjectParameters');
if isfield(objparas, 'varname')
    actrec.SetParam(blkhdl, 'varname', str);
end
end