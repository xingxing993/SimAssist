function actrec=saLayoutAroundBlock(tgtblk)
actrec=saRecorder;
adjblks=GetAdjBlks(tgtblk);
BGleft=saBlockGroup;BGright=saBlockGroup;BigBG=saBlockGroup(tgtblk);
for i=1:numel(adjblks.SrcBlockHandles)
    BGleft(i)=saBlockGroup(saGetBlockClosure(adjblks.SrcBlockHandles(i),'left'));
end
for i=1:numel(adjblks.DstBlockHandles)
    BGright(i)=saBlockGroup(saGetBlockClosure(adjblks.DstBlockHandles(i),'right'));
end
if ~isempty(BGleft)
    actrec.Merge(BGleft.AlignPortsInside);
    actrec.Merge(BGleft.StraightenLinesInside);
    actrec.Merge(BGleft.AlignPortsOutside);
    actrec.Merge(BGleft.BGArrayUnion.VerticalAlign);
    BigBG=BigBG+BGleft.BGArrayUnion;
end
if ~isempty(BGright)
    actrec.Merge(BGright.AlignPortsInside);
    actrec.Merge(BGright.StraightenLinesInside);
    actrec.Merge(BGright.AlignPortsOutside);
    actrec.Merge(BGright.BGArrayUnion.VerticalAlign);
    BigBG=BigBG+BGright.BGArrayUnion;
end
actrec.Merge(BigBG.StraightenLinesInside);