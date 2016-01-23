function [result, bclean] = ParseValuesAndInteger(obj)
% float numbers will also be considered as string, e.g., 1e-3, 12.345, etc.

% find isolated integers, i.e., not trailing "." ,"-" or letters, and not
% preceding ".", and not in bracket (part of sequence expression)
numpattern = '(?<!([.\-\w]|\[.*))\d+(?!(\d*\.|e[+-]?\d|.*\]))';

numstr = regexp(obj.OptionStr, numpattern, 'match', 'once');
if ~isempty(numstr)
    result.Integer = str2double(numstr);
    result.IntegerStr = numstr;
else
    result.Integer = [];
    result.IntegerStr = '';
end
reststr = strtrim(regexprep(obj.OptionStr, numpattern, ' ', 'once'));

tmpvals = regexp(reststr, '(?<!\[.*)(,|\s)+(?!.*\])' ,'split');
if ~isempty(tmpvals) && isempty(tmpvals{end})
    tmpvals(end) = [];
end
result.Values = {};
for i=1:numel(tmpvals)
    result.Values = [result.Values, obj.ParseSeqExpr(tmpvals{i})];
end

bclean = true;
end