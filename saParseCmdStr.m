function varargout = saParseCmdStr(cmdstr, pattern, varargin)
if nargin<2
    patstr = '';
    optstr = strtrim(cmdstr);
else
    patstr = regexp(cmdstr, pattern, 'once','match');
    optstr = strtrim(regexprep(cmdstr, pattern, ' ', 'once'));
end
% extract value expression string
valpattern = '[a-zA-Z_]\w*';
alphastr = regexp(optstr, valpattern, 'match','once');
% extract numeric value
reststr = strtrim(regexprep(optstr, valpattern, ' ', 'once'));
numpattern = '[-+]?\d+[.]?\d*([eE][-+]?\d+)?';
numstr = regexp(reststr, numpattern, 'match','once');
if isempty(numstr)
    num=[];
else
    num=str2double(numstr);
end
% split segments pattern
segs = regexp(optstr, '\s+|,', 'split');
segs = segs(~cellfun('isempty',segs));

% output
varargout{1} = struct(...
    'CommandStr', cmdstr,...
    'PatternStr', patstr,...
    'OptionStr', optstr, ...
    'ValueStr', alphastr,...
    'Num', num,...
    'NumStr', numstr,...
    'Segments', {segs});

end