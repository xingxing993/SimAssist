function [result, bclean] = ParseValuesAndInteger(obj)
% float numbers will also be considered as string, e.g., 1e-3, 12.345, etc.

% find isolated integers, i.e., not trailing "." ,"-" or letters, and not
% preceding "."
numpattern = '(?<![.\-\w])\d+(?!(\d*\.|e[+-]?\d))';
numstr = regexp(obj.OptionStr, numpattern, 'match', 'once');
if ~isempty(numstr)
    result.Integer = str2double(numstr);
    result.IntegerStr = numstr;
else
    result.Integer = [];
    result.IntegerStr = '';
end
reststr = strtrim(regexprep(obj.OptionStr, numpattern, ' ', 'once'));

if ~isempty(strfind(reststr, ','))
    result.Values = regexp(reststr, ',' ,'split');
else
    result.Values = regexp(reststr, '\s+' ,'split');
end
if isempty(result.Values{end})
    result.Values(end) = [];
end
bclean = true;
end