function [result, bclean] = ParseInteger(obj)
result = regexp(obj.OptionStr, '\d+', 'match', 'once');
result = str2double(result);
reststr = regexprep(obj.OptionStr, '\d+', '', 'once');
bclean = isempty(reststr);
end