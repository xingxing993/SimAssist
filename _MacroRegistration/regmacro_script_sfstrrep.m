function sam = regmacro_script_sfstrrep
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('setter_strrep');
sam.Pattern = '^[^=].*>>.*';
sam.Callback = @setter_sfstrrep;
sam.Priority = 2;

end


function [actrec, success] =setter_sfstrrep(cmdstr, console)
actrec=saRecorder;success = false;
regtmp = regexp(cmdstr, '^([^=].*)>>(.*)','once','tokens');
[oldstr, newstr] = regtmp{:};
sfobjs = sfgco;
renameprops = {'Name', 'LabelString'};
for i=1:numel(sfobjs)
    for k=1:numel(renameprops)
        if sfobjs(i).isprop(renameprops{k})
            if strcmp(oldstr, '^') % add prefix
                newpropstr = [newstr, sfobjs(i).(renameprops{k})];
            elseif strcmp(oldstr, '$') % append suffix
                newpropstr = [sfobjs(i).(renameprops{k}), newstr];
            else
                newpropstr = regexprep(sfobjs(i).(renameprops{k}), oldstr, newstr);
            end
            actrec.StateflowSetParam(sfobjs(i), renameprops{k}, newpropstr);
        end
        break; % CAUTION: Temporary solution: 'Name', 'LabelString' always changes as binding pair
    end
end
success = true;
end