function sabt = regblock_sigconv
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('SignalConversion');
sabt.RoutineMethod = 'simple';
sabt.RoutinePattern = '^(sigconv|signalconv)';
sabt.BlockSize = [30, 30];
end