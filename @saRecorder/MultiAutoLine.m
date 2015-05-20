function MultiAutoLine(obj, srchdls, dsthdls, varargin)
% wrapper function for multiple line connection between two objects (line,
% port, block)
X_OFS = -8;
if isempty(srchdls) || isempty(dsthdls)
    return;
end
% block to port if necessary
if numel(dsthdls)==1 && strcmp(get_param(dsthdls, 'type'), 'block')
    tmppthdls = get_param(dsthdls, 'PortHandles');
    dsthdls = tmppthdls.Inport;
end
if numel(srchdls)==1 && strcmp(get_param(srchdls, 'type'), 'block')
    tmppthdls = get_param(srchdls, 'PortHandles');
    srchdls = tmppthdls.Outport;
end
% if 1<->N condition
% if numel(srchdls)==1 && numel(dsthdls)>1
%     if strcmp(get_param(srchdls,'type'),'port')
%         srchdls(1:numel(dsthdls)) = srchdls;
%     end
% end
% calculate offset
dstposraw = zeros(numel(dsthdls),2);
for i=1:numel(dsthdls)
    switch get_param(dsthdls(i), 'type')
        case 'line'
            lnpos = get_param(dsthdls(i),'Points');
            dstposraw(i,:)=lnpos(1,:);
        case 'port'
            dstposraw(i,:)=get_param(dsthdls(i),'Position');
    end
end
overlap_offset = zeros(numel(dsthdls),2);
xu = unique(dstposraw(:,1));
for i=1:numel(xu)
    ridx = dstposraw(:,1)==xu(i);
    overlap_offset(ridx, 1) = [(0:sum(ridx)-1)*X_OFS]';
end
% sort by y position
srcpos = zeros(numel(srchdls),2);
dstpos = zeros(numel(dsthdls),2);
for i=1:numel(srchdls)
    switch get_param(srchdls(i), 'type')
        case 'line'
            lnpos = get_param(srchdls(i),'Points');
            if strcmp(get_param(srchdls(i),'Connected'),'off')
                srcpos(i,:)=lnpos(end,:);
            else
                [tmp, im] = min(lnpos(:,1));
                srcpos(i,:)=lnpos(im,:);
            end
        case 'port'
            srcpos(i,:)=get_param(srchdls(i),'Position');
    end
end
for i=1:numel(dsthdls)
    switch get_param(dsthdls(i), 'type')
        case 'line'
            lnpos = get_param(dsthdls(i),'Points');
            dstpos(i,:)=lnpos(1,:);
        case 'port'
            dstpos(i,:)=get_param(dsthdls(i),'Position');
    end
end
[tmp, isrc] = sort(srcpos(:,2));
srchdls = srchdls(isrc);srcpos = srcpos(isrc, :);
[tmp, idst] = sort(dstpos(:,2));
dsthdls = dsthdls(idst);dstpos = dstpos(idst, :);overlap_offset = overlap_offset(idst, :);
for i=1:numel(srchdls)
    xsrc = srcpos(i,1);
    dstidx = find(dstpos(:,1) > xsrc, 1, 'first');
    if isempty(dstidx)
        continue;
    else
        obj.AutoLine(srchdls(i), dsthdls(dstidx), overlap_offset(dstidx,:), varargin{:});
        dsthdls(dstidx)=[];dstpos(dstidx) = [];overlap_offset(dstidx,:) = []; %remove from destination list
    end
end
end