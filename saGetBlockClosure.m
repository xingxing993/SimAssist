function blkgrps=saGetBlockClosure(tgtblk,direction);
if isstr(tgtblk)
    tgtblk=get_param(tgtblk,'Handle');
end
blkgrps=tgtblk;
adjblks=GetAdjBlks(tgtblk);
if strcmpi(direction,'Left')
    adjblks=adjblks.SrcBlockHandles;
else
    adjblks=adjblks.DstBlockHandles;
end
intactblks=adjblks(isintact(adjblks,direction));
for i=1:numel(intactblks)
    blkgrps=[blkgrps;saGetBlockClosure(intactblks(i),direction)];
end


function bItct=isintact(blkhdls,direction)
bItct=~boolean(blkhdls);
for i=1:numel(blkhdls)
    adjblks=GetAdjBlks(blkhdls(i));
    if strcmpi(direction,'Left')
        if numel(adjblks.DstBlockHandles)==1
            bItct(i)=boolean(1);
        elseif numel(adjblks.DstBlockHandles)==2
            if ismember('Goto',get_param(adjblks.DstBlockHandles,'BlockType'))
                bItct(i)=boolean(1);
            end
        end
    else
        if numel(adjblks.SrcBlockHandles)==1
            bItct(i)=boolean(1);
        elseif numel(adjblks.SrcBlockHandles)==2
            if ismember('From',get_param(adjblks.SrcBlockHandles,'BlockType'))
                bItct(i)=boolean(1);
            end
        end
    end
end
