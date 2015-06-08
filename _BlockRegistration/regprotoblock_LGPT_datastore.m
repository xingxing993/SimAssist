function sabt = regprotoblock_LGPT_datastore
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saProtoBlock('LGPT_datastore');
sabt.ProtoCheckMethod = @check_proto;
sabt.ProtoProperty = {'MajorProperty', 'InportStringMethod', 'OutportStringMethod'};


sabt.MajorProperty = 'DataStoreName';

sabt.InportStringMethod = 'DataStoreName';
sabt.OutportStringMethod = 'DataStoreName';

end

function tf = check_proto(blkhdl)
msktyp = get_param(blkhdl, 'MaskType');
if ismember(msktyp, {'LGPT_DataReadWrite', 'LGPT_ReadArrayElement', 'LGPT_WriteArrayElement'})
    tf = true;
else
    tf = false;
end
end