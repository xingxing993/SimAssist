function [result, bclean] = ParseMultiValues(obj, nmax)
% float numbers will also be considered as string, e.g., 1e-3, 12.345, etc.

if isempty(obj.OptionStr)
    result = {};
else
    result = regexp(obj.OptionStr, '[,\s]+' ,'split');
end
if nargin>1 && numel(result)>nmax
    bclean = false;
else
    bclean = true;
end
end