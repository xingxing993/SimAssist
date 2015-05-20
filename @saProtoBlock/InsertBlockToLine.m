function [actrec, blkhdl] = InsertBlockToLine(obj, lnhdl, varargin)
% obj.InsertBlockToLine(lnhdl, [INNUM, OUTNUM], ...)
% Called similar as AddBlock, except that:
% - the first argument must be a line handle
% - if given, the first 2-element numeric argument shall be the connect
% port like: [1 1],
% So note that the block size [W H] format is not applicable in this function
actrec = saRecorder;
if lnhdl<0;return;end;
% get option parameter
local_opt = {};
[option, varargin] = override_option(varargin, obj, local_opt);
% prepare connect port argument
newvars = varargin;
i_para = find(cellfun(@isnumeric, varargin), 1);% first numeric value
if isempty(i_para)
    cnntport = obj.ConnectPort;
else
    if ~isempty(varargin{i_para})&&numel(varargin{i_para})==2
        cnntport = varargin{i_para};
        newvars(i_para) = [];
    else
        cnntport = obj.ConnectPort;
    end
end
% prepare block position first
% if mouse inside line x-range, split by x
% if line vertical and mouse inside line y-range, split by y
% if mouse not inside line range, find the longest and insert in the middle
xy0 = saGetMousePosition; x0 = xy0(1); y0 = xy0(2);
lnpos = get_param(lnhdl,'Points');
xln = [min(lnpos(:,1)), max(lnpos(:,1))];
blksz = obj.GetBlockSize;
inside = @(rng, loc) (rng(1)-loc)*(rng(2)-loc)<0;
if inside(xln, x0)
    [ln1pos, ln2pos, blkwd] = xsplit_line(lnpos, x0);
    blksz(1) = min(blksz(1), blkwd);
elseif xln(1)==xln(2)
    ysep = round(sum(lnpos(:,2))/size(lnpos,1));
    ln1pos = [lnpos(1,:); [xln(1), ysep]; [xln(1)+5, ysep]];
    ln2pos = [[xln(1), ysep]; lnpos(end,:)];
else
    [tmp, idx] = max(abs(diff(lnpos(:,1)))); % find the longest in X segment
    xa = lnpos(idx,1); xb = lnpos(idx+1,1);
    xx = round(max(min(xa,xb)+5,(xa+xb)/2-blksz(1)/2));
    [ln1pos, ln2pos, blkwd] = xsplit_line(lnpos, xx);
    blksz(1) = min(blksz(1), blkwd);
end
if ln2pos(2,1)<ln1pos(end,1)
    orient = 'left';
else
    orient = 'right'; % default block orientation
end
% backup informations for future use
lnname = get_param(lnhdl, 'Name');
dstpts = get_param(lnhdl, 'DstPortHandle');
parsys = get_param(lnhdl, 'Parent');
lninfo = backup_lineinfo(lnhdl);
% delete old line
actrec.DeleteLine(lnhdl);
% add block
ltpos = [ln1pos(end, 1), ceil(max(ln1pos(end, 2)-blksz(2)/2, 0))];
[actrec2, blkhdl] = obj.AddBlock(ltpos,blksz,newvars{:},'Orientation',orient);
actrec.Merge(actrec2);
set_param(blkhdl, 'Selected', 'on');
% add incoming line
pthdls = get_param(blkhdl, 'PortHandles');
iptpos = get_param(pthdls.Inport(cnntport(1)), 'Position');
if size(ln1pos, 1)==1
    newlnpos = [ln1pos; ln1pos];
else
    newlnpos = ln1pos;
end
yofs = newlnpos(end,2)-iptpos(2);
blkpos = get_param(blkhdl,'Position');
blkpos([2,4]) = max(blkpos([2,4])+yofs, 0);
set_param(blkhdl, 'Position', blkpos);%adjust block position to align the inport with the line
newlnpos(end,1) = iptpos(1); % extend X to inport
newlnhdl = actrec.AddLine(parsys, newlnpos);
set_param(newlnhdl, 'Name', lnname);
% add outgoing line
optpos  = get_param(pthdls.Outport(cnntport(2)), 'Position');
ln2pos(1,:) = ceil((ln2pos(1,:)+ln2pos(2,:))/2); %shrink the starting line
if optpos(2)==ln2pos(1,2)
    newlnpos = [optpos; ln2pos(end,:)];
else
    newlnpos = [optpos; [ln2pos(1,1), optpos(2)]; ln2pos];
end
actrec.AddLine(parsys, newlnpos);
actrec + redraw_lines(parsys, lninfo.LineChildren);
end


