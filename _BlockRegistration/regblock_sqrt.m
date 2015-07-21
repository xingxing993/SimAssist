function sabt = regblock_sqrt
%REGTYPE_???
% Registration of ??? type in SimAssist
if verLessThan('matlab', '7.14')
    sabt = [];
    return;
end

sabt = saBlock('Sqrt');

sabt.RoutinePattern = '^sqrt';
sabt.RoutineMethod = 'num_only';


sabt.BlockSize = [30, 30];

end