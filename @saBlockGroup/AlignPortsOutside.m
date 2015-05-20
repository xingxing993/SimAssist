function actrec=AlignPortsOutside(objs)
actrec=saRecorder;
for i=1:numel(objs)
    pts=objs(i).getBGPorts;
    dy_right=[];dy_left=[];
    for j=1:numel(pts.Outports)
        ln=get_param(pts.Outports(j),'Line');
        if ln>0
            lnpoints=get_param(ln,'Points');
            dy_right=[dy_right;lnpoints(end,2)-lnpoints(1,2)];
        end
    end
    for j=1:numel(pts.Inports)
        ln=get_param(pts.Inports(j),'Line');
        if ln>0
            lnpoints=get_param(ln,'Points');
            dy_left=[dy_left;lnpoints(1,2)-lnpoints(end,2)];
        end
    end
    if (all(dy_right>0)||isempty(dy_right))&&(all(dy_left>0)||isempty(dy_left))
        dy=min([dy_right;dy_left]);
    elseif (all(dy_right<0)||isempty(dy_right))&&(all(dy_left<0)||isempty(dy_left))
        dy=max([dy_right;dy_left]);
    else
        dy=0;
    end
    if dy~=0
        actrec.Merge(objs(i).Move([0,dy]));
    end
end
end