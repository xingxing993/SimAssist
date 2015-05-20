function [actrec, blkhdl] = AddBlockToLine(obj, lnhdl, varargin)
% Called similar as AddBlock, except that:
% - the first argument must be a line handle
% - user can manually specify an structrue option parameter to override the
% default behavior
actrec = saRecorder;

if lnhdl<0;return;end;

% get option parameter
local_opt = struct(...
    'ToLineOffset', obj.LayoutSize.ToLineOffset, ...
    'PropagateString', true);
[option, argsin, optarg] = override_option(varargin, obj, local_opt);

% disable following behavior temporarily coz they may be done later
optarg.AutoSize = false;
optarg.AutoDataType = false;
optarg.Refine = false;

OFS = option.ToLineOffset;
% note that the position shall be explicitly defined ([L T R B] form) when adding to block,
% thus the input argument need to be rearranged if necessary
i_szpara = find(cellfun(@isnumeric, argsin), 1);% first numeric value
if ~isempty(i_szpara)
    W = argsin{i_szpara}(1);H = argsin{i_szpara}(2);
    blockpos = calculate_block_position(lnhdl, OFS, W, H);
    argsin{i_szpara} = blockpos;
else
    sz = obj.GetBlockSize;  W = sz(1); H = sz(2);
    blockpos = calculate_block_position(lnhdl, OFS, W, H);
    argsin = [blockpos, argsin];
end

isnosrcln = get_param(lnhdl, 'SrcPortHandle')<0;
% add block
[actrec2, blkhdl] = obj.AddBlock(optarg, argsin{:});
actrec.Merge(actrec2);
set_param(blkhdl, 'Selected', 'on');

% add line and other operations
pts = get_param(blkhdl, 'PortHandles');
if isnosrcln
    if ~isempty(pts.Outport) && obj.ConnectPort(2)
        srcpt = pts.Outport(min(obj.ConnectPort(2),end));
        if get_param(srcpt,'Line')<0
            actrec.AutoLine(srcpt,lnhdl);
        end
        if ~isempty(obj.PropagateDownstreamStringMethod) && option.PropagateString
            actrec.Merge(obj.PropagateDownstreamString(blkhdl));
        end
    end
else
    if ~isempty(pts.Inport) && obj.ConnectPort(1)
        dstpt = pts.Inport(min(obj.ConnectPort(1),end));
        if get_param(dstpt,'Line')<0
            actrec.AutoLine(lnhdl, dstpt);
        end
        if ~isempty(obj.PropagateUpstreamStringMethod) && option.PropagateString
            actrec.Merge(obj.PropagateUpstreamString(blkhdl));
        end
    end
end

actrec + obj.Adapt(blkhdl, option);
end



function blkpos = calculate_block_position(lnhdl, OFS, W, H)
lnpos = get_param(lnhdl, 'Points');
if strcmp(get_param(lnhdl, 'Connected'),'off')
    if get_param(lnhdl, 'SrcBlockHandle')<0
        blkpos = [max(lnpos(1,1)-W,0), max(lnpos(1,2)-H/2,0), lnpos(1,1), lnpos(1,2)+H/2];
    else %get_param(lnhdl, 'DstBlockHandle')<0
        blkpos = [lnpos(end,1), max(lnpos(end,2)-H/2,0), lnpos(end,1)+W, lnpos(end,2)+H/2];
    end
else
    branchendpoint = lnpos(1,:) + OFS;
    blkpos = [branchendpoint(1), max(branchendpoint(2)-H/2,0), branchendpoint(1)+W, branchendpoint(2)+H/2];
end
end