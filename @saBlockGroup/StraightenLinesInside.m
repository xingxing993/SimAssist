function actrec=StraightenLinesInside(objs)
actrec=saRecorder;
for kk=1:numel(objs)
    obj=objs(kk);
    lns=[];
    for i=1:obj.BlockCount
        tmpln=get_param(obj.BlockHandles(i),'LineHandles');
        lns=[lns;tmpln.Inport';tmpln.Outport'];
    end
    lns=unique(lns(lns>0)); %get all the lines
    tmpvar1=get_param(lns,'LineParent');
    if iscell(tmpvar1)
        tmpvar1=cell2mat(tmpvar1);
    end
    trunklns=lns(tmpvar1<0);
    branchlns=get_param(trunklns,'LineChildren');
    if iscell(branchlns)
        branchlns=cell2mat(branchlns);
    end
    for i=1:numel(trunklns) %first handle the trunk lines
        lnpoints=get_param(trunklns(i),'Points');
        dstpts=get_param(trunklns(i),'DstPortHandle');
        if numel(dstpts)>1
            for jj=1:numel(dstpts)%discard those that has only one inport and no outport
                if dstpts(jj)<0
                    continue;
                end
                dstblk=get_param(dstpts(jj),'Parent');
                dstblkptnum=get_param(dstblk,'Ports');
                if dstblkptnum(1)==1&&dstblkptnum(2)==0
                    dstpts(jj)=-1; %mark as -1
                end
            end
            dstpts=dstpts(dstpts>0);
        end
        if numel(dstpts)==1 && dstpts>0%only when single valid port left
            ptpos=get_param(dstpts,'Position');
            if lnpoints(1,2)~=ptpos(2) %if source port and dest port not aligned
                newlnpoints=[lnpoints(1,:);lnpoints(2,1),lnpoints(1,2);lnpoints(2,1),ptpos(2);lnpoints(end,1),ptpos(2)]; %4 points pattern
            else
                newlnpoints=[lnpoints(1,:);lnpoints(end,1),ptpos(2)]; %2 points straight line pattern
            end
            actrec.SetParam(trunklns(i),'Points',newlnpoints);
        end
    end
    for i=1:numel(branchlns) % then neaten the branch lines
        lnpoints=get_param(branchlns(i),'Points');
        if lnpoints(1,2)~=lnpoints(end,2)
            newlnpoints=[lnpoints(1,:);lnpoints(2,1),lnpoints(1,2);lnpoints(2,1),lnpoints(end,2);lnpoints(end,:)];
        else
            newlnpoints=[lnpoints([1,end],:)];
        end
        actrec.SetParam(branchlns(i),'Points',newlnpoints);
    end
end
end