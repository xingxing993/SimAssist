function sabt = regblock_relationaloperator
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saBlock('RelationalOperator');

sabt.MajorProperty = 'Operator';
sabt.RollPropertyMethod = -1;

sabt.BlockPreferOption.AutoDataType = false;

sabt.BlockSize = [25, 70];

sabt.AutoSizeMethod = []; % no need for auto size

end