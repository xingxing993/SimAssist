function liststr = UIGetPromptList(obj, partstr)
if isempty(partstr)
    liststr_str = obj.PromptBuffer.String;
else
    prmpts_strs = obj.PromptBuffer.String;
    liststr_str = prmpts_strs(strncmp(prmpts_strs, partstr, numel(partstr)));
end
liststr_fun = cellfun(@(funhdl)funhdl(partstr), obj.PromptBuffer.FunctionHandle, 'UniformOutput', false); % must be function handle
liststr = [liststr_str, liststr_fun]';
end