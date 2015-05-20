function sabt = regblock_merge
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Merge');
sabt.RoutineType = 'dynamicinport';
sabt.RoutinePattern = '^(mg|merge)';
sabt.RoutinePara.InportProperty = 'Inputs';

sabt.OutportStringMethod = 1;

sabt.ArrangePortMethod{1} = 1;

sabt.MajorProperty = 'Inputs';

sabt.BlockSize = [25, 70];
sabt.AutoSizeMethod = -1;

sabt.LayoutSize.PortSpacing = 35;
sabt.LayoutSize.ToLineOffset = [50 100];

parbt = regblock_buscreator;
sabt.Inherit(parbt, 'PlusMethod', 'MinusMethod', 'CleanMethod');

end