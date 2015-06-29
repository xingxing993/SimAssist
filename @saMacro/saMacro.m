classdef saMacro < handle
    %SAMACRO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Name = ''
        Pattern = ''
        PromptMethod
        Callback       
        
        Type = ''
        % This property controls whether the macro will be tested run
        % earlier, generally:
        % the shorter the command string pattern is, the lower priority
        % (larger number) it shall possess. In this way it is guaranteed
        % that the longer pattern will not be preempted by the shorter
        % pattern when they have same beginning characters
        Priority = 50;
        Console
    end
    
    methods
        function obj=saMacro(varargin)
            if isstr(varargin{1})
                obj.Name = varargin{1};
            end
        end
        
        function set.Pattern(obj, val)
            obj.Pattern = val;
            if isempty(obj.PromptMethod)
                if val(1)=='^'
                    val(1)='';
                end
                prompts = regexp(val, '\|', 'split');
                prompts = regexprep(prompts, '(^\()|(\)$)', '');
                obj.PromptMethod = prompts;
            end
        end
    end
end
