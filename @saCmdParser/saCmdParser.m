classdef saCmdParser
    properties
        RawStr
        Pattern
        PatternStr
        OptionStr
    end
    methods
        function obj = saCmdParser(cmdstr, pattern)
            if nargin<2
                pattern = '';
            end
            obj.RawStr = cmdstr;
            obj.Pattern = pattern;
            obj.PatternStr = regexp(cmdstr, pattern, 'once','match');
            obj.OptionStr = strtrim(regexprep(cmdstr, pattern, ' ', 'once'));
        end
    end
end