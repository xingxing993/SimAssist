function sabt = regblock_display
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Display');

sabt.RoutineType = 'value_num';
sabt.RoutinePattern = '^(disp|display)';


sabt.ConnectPort = [1, 0];
sabt.BlockSize = [90, 28];

sabt.LayoutSize.HorizontalMargin = 50;
sabt.LayoutSize.VerticalMargin = 50;

end