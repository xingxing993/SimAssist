function sabt = regblock_datastoreread
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('DataStoreRead');
sabt.RoutineType = 'value_num';

%bro-block properties
sabt.BroBlockType = {'DataStoreWrite', 'DataStoreMemory'};
sabt.CreateBroBlockMethod = -1;
sabt.ConnectPort = [0, 1];

sabt.MajorProperty = 'DataStoreName';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateDownstreamStringMethod = 'DataStoreName';
sabt.OutportStringMethod = 'DataStoreName';

sabt.BlockSize = [100, 30];
sabt.LayoutSize.CharWidth = 6;

sabt.AutoSizeMethod = -2; % leftwards expand to show string

sabt.GetBroMethod = @saFindBroBlocks;
end