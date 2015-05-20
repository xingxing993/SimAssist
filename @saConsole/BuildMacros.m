function varargout = BuildMacros(obj)
pold = pwd;

p = mfilename('fullpath');
sepidx = strfind(p, filesep);
regfolder = [p(1:sepidx(end-1)), '_MacroRegistration'];
fs = what(regfolder);
regfs = [fs.m, fs.p];
regfs = regexprep(regfs, '\.(m|p)$','');
cd(regfolder);
macros_tmp = obj.Macros;
for i=1:numel(regfs)
    regobjs = eval(regfs{i});
    macros_tmp = [macros_tmp; regobjs];
end

%remove empty patterns
idx = cellfun('isempty',{macros_tmp.Pattern}');
macros_tmp = macros_tmp(~idx);
%sort by priority
[tmp, iprio] = sort([macros_tmp.Priority]);
macros_tmp = macros_tmp(iprio);

obj.Macros = macros_tmp;
[obj.Macros.Console] = deal(obj);
% buffer prompt list
prmpts = {obj.Macros.PromptMethod};
prmpts = prmpts(~cellfun('isempty', prmpts));
idxfun = cellfun(@(c)isa(c,'function_handle'), prmpts);
obj.PromptBuffer.String = unique([{},prmpts{~idxfun}]);
obj.PromptBuffer.FunctionHandle = prmpts(idxfun);
%
cd(pold);
end