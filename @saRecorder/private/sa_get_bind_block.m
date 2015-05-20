function bindblks = sa_get_bind_block(lnhdl, direction)
if nargin<2
    direction = 'downstream'
end
bindblks = [];
switch direction
    case 'downstream'
        dstblks = get_param(lnhdl, 'DstBlockHandle');
        dstpts = get_param(lnhdl, 'DstPortHandle');
        dstpts(dstpts<0) = [];
        childptlns = get_param(dstpts, 'Line');
        for i=1:numel(dstblks)
            if dstblks(i)<0 continue; end
            dstblklns = get_param(dstblks(i), 'LineHandles');
            inlns = dstblklns.Inport(dstblklns.Inport>0);
            if isempty(setdiff(inlns, childptlns))
                bindblks = [bindblks; dstblks(i)];
            end
        end
    case 'upstream'
        srcblk = get_param(lnhdl, 'SrcBlockHandle');
        if srcblk<0 return; end
        srcblklns = get_param(srcblk, 'LineHandles');
        if ~any(srcblklns.Outport>0 & srcblklns.Outport~=lnhdl)
            bindblks = srcblk;
        end
    otherwise
end
end