function redo_replace_block(obj)
blktyp = get_param(obj.Data.Path, 'BlockType');
blk = replace_block(obj.Data.Path, blktyp,obj.Data.NewBlockSrc, 'noprompt');
if iscell(blk)
    blk=blk{1};
end
obj.Handle = get_param(blk, 'Handle');
end