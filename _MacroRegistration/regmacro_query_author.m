function sam = regmacro_query_author
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('query_author');
sam.Pattern = '^[Aa]uthor\?';
sam.Callback = @query_author;

end

function [actrec, success] =query_author(cmdstr, console)
actrec=saRecorder;success = false;


success = true;
end