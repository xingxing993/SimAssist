function [actrec, blkhdl] = AddBlockToPort(obj, pthdl, varargin)
% Called similar as AddBlock, except that:
% - the first argument must be a port handle
% - only blksize argument is allowed, the xy0 shall not be specified
% - user can manually specify an structrue option parameter to override the
% default behavior
actrec = saRecorder;

if pthdl<0;return;end;

% convert block into port if necessary
if strcmp(get_param(pthdl,'type'),'block')
    pts = get_param(pthdl, 'PortHandles');
    if numel(pts.Inport)==1
        pthdl = pts.Inport;
    elseif numel(pts.Outport)==1
        pthdl = pts.Outport;
    else
        return;
    end
end

%
local_opt =struct(...
    'HorizontalMargin', obj.LayoutSize.HorizontalMargin, ...
    'GetMarginByMouse', true, ...
    'PropagateString', true);
[option, argsin, optarg] = override_option(varargin, obj, local_opt);
% get option parameter
xy0 = saGetMousePosition;
ptpos = get_param(pthdl, 'Position');
if strcmp(get_param(pthdl,'PortType'),'inport')  && option.GetMarginByMouse
    HM = max(option.HorizontalMargin, ptpos(1)-xy0(1));
elseif strcmp(get_param(pthdl,'PortType'),'outport') && option.GetMarginByMouse
    HM = max(option.HorizontalMargin, xy0(1)-ptpos(1));
else
    HM = option.HorizontalMargin;
end
% disable following behavior temporarily coz they may be done later
optarg.AutoSize = false;
optarg.AutoDataType = false;
optarg.Refine = false;

% note that the position shall be explicitly defined ([L T R B] form) when adding to block,
% thus the input argument need to be rearranged if necessary
i_szpara = find(cellfun(@isnumeric, argsin), 1);% first numeric value
if ~isempty(i_szpara)
    W = argsin{i_szpara}(1);H = argsin{i_szpara}(2);
    blockpos = calculate_block_position(pthdl, HM, W, H);
    argsin{i_szpara} = blockpos;
else
    blksize = obj.GetBlockSize;
    W = blksize(1);    H = blksize(2);
    blockpos = calculate_block_position(pthdl, HM, W, H);
    argsin = [blockpos, argsin];
end

% add block
[actrec2, blkhdl] = obj.AddBlock(optarg, argsin{:});
actrec.Merge(actrec2);

% add line and other operations
parasys = get_param(blkhdl,'Parent');
blkpts = get_param(blkhdl, 'PortHandles');
if strcmp(get_param(pthdl,'PortType'),'inport')
    if numel(blkpts.Outport)>0 && obj.ConnectPort(2)
        actrec.AddLine(parasys, blkpts.Outport(obj.ConnectPort(2)), pthdl, '');
        if option.PropagateString && ~isempty(obj.PropagateDownstreamStringMethod)
            actrec.Merge(obj.PropagateDownstreamString(blkhdl));
        end
    end
else
    if numel(blkpts.Inport)>0 && obj.ConnectPort(1)
        actrec.AddLine(parasys, pthdl, blkpts.Inport(obj.ConnectPort(1)), '');
        if option.PropagateString && ~isempty(obj.PropagateUpstreamStringMethod)
            actrec.Merge(obj.PropagateUpstreamString(blkhdl));
        end
    end
end

actrec + obj.Adapt(blkhdl, option);
end


function blockpos = calculate_block_position(pthdl, HM, W, H)
% HM: horizontal margine
% W: width
% H: height
basepos = get_param(pthdl, 'Position');
if strcmp(get_param(pthdl,'PortType'),'inport')
    blockpos = [max(basepos(1)-HM-W, 0),...
        basepos(2)-H/2,...
        max(basepos(1)-HM, 0),...
        basepos(2)+H/2];
else
    blockpos = [basepos(1)+HM,...
        basepos(2)-H/2,...
        basepos(1)+HM+W,...
        basepos(2)+H/2];
end
end