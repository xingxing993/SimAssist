function blksize = GetBlockSize(obj)
if isempty(obj.BlockSize)
    tmppos = get_param(obj.GetSourcePath, 'Position');
    blksize = tmppos(3:4) - tmppos(1:2);
else
    blksize = obj.BlockSize;
end
end