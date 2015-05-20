function sabt = regblock_motohawk_calibration
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('MotoHawk_lib/Calibration & Probing Blocks/motohawk_calibration');

sabt.ConnectPort = [0, 1];
sabt.MajorProperty = 'nam';
sabt.DictRenameMethod = {'nam', 'val'};

parbt = regprotoblock_motohawk_general;
sabt.Inherit(parbt, ...
    'PropagateDownstreamStringMethod',...
    'RefineMethod',...
    'DataTypeMethod');

sabt.InportStringMethod = 'val';
sabt.OutportStringMethod = 'val';

sabt.BlockSize = [20, 25];
sabt.LayoutSize.CharWidth = 8;
sabt.AutoSizeMethod = -2; % rightwards expand to show string
end