function [actrec, blkhdls] = AddBlockArray(obj, varargin)
% Similar to AddBlock except that this function creates array of blocks
% Order of different types of arguments is insignificant
% obj.AddBlockArray(N, ...);
% obj.AddBlockArray(startpos, N, ...);
% obj.AddBlockArray(startpos, N, blksize, ...);
% obj.AddBlockArray(N, startpos, 'PROP1', 'VAL1', ... blksize, ... POSTFUN);

actrec = saRecorder;blkhdls = [];

i_argnum = cellfun(@isnumeric, varargin);
argnum = varargin(i_argnum);
argnnum = varargin(~i_argnum);

iN = cellfun(@isscalar, argnum);
if isempty(iN)
    error('saBlock:AddBlockArray: Number of block must be specified');
    return;
else
    N = argnum{iN};
end

szpara = argnum(~iN); % the vector numeric paramters must be in "startpos, blksize" order
if numel(szpara)<2
    blksize = obj.GetBlockSize;
else
    blksize = szpara{2};
end
if numel(szpara)<1
    startpos = saGetMousePosition;
else
    startpos = szpara{1};
end

DH = obj.LayoutSize.VerticalMargin + blksize(2);
for i=1:N
    ltpos = startpos+[0, DH*(i-1)];
    blkpos = [ltpos, ltpos+blksize];
    [actrec2, blkhdl] = obj.AddBlock(blkpos, argnnum{:});  actrec + actrec2;
    blkhdls = [blkhdls; blkhdl];
end
end