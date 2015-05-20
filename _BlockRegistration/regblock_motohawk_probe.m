function sabt = regblock_motohawk_probe
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('MotoHawk_lib/Calibration & Probing Blocks/motohawk_probe');

sabt.ConnectPort = [1, 0];

sabt.MajorProperty = 'nam';
sabt.DictRenameMethod = {'nam'};

parbt = regprotoblock_motohawk_general;
sabt.Inherit(parbt, ...
    'InportStringMethod',...
    'OutportStringMethod',...
    'PropagateUpstreamStringMethod',...
    'RefineMethod');

sabt.BlockSize = [20, 25];
sabt.LayoutSize.CharWidth = 6;
sabt.AutoSizeMethod = -3; % rightwards expand to show string
end