function NeatenLine(obj, lnhdl, direction)
if nargin<3
    direction = 's2d'; %source to destination
end
% suffix with "+" means elastic vertical line
switch direction
    case 's2d'
        obj + neaten_line_s2d(lnhdl);
    case 's2d+'
        obj + neaten_line_s2d(lnhdl, [], true);
    case 'd2s'
        obj + neaten_line_d2s(lnhdl);
    case 'd2s+'
        obj + neaten_line_d2s(lnhdl, [], [], true);
    case 'auto'
        obj + neaten_line_auto(lnhdl);
    otherwise
end
end


function actrec = neaten_line_auto(lnhdl)
actrec = saRecorder;
if lnhdl<0
    return;
end
lnchilds = get_param(lnhdl, 'LineChildren');
lnpar = get_param(lnhdl, 'LineParent');
lnpoints = get_param(lnhdl, 'Points');
srcblk = get_param(lnhdl, 'SrcBlockHandle');
dstblks = unique(get_param(lnhdl, 'DstBlockHandle'));
srcpt = get_param(lnhdl, 'SrcPortHandle');
dstpts = get_param(lnhdl, 'DstPortHandle');
% calculate number of port not connected to this line, upstream and
% downstream
if srcblk>0
    ptcnt_src = get_param(srcblk, 'Ports');
    num_expts_src = ptcnt_src(2) - 1;
else
    num_expts_src = 0;
end
num_expts_dst = 0;
for i=1:numel(dstblks)
    if dstblks(i)>0
        ptcnt_dst = get_param(dstblks(i), 'Ports');
        num_expts_dst = num_expts_dst + ptcnt_dst(1);
    end
end
num_expts_dst = num_expts_dst - numel(dstpts);
%
if num_expts_dst<=num_expts_src
    actrec + neaten_line_s2d(lnhdl, [], true);
else
    actrec + neaten_line_d2s(lnhdl, [], [], true);
end
end


function actrec = neaten_line_s2d(lnhdl, dyln, vert_elastic)
actrec = saRecorder;
if lnhdl<0
    return;
end
lnchilds = get_param(lnhdl, 'LineChildren');
lnpar = get_param(lnhdl, 'LineParent');
lnpoints = get_param(lnhdl, 'Points');
if lnpoints(end,1)<lnpoints(1,1) % if last point is leftwards of 1st point, maybe feedback line, ignore it
    return;
end
if nargin<2 || isempty(dyln)
    % calculate basic straighten info: delta Y, and new line points
    if lnpoints(1,1)==lnpoints(2,1) && lnpar>0 % if 1st segment vertical and branch
        if vert_elastic
            dyln = 0;
        else
            dyln = lnpoints(2,2) - lnpoints(end,2);
        end
    elseif ~any(lnpoints(1,:)==lnpoints(2,:)) % not vertical or horizontal
        dyln = lnpoints(1,2) - lnpoints(2,2);
    else % simply straighten using 1st and last point
        dyln = lnpoints(1,2) - lnpoints(end,2);
    end
end
if nargin<3
    vert_elastic = false;
end
if isempty(lnchilds)
    lnblk = saGetLineDominantBlock(lnhdl, 'downstream');
    if ~isempty(lnblk.Dominant)
        actrec.MoveBlock(lnblk.Dominant, [0, dyln]);
        % block moved, also neaten its outport line
        bindblklns = get_param(lnblk.Dominant, 'LineHandles');
        for k=1:numel(bindblklns.Outport)
            actrec + neaten_line_s2d(bindblklns.Outport(k), [], vert_elastic);
        end
    end
    lnpoints = get_param(lnhdl, 'Points'); % re-get after move block
    actrec.SetParam(lnhdl, 'Points', neaten_line_points(lnpoints));
else
    lnpoints(2:end,2) = lnpoints(2:end,2)+dyln;
    actrec.SetParam(lnhdl, 'Points', neaten_line_points(lnpoints));
    for i=1:numel(lnchilds)
        if dyln~=0
            actrec + neaten_line_s2d(lnchilds(i), dyln, vert_elastic);
        else
            actrec + neaten_line_s2d(lnchilds(i), [], vert_elastic);
        end
    end