function [ln1pos, ln2pos, wd] = xsplit_line(lnpos, x0)
% note that x0 must lie inside x range of line
ln1pos=[]; ln2pos = lnpos; wd = 0;
for r=1:size(lnpos,1)-1 % traverse each segment to find the first X projected
    pa = lnpos(r,:);pb = lnpos(r+1,:);
    if pa(1)==x0
        ln1pos = lnpos(1:r,:);
        ln2pos = lnpos(r:end,:);
        wd = 0;
        break;
    elseif (pa(1)-x0)*(pb(1)-x0)<=0
        y0 = ceil(pa(2)+(x0-pa(1))/(pb(1)-pa(1))*(pb(2)-pa(2)));
        ln1pos = [lnpos(1:r,:); [x0, y0]];
        ln2pos = [[x0, y0]; lnpos(r+1:end,:)];
        wd = ceil(abs(pb(1)-pa(1))*0.618);
        break;
    else
    end
end
if isempty(ln1pos)
    ln1pos = [[x0, ln2pos(1,2)]; ln2pos(1,:)]
end
wd = max(wd, 10); % at least 10
end


function lninfo = backup_lineinfo(ln)
lninfo.Points = get_param(ln, 'Points');
lnchilds = get_param(ln, 'LineChildren');
if isempty(lnchilds)
    lninfo.LineChildren = [];
else
    for i=1:numel(lnchilds)
        lninfo.LineChildren(i) = backup_lineinfo(lnchilds(i));
    end
end
end

function actrec = redraw_lines(parsys, lninfo)
actrec = saRecorder;
for k=1:numel(lninfo)
    actrec.AddLine(parsys, lninfo(k).Points);
    if ~isempty(lninfo(k).LineChildren)
        actrec + redraw_lines(parsys, lninfo(k).LineChildren);
    end
end
end



% ############# UNUSED CODES #####################
% function blinepos = calculate_branch_position(targetline, reflinepos)
% lnhdls = get_all_lines(targetline, true);
% blinepos = [];
% 
% tgtstartpt = [];
% blinepos = [];
% 
% for k=1:numel(lndhdls)
%     tgtlnpos = get_param(lnhdls(k),'Points');
%     for i=1:size(tgtlnpos,1)-1 % traverse each segment 
%         for j=1:size(reflinepos,1)-1 %traverse each segment
%             [tf, insctpt] = is_seg_intersect(tgtlnpos(i:i+1,:),reflinepos(j:j+1,:));
%             if tf
%                 blinepos = [insctpt;reflinepos(j+1:end,:)];
%                 break;
%             end
%         end
%         if ~isempty(blinepos)
%             break;
%         else
%             
%         end
%     end
% end
% if isempty(blinepos)
%     if isempty(tgtstartpt)
%         tgtstartpt = (tgtlnpos(end,:)+tgtlnpos(end-1,:))/2;
%     end
%     pt2 = [tgtstartpt(1),reflinepos(1,2)];
%     blinepos = [tgtstartpt; pt2; reflinepos];
% end
% end
% 
% function [tf, insctpt] = is_seg_intersect(seg1,seg2)
% % seg1, seg2 are coordinates of line [xa,ya;xb,yb]
% [A1,B1,C1] = math_line_equation(seg1(1,:), seg1(2,:));
% [A2,B2,C2] = math_line_equation(seg2(1,:), seg2(2,:));
% if A1*B2==A2*B1 % if parallel
%     tf = false;
%     insctpt = [];
%     return;
% end
% insctpt = (-[A1, B1; A2, B2]\[C1; C2])';
% f_inside = @(seg, point) (seg(1,1)-point(1))*(seg(2,1)-point(1))<=0;
% if f_inside(seg1, insctpt) && f_inside(seg2, insctpt)
%     tf = true;
% else
%     tf = false;
% end
% end
% 
% 
% function [A,B,C] = math_line_equation(p1,p2)
% % given p1, p2, get coefficient of Ax+By+C=0;
% v = p2-p1;
% A=v(2); B=-v(1);
% C=-sum([A,B].*p1);
% end
% 
% 
% function lnhdls = get_all_lines(ln, upsearch)
% if nargin<2
%     upsearch = false;
% end
% lnpar = get_param(ln,'LineParent');
% lnchild = get_param(ln,'LineChildren');
% if lnpar>0 && upsearch
%     lnhdls = get_all_lines(lnpar, upsearch);
% else
%     lnhdls = ln;
%     if ~isempty(lnchild)
%         for i=1:numel(lnchild)
%             lnhdls = [lnhdls; get_all_lines(lnchild(i))];
%         end
%     end
% end
% end



