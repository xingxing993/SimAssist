function timerdisplay(hblk,properties,newvals)
try
    oldcolor=get_param(hblk,'ForegroundColor');
catch
    return;
end
oldannotation=get_param(hblk,'AttributesFormatString');
set_param(hblk,'ForegroundColor','green');
if isstr(properties)
    properties={properties};
    newvals={newvals};
end
dispstr='';
for i=1:numel(properties)
    if ~isstr(newvals{i})
        newvals{i}=num2str(newvals{i});
    end
    dispstr=sprintf('%s%s: %s\n',dispstr,properties{i},newvals{i});
end
set_param(hblk,'AttributesFormatString',dispstr);
tmr=timer('ExecutionMode','singleShot','StartDelay',0.5,'TimerFcn',{@timerfcn,hblk,oldcolor,oldannotation});
start(tmr);
end