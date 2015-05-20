function sam = regmacro_script_change_size
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_change_size');
sam.Pattern = '^(short|long|narrow|wide)';
sam.Callback = @script_change_size;

end

function [actrec, success] =script_change_size(cmdstr, console)
actrec=saRecorder;success = false;
objhdls = saFindSystem(gcs,'block');
type = regexp(cmdstr,'^(short|long|narrow|wide)','match','once');
opt = regexprep(cmdstr,'^(short|long|narrow|wide)e?r?\s*','','once');
if isempty(opt)
    scale = 1.1;
else
    scale = str2double(opt);
    if isnan(scale) || ~scale
        success = false; return;
    end
end
for i=1:numel(objhdls)
    oldpos = get_param(objhdls(i),'Position');
    oldsz = oldpos(3:4)-oldpos(1:2);
    W0 = oldsz(1);   H0 = oldsz(2);
    switch type
        case 'long'
            H1 = H0*scale;
            vt_mid=(oldpos(2)+oldpos(4))/2;
            newpos = [oldpos(1), vt_mid-H1/2, oldpos(3), vt_mid+H1/2];
        case 'short'
            H1 = H0/scale;
            vt_mid=(oldpos(2)+oldpos(4))/2;
            newpos = [oldpos(1), vt_mid-H1/2, oldpos(3), vt_mid+H1/2];
        case 'narrow'
            W1 = W0/scale;
            hz_mid=(oldpos(1)+oldpos(3))/2;
            newpos = [hz_mid-W1/2, oldpos(2), hz_mid+W1/2, oldpos(4)];
        case 'wide'
            W1 = W0*scale;
            hz_mid=(oldpos(1)+oldpos(3))/2;
            newpos = [hz_mid-W1/2, oldpos(2), hz_mid+W1/2, oldpos(4)];
        otherwise
    end
    actrec.SetParam(objhdls(i), 'Position', newpos);
end
success = true;
end