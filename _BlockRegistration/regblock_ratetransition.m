function sabt = regblock_ratetransition
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('RateTransition');
sabt.RoutineMethod = 'num_only';
sabt.RoutinePattern = '^(ratetrans|rate|rt)';


sabt.MajorProperty = '';

sabt.BlockSize = [30, 30];

end