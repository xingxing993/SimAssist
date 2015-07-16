function actrec = Adapt(obj, blkhdl, option)
actrec = saRecorder;
if nargin<3
    console = obj.Console;
    if ~isempty(console)
        option = console.RunOption;
    else
        return;
    end
end
if option.AutoSize && ~isempty(obj.AutoSizeMethod)
    actrec.Merge(obj.AutoSize(blkhdl));
end
if option.Color && ~isempty(obj.ColorMethod)
    actrec.Merge(obj.Color(blkhdl));
end
if option.Annotation && ~isempty(obj.AnnotationMethod)
    actrec.Merge(obj.Annotate(blkhdl));
end
if option.Refine && ~isempty(obj.RefineMethod)
    actrec.Merge(obj.Refine(blkhdl));
end
% note that SetDataType method uses SetParamHighlight, it shall be last executed
if ~isempty(obj.Console) && isfield(obj.Console.SessionPara, 'DataType') && ~isempty(obj.Console.SessionPara.DataType)
    actrec.Merge(obj.SetDataType(blkhdl, obj.Console.SessionPara.DataType));
elseif option.AutoDataType && ~isempty(obj.DataTypeMethod)
    actrec.Merge(obj.SetDataType(blkhdl));
else
end
end