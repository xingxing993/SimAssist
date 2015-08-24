function [result, bclean] = ParseStringAndInteger(obj)
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

valpattern = '[^0-9]\w+\s*';
result.String = regexp(reststr, valpattern, 'match','once');

reststr = strtrim(regexprep(reststr, valpattern, ''));
bclean = isempty(reststr);
end