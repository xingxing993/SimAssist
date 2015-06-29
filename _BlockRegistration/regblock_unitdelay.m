function sabt = regblock_unitdelay
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('UnitDelay');

sabt.RoutineMethod = 'majorprop_value';
sabt.RoutinePattern = '^(ud|dly|unitdelay)';


sabt.MajorProperty = 'X0';
sabt.AnnotationMethod = 'Init: %<X0>';

sabt.BlockSize = [35, 34];
sabt.DataTypeMethod = -1;

sabt.DefaultParameters = {'SampleTime', '-1', 'AttributesFormatString', 'Init: %<X0>'};

end