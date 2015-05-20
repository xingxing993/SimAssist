function sabt = regblock_sum
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Sum');

sabt.MajorProperty = 'Inputs';

sabt.OutportStringMethod = 1;
sabt.InportStringMethod = 1;

sabt.BlockSize = [25, 70];
sabt.AutoSizeMethod = -1;

sabt.LayoutSize.PortSpacing = 35;
sabt.LayoutSize.ToLineOffset = [50 100];
end
