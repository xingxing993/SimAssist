function [newpos, rectd] = saRectifyPos(pos)
% pos can be block size (4x1) or port position (2x1)
newpos = pos;
rectd = false;
if numel(pos)>2
    if pos(3)<pos(1)
        newpos(3) = pos(1)+1;
        rectd = true;
    end
    if pos(4)<pos(2)
        newpos(4) = pos(2)+1;
        rectd = true;
    end
end
if verLessThan('Simulink', '8.0')
    if pos(1)<0
        pos(1)=0;
        if numel(pos)>2
            newpos(3) = pos(3)-pos(1);
        end
        rectd = true;
    end
    if pos(2)<0
        pos(2)=0;
        if numel(pos)>2
            newpos(4) = pos(4)-pos(2);
        end
        rectd = true;
    end
end
end