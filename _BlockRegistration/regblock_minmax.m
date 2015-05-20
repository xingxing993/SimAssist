function sabt = regblock_minmax
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('MinMax');
sabt.RoutineType = 'dynamicinport';
sabt.RoutinePara.InportProperty = 'Inputs';

sabt.MajorProperty = 'Function';
sabt.ArrangePortMethod{1} = 1;
sabt.RollPropertyMethod = -1;

btlogic = regblock_logic;

sabt.Inherit(btlogic,...
    'BlockSize', 'AutoSizeMethod', 'LayoutSize', 'PlusMethod', 'MinusMethod','CleanMethod');

end
