function points_layout = saLineRouteLineToDst(lnhdl, dstpos, overlap_offset)
if nargin<2
    overlap_offset = [0, 0];
end
dstpos2 = saRectifyPos(dstpos + overlap_offset);
[lnpos, weight, direction] = extract_line_info(lnhdl, dstpos2);
avail = false(numel(weight), 1); %initialize
for i=1:size(lnpos, 1)
    vec = dstpos - lnpos(i, :);
    req = vec2direction(vec);
    if (bitget(direction(i,1),1) && req(1)>0) ||...
            (bitget(direction(i,1),2) && req(1)<0) ||...
            (bitget(direction(i,2),1) && req(2)>0) ||...
            (bitget(direction(i,2),2) && req(2)<0)
        avail(i) = true;
    end
end
if ~any(avail)
    avail = ~avail; % if no proper point in direction, then all
end
lnpos_avail = lnpos(avail,:);
weight_avail = weight(avail,:);
direction_avail = direction(avail,:);
distance = sqrt((lnpos_avail(:,1)-dstpos2(1)).^2 + (lnpos_avail(:,2)-dstpos2(2)).^2);
distance2 = distance.*weight_avail;
[tmp, idx] = min(distance2); % find the nearest
selpt = lnpos_avail(idx,:);
selpt_direction = direction_avail(idx,:);
%layout between selected point and destination point
arrow = dstpos - selpt;
if (bitget(selpt_direction(2),1) && arrow(2)>0) ||...
        (bitget(selpt_direction(2),2) && arrow(2)<0)
    points_layout = [selpt; [selpt(1), dstpos(2)]; dstpos];
else
    midpt_x = round((selpt(1)+dstpos(1))/2);
    points_layout = [selpt; [midpt_x, selpt(2)]; [midpt_x, dstpos(2)]; dstpos];
end
end


function [lnpos, weight, direction] = extract_line_info(lnhdl, dstpos)
lnpos = get_param(lnhdl, 'Points');
[np, tmp]=size(lnpos);
% weight = ones(np,1);direction = zeros(np,2); %initialize
ptidx = 1;
insert = 0;
while ptidx<np % loop until the last point
    pb = lnpos(ptidx+1,:);pa = lnpos(ptidx,:);
    if logical(insert) % if the point is inserted, make it less weighted (increase distance)
        weight(ptidx,1) = 1.4;
        insert = insert-1;
    else
        if ptidx==1
            weight(1) = 1.4; % I don't like connect at the first point
        else
            weight(ptidx,1) = 1;
        end
    end
    tmp = (pa-dstpos).*(pb-dstpos);
    if tmp(1)<0 % destinaiton point lies between in X
        insrtpt = [dstpos(1), ((pb(2)-pa(2)))/(pb(1)-pa(1))*(dstpos(1)-pa(1))+pa(2)];
        lnpos = [lnpos(1:ptidx,:); insrtpt; lnpos(ptidx+1:end,:)]; % insert point
        np = np + 1; %increase number of points
        insert = insert+1;
    end
    if tmp(2)<0 % destinaiton point lies between in Y
        insrtpt = [((pb(1)-pa(1)))/(pb(2)-pa(2))*(dstpos(2)-pa(2))+pa(1), dstpos(2)];
        lnpos = [lnpos(1:ptidx,:); insrtpt; lnpos(ptidx+1:end,:)]; % insert point
        np = np + 1; %increase number of points
        insert = insert+1;
    end
    pb = lnpos(ptidx+1,:);
    % calculate the available direction of current point
    vec = vec2direction(pb - pa);
    if ptidx>1
        vec_prev = vec2direction(lnpos(ptidx-1,:) - pa);
    else
        vec_prev = [0,0];
    end
    direction(ptidx,:) = get_available_direction(vec, vec_prev);
    ptidx = ptidx + 1;
end
pb = lnpos(ptidx-1,:);pa = lnpos(ptidx,:);
lnpos(ptidx,:) = round(pb*1/3 + pa*2/3); % last point
vec_prev = vec2direction(pb - pa);
weight(ptidx,1) = 1.4;
direction(ptidx,:) = get_available_direction(vec_prev);
if ~isempty(get_param(lnhdl,'LineChildren'))
    lnchildren = get_param(lnhdl,'LineChildren');
    append_pos = [];append_weight = [];append_direction = [];
    direction(ptidx,:) = [3,3]; % initialize
    for i=1:numel(lnchildren)
        [lnpos_ch, weight_ch, direction_ch] = extract_line_info(lnchildren(i), dstpos);
        direction(end,1) = bitand(direction_ch(1,1), direction(end,1)); % intersect X
        direction(end,2) = bitand(direction_ch(1,2), direction(end,2)); % intersect Y
        % merge the last point of parent line and the first point of
        % children line, and then append the other points of the children
        append_pos = [append_pos; lnpos_ch(2:end,:)];
        append_weight = [append_weight; weight_ch(2:end)];
        append_direction = [append_direction; direction_ch(2:end,:)];
    end
    lnpos = [lnpos; append_pos];
    weight = [weight; append_weight];
    direction = [direction; append_direction];
end
end


function d = vec2direction(vec)
d=[0,0];
if abs(vec(1))<abs(vec(2))
    if vec(2)>0
        d(2)=1;
    elseif vec(2)<0
        d(2)=-1;
    else
        d(2)=0;
    end
else
    if vec(1)>0
        d(1)=1;
    elseif vec(1)<0
        d(1)=-1;
    else
        d(1)=0;
    end
end
end


function enum_dir = get_available_direction(varargin)
% output two element array [X, Y], with each enumerated as:
% 0: no, 1: right/down, 2: left/up, 3, either
% input: vector arrays of the point (2-element array created by vec2direction, e.g., [-1, 1])
drts = cell2mat(varargin');
xx = setdiff([1,-1], drts(:,1));
yy = setdiff([1,-1], drts(:,2));
if isempty(xx)
    enum_dir(1) = 0;
elseif numel(xx)>1
    enum_dir(1) = 3;
elseif xx==1
    enum_dir(1) = 1;
else % == -1
    enum_dir(1) = 2;
end
if isempty(yy)
    enum_dir(2) = 0;
elseif numel(yy)>1
    enum_dir(2) = 3;
elseif yy==1
    enum_dir(2) = 1;
else % == -1
    enum_dir(2) = 2;
end
end