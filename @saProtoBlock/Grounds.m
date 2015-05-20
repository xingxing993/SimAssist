function actrec = Grounds(obj, hdls, varargin)
actrec = saRecorder;
total = numel(hdls);
if total>obj.ShowWaitbarThreshold
    hwtbar=waitbar(0,sprintf('Adding <%s> block to ...',obj.BlockType));
end
for i=1:numel(hdls)
    if total>obj.ShowWaitbarThreshold
        waitbar(i/total,hwtbar,sprintf('Adding <%s> block to %s...',obj.BlockType,strrep(getfullname(hdls(i)),'_','\_')));
    end
    
    if strcmp(get_param(hdls(i), 'Type'), 'line')
        actrec + obj.AddBlockToLine(hdls(i),varargin{:});
    elseif strcmp(get_param(hdls(i), 'Type'), 'port')
        if get_param(hdls(i),'Line')<0
            actrec + obj.AddBlockToPort(hdls(i),varargin{:});
        end
    elseif strcmp(get_param(hdls(i), 'Type'), 'block')
        pts = get_param(hdls(i),'PortHandles');
        for k=1:numel(pts.Inport)
            if get_param(pts.Inport(k),'Line')<0
                actrec + obj.AddBlockToPort(pts.Inport(k),varargin{:});
            end
        end
    end
end
if total>obj.ShowWaitbarThreshold
    close(hwtbar);
end
end