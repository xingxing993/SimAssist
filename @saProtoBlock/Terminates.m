function actrec = Terminates(obj, hdls, varargin)
actrec = saRecorder;
total = numel(hdls);
if total>obj.ShowWaitbarThreshold
    hwtbar=waitbar(0,sprintf('Adding <%s> block to ...',obj.BlockType));
end

% adjust block position according to mouse position
if numel(hdls)>0
    lnhdls = hdls(strcmp(get_param(hdls, 'Type'), 'line'));
    if ~isempty(lnhdls)
        if obj.Console.RunOption.GetMarginByMouse
            c_lnpts = get_param(lnhdls, 'Points');
            if ~iscell(c_lnpts)
                c_lnpts = {c_lnpts};
            end
            ps = cat(1, c_lnpts{:});
            ymx = max(ps(:,2)); ymn = min(ps(:,2));
            xy0 = saGetMousePosition;
            % prepare local option
            local_opt.ToLineOffset = obj.LayoutSize.ToLineOffset;
            if xy0(2)>ymx
                local_opt.ToLineOffset(2) = xy0(2)-ymx;
            elseif xy0(2)<ymn
                local_opt.ToLineOffset(2) = xy0(2)-ymn;
            end
        else
            local_opt.ToLineOffset = obj.LayoutSize.ToLineOffset;
        end
        local_opt.PropagateString = true;
        [option, argsin, optarg] = override_option(varargin, obj, local_opt);
        varargin = [{option}, argsin];
    end
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
        for k=1:numel(pts.Outport)
            if get_param(pts.Outport(k),'Line')<0
                actrec + obj.AddBlockToPort(pts.Outport(k),varargin{:});
            end
        end
    end
end
if total>obj.ShowWaitbarThreshold
    close(hwtbar);
end
end