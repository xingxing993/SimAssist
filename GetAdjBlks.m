function adjblks=GetAdjBlks(tgtblk)
if tgtblk<0
    adjblks=struct('SrcBlockHandles',[],'DstBlockHandles',[]);
    return;
end
ln=get_param(tgtblk,'LineHandles');
adjblks=struct();
srcblks=[];dstblks=[];
for i=1:numel(ln.Inport)
    if ln.Inport(i)>0
        srcblk=get_param(ln.Inport(i),'SrcBlockHandle');
        srcblks=[srcblks;srcblk];
    end
end
for i=1:numel(ln.Outport)
    if ln.Outport(i)>0
        dstblk=get_param(ln.Outport(i),'DstBlockHandle');
        dstblks=[dstblks;dstblk];
    end
end
adjblks.SrcBlockHandles=unique(srcblks(srcblks>0));
adjblks.DstBlockHandles=unique(dstblks(dstblks>0));