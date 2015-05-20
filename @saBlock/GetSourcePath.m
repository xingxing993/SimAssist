function path = GetSourcePath(obj)
if isempty(obj.SourcePath)
    path = '';
elseif isempty(strfind(obj.SourcePath, '/'))
    path = ['built-in/',obj.SourcePath];
else
    path = obj.SourcePath;
end
end