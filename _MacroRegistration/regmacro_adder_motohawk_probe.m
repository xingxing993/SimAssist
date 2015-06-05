function sam = regmacro_adder_motohawk_probe
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_motohawk_probe');
sam.Pattern = '^mh\s*(prb|probe)';
sam.Callback = @adder_motohawk_probe;
sam.PromptMethod = {'mh prb', 'mh probe'};
sam.Priority = 20;
end

function [actrec, success] = adder_motohawk_probe(cmdstr, console)
actrec=saRecorder;success = false;
rtsys = gcs;
if ~bdIsLoaded('MotoHawk_lib')
    bkcs = gcs;
    load_system('MotoHawk_lib');
    load_system(bkcs);
    open_system(rtsys); % restore current system
end
btobj = console.MapTo('MotoHawk Probe');
optstr = strtrim(regexprep(cmdstr, '^mh\s*(prb|probe)\s*', '', 'once'));
[val, num] = saParseOptionStr('value_num', optstr);
numstr = int2str(num);
actrec + btobj.RunRoutine('value_num', numstr, {'nam', ['''',val,'''']});
success = true;
end