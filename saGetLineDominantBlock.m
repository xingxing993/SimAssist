function blocks = saGetLineDominantBlock(lnhdl, direction)
if nargin<2
    direction = 'downstream'
end
domblks = [];
ndomblks = [];
if lnhdl<0
    blocks.Dominant = domblks;
    blocks.Recessive = ndomblks;
    return;
end

switch direction
    case 'downstream'
        dstblks = unique(get_param(lnhdl, 'DstBlockHandle'));
        dstpts = get_param(lnhdl, 'DstPortHandle');
        srcpt = get_param(lnhdl, 'SrcPortHandle');
        dstpts(dstpts<0) = [];
        for i=1:numel(dstblks)
            if dstblks(i)<0 continue; end
            dstblklns = get_param(dstblks(i), 'LineHandles');
            inlns = dstblklns.Inport(dstblklns.Inport>0);
            insrcpts = get_param(inlns, 'SrcPortHandle');
            if iscell(insrcpts)
                srcpts = unique(cell2mat(insrcpts));
            end
            if isequal(srcpt, insrcpts)
                domblks = [domblks; dstblks(i)];
            else
                ndomblks = [ndomblks; dstblks(i)];
            end
        end
    case 'upstream'
        srcblk = get_param(lnhdl, 'SrcBlockHandle');
        if srcblk<0 return; end
        srcblklns = get_param(srcblk, 'LineHandles');
        if ~any(srcblklns.Outport>0 & srcblklns.Outport~=lnhdl)
            domblks = srcblk;
        else
            ndomblks = srcblk;
        end
    otherwise
end
blocks.Dominant = domblks;
blocks.Recessive = ndomblks;
end