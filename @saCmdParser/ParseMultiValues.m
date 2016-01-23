function [vals, bclean] = ParseMultiValues(obj, nmax)
% float numbers will also be considered as string, e.g., 1e-3, 12.345, etc.
if nargin<2
    nmax = inf;
end
if isempty(obj.OptionStr)
    result = {};
else
    result = regexp(obj.OptionStr, '(?<!\[.*)(,|\s)+(?!.*\])' ,'split');
end
if ~isempty(result) && isempty(result{end})
    result(end) = [];
end
vals = {};
for i=1:numel(result)
    vals = [vals, obj.ParseSeqExpr(result{i})];
end
if nargin>1 && numel(vals)>nmax
    bclean = false;
else
    bclean = true;
end
end