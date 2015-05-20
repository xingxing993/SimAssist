function sabt = regblock_datatypeconverstion
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('DataTypeConversion');

sabt.MajorProperty = 'OutDataTypeStr';

sabt.DefaultDataType = 'Inherit: Inherit via back propagation';
sabt.DataTypeMethod = -1;

sabt.BlockSize = [70, 18];

end