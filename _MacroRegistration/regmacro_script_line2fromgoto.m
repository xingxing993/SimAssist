function sam = regmacro_script_line2fromgoto
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_line2fromgoto');
sam.Pattern = '^line2fg';
sam.Callback = @script_line2fromgoto;

sam.Priority = 20;

end

function [actrec, success] =script_line2fromgoto(cmdstr, console)
actrec=saRecorder;success = false;
optstr=strrep(cmdstr,'line2fg','');
givenname = strtrim(optstr);
lnhdls=saFindSystem(gcs,'line');
if isempty(lnhdls)
    return;
end
btfrom = console.MapTo('From');
btgoto = console.MapTo('Goto');
option.PropagateString = false; % do not propagate
for i=1:numel(lnhdls)
    % collect informations
    if isempty(givenname)
        gototag = console.GetUpstreamString(lnhdls(i));
        if isempty(gototag)
            gototag = ['line', int2str(i)];
        end
    else
        gototag = givenname;
    end
    dstpts = get_param(lnhdls(i),'DstPortHandle');
    srcpt = get_param(lnhdls(i),'SrcPortHandle');
    srclinepoints = shorten_line(lnhdls(i));
    % start take action
    actrec.DeleteLine(lnhdls(i));
    newsrclnhdl = actrec.AddLine(gcs, srclinepoints);
    [actrec2, gotoblock] = btgoto.AddBlockToLine(newsrclnhdl, option, 'GotoTag', gototag);
    actrec + actrec2;
    fcolor = get_param(gotoblock, 'ForegroundColor');
    option.Color = false; % turn off auto color behaviour
    for k=1:numel(dstpts)
        actrec + btfrom.AddBlockToPort(dstpts(k), option, 'GotoTag', gototag, 'ForegroundColor', fcolor);
    end
end
success = true;
end

function newpts = shorten_line(lnhdl)
lnpoints = get_param(lnhdl,'Points');
tmppts=lnpoints(1:2,:);
vec = lnpoints(2,:)-lnpoints(1,:);pn = vec;
pn(pn>0)=1; pn(pn<0)=-1;
tmppts(2,:) = tmppts(1,:) + min(abs(vec), [20, 10]).*pn;
if tmppts(1,2)==tmppts(2,2)
    newpts = tmppts;
else
    newpts = [tmppts; tmppts(2,:)+[15,0]];
end
end