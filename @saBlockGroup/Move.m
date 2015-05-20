function actrec=Move(obj,vect)
actrec=saRecorder;
if any((obj.Boundary(1:2)+vect)<0)
    return;
end
for i=1:obj.BlockCount
    blkvect=[vect,vect]; %L T R B
    oldpos=get_param(obj.BlockHandles(i),'Position');
    newpos=oldpos+blkvect;
    actrec.SetParam(obj.BlockHandles(i),'Position',newpos);
end
end