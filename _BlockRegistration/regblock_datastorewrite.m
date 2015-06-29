function sabt = regblock_datastorewrite
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('DataStoreWrite');

% routines for DataStore family are combined as a seperate macro, see macro
% registration file
sabt.RoutinePattern = '';

% bro-block properties
sabt.BroBlockType = {'DataStoreRead', 'DataStoreMemory'};
sabt.CreateBroBlockMethod = -1;
sabt.ConnectPort = [1, 0];

sabt.MajorProperty = 'DataStoreName';
sabt.DictRenameMethod = 1; % use major property

sabt.PropagateUpstreamStringMethod = 'DataStoreName';
sabt.OutportStringMethod = 'DataStoreName';

sabt.BlockSize = [100, 30];
sabt.LayoutSize.CharWidth = 6;

sabt.AutoSizeMethod = -3; % rightwards expand to show string

sabt.GetBroMethod = @saFindBroBlocks;
end

