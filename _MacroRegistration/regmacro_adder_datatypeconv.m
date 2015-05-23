function sam = regmacro_adder_datatypeconv
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_datatypeconv');
sam.Pattern = '^(dt|datatype)';
sam.Callback = @adder_datatypeconv;

end

function [actrec, success] =adder_datatypeconv(cmdstr, console)
actrec=saRecorder;success = false;
btobj = console.MapTo('DataTypeConversion');
optstr = regexprep(cmdstr, '^(dt|datatype)\s*', '', 'once');
optstr = regexprep(optstr, '(sgl|dbl|bool|u8|u16|u32|i8|i16|i32)', '${saStandardDataTypeStr($1)}', 'once');
optstr2 = saStandardDataTypeStr(optstr);
console.SessionPara.ExplicitDataType = optstr2; % renew global options
actrec + btobj.RunRoutine(optstr2);
success = true;
end