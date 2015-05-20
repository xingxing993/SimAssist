function opt = saOverrideOption(varargin)
% varargin shall be cell array of struct that holds different level of
% options, the former arguments takes higher priority
% this function merge and overrides option in priority
opt = struct;
for i=nargin:-1:1
    tmpopt = varargin{i};
    if ~isstruct(tmpopt)
        continue;
    end
    flds = fieldnames(tmpopt);
    for k=1:numel(flds)
        opt.(flds{k}) = tmpopt.(flds{k});
    end
end
end