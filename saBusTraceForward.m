function bussigs = saBusTraceForward(hdl)
%given BusCreator block
bussigs={};
if strcmpi(get_param(hdl,'Type'),'port')%[hdl] is port
    hline=get_param(hdl,'Line');
    if hline<0 %If the port is not connected with a line
        return;
    end
elseif strcmpi(get_param(hdl,'Type'),'line')%[hdl] is line
    hline=hdl;
elseif strcmpi(get_param(hdl,'Type'),'block')
    blklns=get_param(hdl,'LineHandles');
    if numel(blklns.Outport)==1&&blklns.Outport>0
        hline=blklns.Outport;
    else
        return;
    end
else
    return;
end
dstblks=get_param(hline,'DstBlockHandle');
dstpts=get_param(hline,'DstPortHandle');
for i=1:numel(dstblks)
    dstblktype=get_param(dstblks(i),'BlockType');
    ptcnt=get_param(dstblks(i),'Ports');
    if strcmp(dstblktype,'BusSelector') % Only disselect at BusSelector
        tmp=regexp(get_param(dstblks(i),'OutputSignals'),',','split');
        bussigs=[bussigs;tmp'];
    elseif strcmp(dstblktype,'SubSystem')
        pttype=get_param(dstpts(i),'PortType');
        if strcmpi(pttype,'inport')
            ptnum=get_param(dstpts(i),'PortNumber');
            subinport=find_system(dstblks(i),'FollowLinks','on','LookUnderMasks','on','SearchDepth',1,'BlockType','Inport','Port',int2str(ptnum));
            bussigs=[bussigs;saBusTraceForward(subinport)];
        end
    elseif strcmpi(dstblktype,'Goto')
        tag=get_param(dstblks(i),'GotoTag');
        if strcmpi(get_param(dstblks(i),'TagVisibility'),'local')
            froms=find_system(get_param(dstblks(i),'Parent'),'FollowLinks','on','LookUnderMasks','on','FindAll','on','SearchDepth',1,'BlockType','From','GotoTag',tag);
        elseif strcmpi(get_param(dstblks(i),'TagVisibility'),'global');
            froms=find_system(bdroot(dstblks(i)),'FollowLinks','on','LookUnderMasks','on','FindAll','on','BlockType','From','GotoTag',tag);
        end
        for i=1:numel(froms)
            bussigs=[bussigs;saBusTraceForward(froms(i))];
        end
    elseif strcmpi(dstblktype,'Outport')
        ptidx=str2num(get_param(dstblks(i),'Port'));
        prnt=get_param(dstblks(i),'Parent');
        if strcmpi(get_param(prnt,'BlockType'),'SubSystem')
            subsyspts=get_param(prnt,'PortHandles');
            bussigs=[bussigs;saBusTraceForward(subsyspts.Outport(ptidx))];
        end
%     elseif strcmpi(dstblktype,'SignalConversion')
%         bussigs=[bussigs;saBusTraceForward(dstblks(i))];
%     elseif strcmpi(dstblktype,'BusAssignment')
%         bussigs=[bussigs;saBusTraceForward(dstblks(i))];
    elseif ptcnt(2)==1 %Jump
        bussigs=[bussigs;saBusTraceForward(dstblks(i))];
    else
    end
end
bussigs=unique(bussigs);
end