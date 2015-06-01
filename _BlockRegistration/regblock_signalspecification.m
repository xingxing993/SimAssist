function sabt = regblock_signalspecification
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('SignalSpecification');

sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^sigspec';

sabt.DefaultDataType = 'Inherit: auto';
sabt.DataTypeMethod = -1;

sabt.BlockSize = [70, 18];

end