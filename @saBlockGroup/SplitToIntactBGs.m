function objs=SplitToIntactBGs(obj)
objs=[];
if obj.BlockCount==0
    return;
end
blkset=obj.BlockHandles;
resid=blkset;
while ~isempty(resid)
    subbg=resid(1);
    expdedblks=resid(1);
    while ~isempty(expdedblks) %as long as expanded connected blocks found
        adjblkspool=[];
        for i=1:numel(expdedblks)
            tmpadjblks=GetAdjBlks(expdedblks(i));
            adjblkspool=[adjblkspool;tmpadjblks.SrcBlockHandles;tmpadjblks.DstBlockHandles]; %add to adjacent blocks pool
        end
        expdedblks=intersect(adjblkspool,resid); % inside the block group
        subbg=[subbg;expdedblks]; % add into sub block group
        resid=setdiff(resid,subbg); %discard from the residual blocks
    end
    objs=[objs;saBlockGroup(subbg)];
end
end