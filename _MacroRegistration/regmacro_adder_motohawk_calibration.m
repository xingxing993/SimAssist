function sam = regmacro_adder_motohawk_calibration
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_motohawk_calibration');
sam.PromptMethod = 'mh cal';
sam.Pattern = '^mh\s*(cal)';
sam.Callback = @adder_motohawk_calibration;
sam.Priority = 20;
end

function [actrec, success] = adder_motohawk_calibration(cmdstr, console)
rtsys = gcs;
if ~bdIsLoaded('MotoHawk_lib')
    bkcs = gcs;
    load_system('MotoHawk_lib');
    load_system(bkcs);
    open_system(rtsys); % restore current system
end

btobj = console.MapTo('MotoHawk Calibration');
optstr = strtrim(regexprep(cmdstr, '^mh\s*(cal)\s*', '', 'once'));
[val,num] = saParseOptionStr('value_num',optstr);
if isempty(num) && isempty(val)
    pvpair = {};
elseif isempty(num) && ~isempty(val)
    pvpair = {'nam', ['''',val,''''], 'val', val};
elseif ~isempty(num) && isempty(val)
    pvpair={'val', int2str(num)};
else
    pvpair={'nam', ['''',val,''''], 'val', int2str(num)};
end
[actrec, success] = btobj.RunRoutine('nooptstr', pvpair);
end