function actrec=VerticalAlign(objs)
actrec=saRecorder;
for i=1:numel(objs);
    obj=objs(i);
    blks=obj.BlockHandles;
    while ~isempty(blks)
        sameblks=blks(1);
        blktyp=get_param(blks(1),'BlockType');
        basepos=get_param(blks(1),'Position');
        [x1,x2]=deal(basepos(1),basepos(3));
        basewidth=x2-x1;
        lbd=x1-30;%left bound
        rbd=x2+30;%right bound
        for i=2:numel(blks)
            tmppos=get_param(blks(i),'Position');
            [r1,r2]=deal(tmppos(1),tmppos(3));
            if strcmp(blktyp,get_param(blks(i),'BlockType'))&& ...%Same type
                    ((lbd-r1)*(rbd-r1)<=0||(lbd-r2)*(rbd-r2)<=0)&& ...%intersect vertically
                    (r2-r1)<=1.5*basewidth %width around
                sameblks=[sameblks;blks(i)];
            end
        end
        pos=get_param(sameblks,'Position');
        if iscell(pos)
            pos=cell2mat(pos);
        end
        mxwidth=mean(pos(:,3)-pos(:,1)); %change from max to mean
        l_edge=ceil((min(pos(:,1))+max(pos(:,3))-mxwidth)/2);
        for i=1:numel(sameblks)
            tsblkpos=get_param(sameblks(i),'Position');
            tsblkpos(1)=l_edge;
            tsblkpos(3)=l_edge+mxwidth;
            actrec.SetParam(sameblks(i),'Position',tsblkpos);
        end
        
        blks=setdiff(blks,sameblks);
    end
end
end