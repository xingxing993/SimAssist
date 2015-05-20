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
if isfield(option, 'ExplicitDataType')
    actrec.Merge(obj.SetDataType(blkhdl, option.ExplicitDataType));
elseif option.AutoDataType && ~isempty(obj.DataTypeMethod)
    actrec.Merge(obj.SetDataType(blkhdl));
end
end