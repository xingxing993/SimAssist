function [option, args, optarg] = override_option(args, btobj, local_opt)
% Precondition: if exists, the first structure argument in cell array "args" is option
% The option is in the following priority:
% 1. Externally passed in option argument (as above)
% 2. User specified console.SessionPara
% 3. Prefered option for this specific block
% 4. Local default inside the function
% 5. Default console.RunOption


% local option
if nargin<3
    local_opt = [];
end
% external argument option
i_optarg = find(cellfun(@isstruct, args), 1);
if ~isempty(i_optarg)
    optarg = args{i_optarg};
    args(i_optarg) = [];
else
    optarg = [];
end
% 
blkprefer = btobj.BlockPreferOption;
if ~isempty(btobj.Console)
    consoledefault = btobj.Console.RunOption;
    sessionpara = btobj.Console.SessionPara;
else
    consoledefault = [];
    sessionpara = [];
end
option = saOverrideOption(optarg, sessionpara, blkprefer, local_opt, consoledefault);
end