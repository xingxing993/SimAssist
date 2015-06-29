function sabt = regblock_datatypeconversion
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('DataTypeConversion');

% routine definition
sabt.RoutinePattern = '^(dt|datatype)';
sabt.RoutineMethod = 'num_only';



sabt.MajorProperty = 'OutDataTypeStr';

sabt.DefaultDataType = 'Inherit: Inherit via back propagation';
sabt.DataTypeMethod = -1;

sabt.BlockSize = [70, 18];

end