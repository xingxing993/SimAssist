function sabt = regblock_triggerport
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('TriggerPort');
sabt.RoutineType = 'value_only';

sabt.BlockSize = [20, 20];
sabt.BlockPreferOption.ShowName = 'on';

sabt.DefaultParameters = {'TriggerType', 'function-call'};


end