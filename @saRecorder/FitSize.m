function FitSize(obj, blkhdl)
% Resize according to outport
lns=get_param(blkhdl,'LineHandles');
tgtspan_rt=-1;tgtspan_lt=-1;
%get the target span value
if numel(lns.Outport)>1
    dstblks = []; dstpts = [];
    for k=1:numel(lns.Outport)
        if lns.Outport(k)>0
            [tmpblk, tmppt] = get_align_datum(lns.Outport(k), 'right');
            dstblks =[dstblks; tmpblk];
            dstpts =[dstpts; tmppt];
        end
    end
    dstblks = dstblks(dstblks>0);
    dstpts = dstblks(dstpts>0);
    if ~isempty(dstblks)
        unqdsts=unique(dstblks);
        spans_rt=[]; % List of spans of destination blocks
        for k=1:numel(unqdsts)
            if sum(dstblks==unqdsts(k))>1 % if multiple line connected
                tmppts=get_param(unqdsts(k),'PortHandles');
                pos=cell2mat(get_param(tmppts.Inport,'Position')); %at least two inports
                spans_rt=[spans_rt;abs(pos(2,2)-pos(1,2))];
            end
        end
        if ~isempty(spans_rt)
            tgtspan_rt = find_most(spans_rt);
        else % spans_rt empty means all block has single connection with host block
            if numel(dstpts)>1
                ptspos = cell2mat(get_param(dstpts, 'Position'));
                tgtspan_rt = (max(ptspos(:,2))-min(ptspos(:,2)))/numel(dstpts);
            else
                tgtspan_rt = -1;
            end
        end
    end
end
if numel(lns.Inport)>1
    srcblks = zeros(size(lns.Inport));
    srcpts = zeros(size(lns.Inport));
    for k=1:numel(lns.Inport)
        if lns.Inport(k)>0
            [srcblks(k), srcpts(k)] = get_align_datum(lns.Inport(k), 'left');
        end
    end
    srcblks = srcblks(srcblks>0);
    srcpts = srcpts(srcpts>0);
    if ~isempty(srcblks)
        unqsrcs=unique(srcblks);
        spans_lt=[]; % List of spans of destination blocks
        for k=1:numel(unqsrcs)
            if sum(srcblks==unqsrcs(k))>1 %more than one port connected between two blocks
                tmppts=get_param(unqsrcs(k),'PortHandles');
                pos=cell2mat(get_param(tmppts.Outport,'Position')); %at least two inports
                spans_lt=[spans_lt;abs(pos(2,2)-pos(1,2))];
            end
        end
        if ~isempty(spans_lt)
            tgtspan_lt=find_most(spans_lt);% find the mostly used span value
        else
            if numel(srcpts)>1
                ptspos = cell2mat(get_param(srcpts, 'Position'));
                tgtspan_rt = (max(ptspos(:,2))-min(ptspos(:,2)))/numel(srcpts);
            else
                tgtspan_rt = -1;
            end
        end
    end
end

% arbitration of left or right
num_ltpts=numel(lns.Inport);
num_rtpts=numel(lns.Outport);
oldpos=get_param(blkhdl,'Position');
blkht=oldpos(4)-oldpos(2);
if tgtspan_lt>0&&tgtspan_rt<0
    newht=num_ltpts*tgtspan_lt;
elseif tgtspan_rt>0&&tgtspan_lt<0
    newht=num_rtpts*tgtspan_rt;
elseif tgtspan_lt>0&&tgtspan_rt>0
    newht_lt=num_ltpts*tgtspan_lt;
    newht_rt=num_rtpts*tgtspan_rt;
    if isempty(spans_lt)
        newht=newht_rt;
    elseif isempty(spans_rt)
        newht=newht_lt;
    elseif abs(newht_lt-blkht)<abs(newht_rt-blkht)
        newht=newht_lt;
    else
        newht=newht_rt;
    end
else
    return;
end
% set the position of block
newval=[oldpos(1:3),oldpos(2)+newht];
obj.SetParam(blkhdl,'Position',newval);
end

function val = find_most(vals)
unq=unique(vals);% find the mostly used span value
cnt = zeros(size(unq));
for k=1:numel(unq)
    cnt(k)=sum(vals==unq(k));
end
[tmp,idx]=max(cnt);
val=unq(idx);
end


function [blk, pt] = get_align_datum(lnhdl, lr)
if strcmp(lr,'right')
    dstblk = get_param(lnhdl,'DstBlockHandle');
    dstpt = get_param(lnhdl,'DstPortHandle');
%     [blk, pt] = deal(dstblk, dstpt); return;
    if numel(dstblk)>1 || dstblk<0
        [blk, pt] = deal(dstblk, dstpt);
        return;
    end
    ptcnt = get_param(dstblk,'Ports');
    if ptcnt(1)==1 && ptcnt(2)==1 % SISO, bypass
        lns = get_param(dstblk, 'LineHandles');
        if lns.Outport>0
            [blk, pt] = get_align_datum(lns.Outport, lr);
        else
            [blk, pt] = deal(-1);
            return;
        end
    else
        blk = dstblk;
        pt = dstpt;
    end
else
    srcblk = get_param(lnhdl,'SrcBlockHandle');
    srcpt = get_param(lnhdl,'SrcPortHandle');
%     [blk, pt] = deal(srcblk, srcpt);return;
    if srcblk<0
        [blk, pt] = deal(srcblk, srcpt);
        return;
    end
    ptcnt = get_param(srcblk,'Ports');
    if ptcnt(1)==1 && ptcnt(2)==1 % SISO, bypass
        lns = get_param(srcblk, 'LineHandles');
        if lns.Inport>0
            [blk, pt] = get_align_datum(lns.Inport, lr);
        else
            [blk, pt] = deal(-1);
            return;
        end
    else
        blk = srcblk;
        pt = srcpt;
    end
end
end