function sabt = regblock_interpnd
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('Interpolation_n-D');

sabt.ConnectPort = [0, 0];

sabt.MajorProperty = 'Table';
sabt.DictRenameMethod = {'Table'};
sabt.DefaultParameters = {'AttributesFormatString','%<Table>','ExtrapMethod','None - Clip'};

sabt.LayoutSize.PortSpacing = 15;

sabt.PropagateDownstreamStringMethod = 'Table';
sabt.OutportStringMethod = 'Table';
sabt.AnnotationMethod = sprintf('%%<Table>');

sabt.BlockSize = [50, 50];

end
