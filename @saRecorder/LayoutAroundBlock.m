function LayoutAroundBlock(obj, blkhdl, side)
if nargin<3 || isempty(side)
    side = '[]';
end
if any(side=='[')
    obj + layout_upstreamwards(blkhdl);
end
if any(side==']')
    obj + layout_downstreamwards(blkhdl);
end
end

function actrec = layout_upstreamwards(blkhdl, originblk)
if nargin<2
    originblk = blkhdl; % add this 2nd parameter to avoid loop
end
actrec = saRecorder;
subblks = getSubBlocks(blkhdl, 'upstream');
lns = get_param(blkhdl, 'LineHandles');
ptnum = get_param(blkhdl, 'Ports');
for i=1:numel(subblks)
    if ~strcmp(get_param(subblks(i), 'Orientation'), 'right')
        continue;
    end
    srclns = get_param(subblks(i), 'LineHandles');
    % adjust port spacing for multiple outport blocks
    if numel(srclns.Outport)>1 && ptnum(1)>1
        blkpos = get_param(blkhdl, 'Position'); blkht = blkpos(4) - blkpos(2);
        srcblkpos = get_param(subblks(i),'Position');
        srcblkpos(4) = srcblkpos(2) + ceil(numel(srclns.Outport)*blkht/(ptnum(1)));
        actrec.SetParam(subblks(i), 'Position', srcblkpos);
    end
    % align port
    for k=1:numel(srclns.Outport)
        if srclns.Outport(k)>0
            lndstpt = get_param(srclns.Outport(k), 'DstPortHandle');
            if iscell(lndstpt)
                lndstpt = cell2mat(lndstpt);
            end
            dy = 0;
            for kk=1:numel(lndstpt)
                if isequal(get_param(get_param(lndstpt(kk), 'Parent'), 'Handle'), blkhdl)
                    pos1 = get_param(lndstpt(kk), 'Position');
                    lps = get_param(srclns.Outport(k), 'Points');
                    dy = pos1(2) - lps(1,2);
                    break;
                end
            end
            actrec.MoveBlock(subblks(i), [0, dy]);
            actrec.NeatenLine(srclns.Outport(k), 's2d');
            break;
        end
    end
    % continue to recursion
    if subblks(i)~=originblk
        actrec + layout_upstreamwards(subblks(i), originblk);
    end
end
% straighten line
for k=1:numel(lns.Inport)
    if lns.Inport(k)>0
        actrec.NeatenLine(lns.Inport(k), 'd2s+');
    end
end
end


function actrec = layout_downstreamwards(blkhdl, originblk)
if nargin<2
    originblk = blkhdl; % add this 2nd parameter to avoid loop
end
actrec = saRecorder;
subblks = getSubBlocks(blkhdl, 'downstream');
lns = get_param(blkhdl, 'LineHandles');
ptnum = get_param(blkhdl, 'Ports');
for i=1:numel(subblks)
    if ~strcmp(get_param(subblks(i), 'Orientation'), 'right')
        continue;
    end
    dstlns = get_param(subblks(i), 'LineHandles');
    % adjust port spacing for multiple inport blocks
    if numel(dstlns.Inport)>1 && ptnum(2)>1
        blkpos = get_param(blkhdl, 'Position'); blkht = blkpos(4) - blkpos(2);
        dstblkpos = get_param(subblks(i),'Position');
        dstblkpos(4) = dstblkpos(2) + ceil(numel(dstlns.Inport)*blkht/(ptnum(2)));
        actrec.SetParam(subblks(i), 'Position', dstblkpos);
        for k=1:numel(dstlns.Inport)
            if dstlns.Inport(k)>0
                srcpt = get_param(dstlns.Inport(k), 'SrcPortHandle');
                dstpt = get_param(dstlns.Inport(k), 'DstPortHandle');
                ptpos1 = get_param(srcpt, 'Position');
                ptpos2 = get_param(dstpt, 'Position');
                dyblk = ptpos1(2) - ptpos2(2);
                actrec.MoveBlock(subblks(i), [0, dyblk]);
                break;
            end
        end
    end
    % continue to recursion
    if subblks(i)~=originblk
        actrec + layout_downstreamwards(subblks(i), originblk);
    end
end
% straighten line
for k=1:numel(lns.Outport)
    if lns.Outport(k)>0
        actrec.NeatenLine(lns.Outport(k), 's2d+');
    end
end
end


function subblks = getSubBlocks(blkhdl, direction)
subblks=[];
% determine sub-blocks of the target block
switch direction
    case 'upstream'
        srcblks = getSrcBlockHandles(blkhdl);
        if isempty(srcblks)
            return;
        end
        for i=1:numel(srcblks)
            subflg = true;
            srclns = get_param(srcblks(i), 'LineHandles');
            for k=1:numel(srclns.Outport)
                lnblk = saGetLineDominantBlock(srclns.Outport(k), 'downstream');
                if ~isempty(setdiff(lnblk.Recessive, blkhdl)) % if have other block share the line
                    subflg = false; break;
                end
            end
            if subflg
                subblks = [subblks; srcblks(i)];
            end
        end
    case 'downstream'
        dstblks = getDstBlockHandles(blkhdl);
        if isempty(dstblks)
            return;
        end
        for i=1:numel(dstblks)
            subflg = true;
            dstlns = get_param(dstblks(i), 'LineHandles');
            for k=1:numel(dstlns.Inport)
                lnblk = saGetLineDominantBlock(dstlns.Inport(k), 'upstream');
                if ~isempty(setdiff(lnblk.Recessive, blkhdl)) % if have other block share the line
                    subflg = false; break;
                end
            end
            if subflg
                subblks = [subblks; dstblks(i)];
            end
        end
    otherwise
end
end


function srcblks = getSrcBlockHandles(blkhdl)
srcblks = [];
if blkhdl<0
    return;
end
lns = get_param(blkhdl, 'LineHandles');
for i=1:numel(lns.Inport)
    if lns.Inport(i)<0
        continue;
    else
        srcblks = [srcblks; get_param(lns.Inport(i), 'SrcBlockHandle')];
    end
end
srcblks(srcblks<0)=[];
srcblks = unique(srcblks);
end

function dstblks = getDstBlockHandles(blkhdl)
dstblks=[];
if blkhdl<0
    return;
end
lns = get_param(blkhdl, 'LineHandles');
for k=1:numel(lns.Outport)
    if lns.Outport(k)>0
        dstblks=[dstblks;get_param(lns.Outport(k),'DstBlockHandle')];
    end
end
dstblks(dstblks<0)=[];
dstblks = unique(dstblks);
end
