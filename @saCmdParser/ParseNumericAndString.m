function [result, bclean] = ParseNumericAndString(obj)

numpattern = '([-+]?\d+[.]?\d*([eE][-+]?\d+)?)';
numstr = regexp(obj.OptionStr, numpattern, 'match', 'once');
if ~isempty(numstr)
    result.Numeric = str2double(numstr);
    result.NumericStr = numstr;
else
    result.Numeric = [];
    result.NumericStr = '';
end
reststr = strtrim(regexprep(obj.OptionStr, numpattern, ' ', 'once'));

valpattern = '\w+';
result.String = regexp(reststr, valpattern, 'match', 'once');
reststr = strtrim(regexprep(reststr, valpattern, '', 'once'));
bclean = isempty(reststr);
end