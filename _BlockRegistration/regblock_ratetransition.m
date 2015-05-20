function sabt = regblock_ratetransition
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('RateTransition');
sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^(rate|ratetransation)';


sabt.MajorProperty = '';

sabt.BlockSize = [30, 30];

end