function varargout = saParseOptionStr(opttype, optstr, varargin)
switch opttype
    case 'value_only'
        [varargout{1:nargout}] = parsetype_value_only(optstr);
    case 'value_num'
        [varargout{1:nargout}] = parsetype_value_num(optstr);
    case 'values'
        varargout{1} = parsetype_multiprop(optstr);
    otherwise
        varargout = varargin;
end
end

%%
function [val, num] = parsetype_value_num(optstr)
valpattern = '[a-zA-Z]\w*';
val = regexp(optstr, valpattern, 'match','once');
numstr = strtrim(regexprep(optstr, valpattern, '', 'once'));
if isempty(numstr)
    num=[];
else
    num=str2double(numstr);
end
end

%%
function [val,num] = parsetype_value_only(optstr)
val = strtrim(optstr);
num=[];
end

%%
function cvals = parsetype_multiprop(optstr)
cvals = regexp(optstr, '\s+|,', 'split');
cvals = cvals(~cellfun('isempty',cvals));
end