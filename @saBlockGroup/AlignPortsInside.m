function actrec=AlignPortsInside(objs)
actrec=saRecorder;
for kk=1:numel(objs)
    obj=objs(kk);
    for i=1:numel(obj.BlockHandles)
        lns=get_param(obj.BlockHandles(i),'LineHandles');
        dy_right=[];dy_left=[];
        for j=1:numel(lns.Outport)
            if lns.Outport(j)>0
                lnpoints=get_param(lns.Outport(j),'Points');
                dy_right=[dy_right;lnpoints(end,2)-lnpoints(1,2)];
            end
        end
        for j=1:numel(lns.Inport)
            if lns.Inport(j)>0
                lnpoints=get_param(lns.Inport(j),'Points');
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
            oldpos=get_param(obj.BlockHandles(i),'Position');
            newpos=oldpos;
            newpos([2,4])=newpos([2,4])+dy;
            appdata=[];
            actrec.SetParam(obj.BlockHandles(i),'Position',newpos);
        end
    end
end
end