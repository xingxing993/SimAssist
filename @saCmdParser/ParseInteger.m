function [result, bclean] = ParseInteger(obj)
result = regexp(obj.OptionStr, '\d+', 'match', 'once');
if isempty(result)
    result = [];
else
    result = str2double(result);
end
reststr = regexprep(obj.OptionStr, '\d+', '', 'once');
bclean = isempty(strtrim(reststr));
end