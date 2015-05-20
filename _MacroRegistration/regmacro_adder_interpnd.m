function sam = regmacro_adder_interpnd
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_interpnd');
sam.Pattern = '^(itp|interpnd)';
sam.Callback = @adder_interpnd;

end

function [actrec, success] =adder_interpnd(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('Interpolation_n-D');
optstr = regexprep(cmdstr, '^(itp|interpnd)\s*', '','once');
[val, ndim] = saParseOptionStr('value_num', optstr);
pvpair = {};
if ~isempty(val)
    pvpair = [pvpair, 'Table', val];
end
if ~isempty(ndim)
    pvpair = [pvpair, 'NumberOfTableDimensions', int2str(ndim)];
end
actrec + btobj.RunRoutine('nooptstr', pvpair);
success = true;
end