end
end

function actrec = neaten_line_d2s(lnhdl, dyln, exln, vert_elastic)
% exln: line to be excluded in children
actrec = saRecorder;
if lnhdl<0
    return;
end
lnchilds = get_param(lnhdl, 'LineChildren');
lnpar = get_param(lnhdl, 'LineParent');
lnpoints = get_param(lnhdl, 'Points');
if lnpoints(end,1)<lnpoints(1,1) % if 1st point is rightwards of end point, maybe feedback line, ignore it
    return;
end
if nargin<2 || isempty(dyln)
    if lnpoints(1,1)==lnpoints(2,1) && lnpar>0 % if 1st segment vertical and branch
        if vert_elastic
            dyln = 0;
        else
            dyln = lnpoints(end,2) - lnpoints(2,2);
        end
    elseif ~any(lnpoints(1,:)==lnpoints(2,:)) % not vertical or horizontal
        dyln = lnpoints(2,2) - lnpoints(1,2);
    else % simply straighten using 1st and last point
        dyln = lnpoints(end,2) - lnpoints(1,2);
    end
    dy_shift = 0;
else
    dy_shift = dyln;
end
if nargin<4
    vert_elastic = false;
end
if nargin<3
    exln = [];
end
if lnpar>0
    actrec + neaten_line_d2s(lnpar, dyln, lnhdl, vert_elastic); % straighten parent first
    lnpoints = get_param(lnhdl, 'Points'); % re-get after parent line move
    if ~isempty(lnchilds)&&nargin>1
        lnpoints(2:end,2) = lnpoints(2:end,2)+dyln; % shift other point correspondingly
    end
    actrec.SetParam(lnhdl, 'Points', neaten_line_points(lnpoints));
    if ~isempty(lnchilds) && nargin>2
        lnshifts = setdiff(lnchilds, exln);
    else
        lnshifts = lnchilds;
    end
    for i=1:numel(lnshifts)
        actrec + neaten_line_s2d(lnshifts(i), dyln, vert_elastic);
    end
else
    lnblk = saGetLineDominantBlock(lnhdl, 'upstream');
    if ~isempty(lnblk.Dominant)
        dy2 = lnpoints(end,2)-lnpoints(1,2); % used to straighten the line instead of shift
        actrec.MoveBlock(lnblk.Dominant, [0, dy2]);
        bindblklns = get_param(lnblk.Dominant, 'LineHandles');
        for k=1:numel(bindblklns.Inport)
            actrec + neaten_line_d2s(bindblklns.Inport(k), dy_shift+dy2, [], vert_elastic);
        end
    end
    lnpoints = get_param(lnhdl, 'Points'); % re-get after move block
    if ~isempty(lnchilds) && nargin>1
        lnpoints(2:end,2) = lnpoints(2:end,2)+dy_shift;
    end
    actrec.SetParam(lnhdl, 'Points', neaten_line_points(lnpoints));
    lnshifts = setdiff(lnchilds, exln);
    for i=1:numel(lnshifts)
        actrec + neaten_line_s2d(lnshifts(i), dy_shift, vert_elastic);
    end
end
end


function newlnpts = neaten_line_points(lnpoints)
p1 = lnpoints(1,:);p2 = lnpoints(2,:);
pend = lnpoints(end,:);
np = size(lnpoints,1);
if p1(1)==p2(1) % if 1st segment vertical
    if p1(2)~=pend(2)
        newlnpts = [p1; [p1(1), pend(2)]; pend];
    else
        newlnpts = [p1; pend];
    end
elseif p1(2)==p2(2) % if 1st segment horizontal
    if np>2
        newlnpts = [p1; p2; [p2(1), pend(2)]; pend];
    else
        newlnpts = lnpoints;
    end
else
    if np>2
        newlnpts = [p1; [p2(1), p1(2)]; [p2(1), pend(2)]; pend];
    else
        newlnpts = [p1; [floor((p2(1)+p1(1))/2), p1(2)]; [floor((p2(1)+p1(1))/2), pend(2)]; pend];
    end
end
end
