function undo_replace_block(obj)
blktyp = get_param(obj.Data.Path, 'BlockType');
blk = replace_block(obj.Data.Path, blktyp,obj.Data.OldBlockSrc, 'noprompt');
if iscell(blk)
    blk=blk{1};
end
obj.Handle = get_param(blk, 'Handle');
for i=1:size(obj.Property, 2)
    try
        set_param(obj.Data.Path, obj.Property{1,i}, obj.Property{2,i});
    end
end
end