function actrec = SetDataType(obj, blkhdl, dt)
actrec = saRecorder;

setdtmethod = obj.DataTypeMethod;
console = obj.Console;

if isempty(setdtmethod)
    return;
end

if nargin<3
    dt='';
    hilite = false;
else
    hilite = true;
end
if ~isempty(console) && isfield(console.SessionPara, 'DataType')
    dt = console.SessionPara.DataType;
end
if isempty(dt)
    majprop = obj.GetMajorProperty;
    if ~isempty(majprop)
        dt = analyze_datatype(get_param(blkhdl, majprop));
    end
end
if isempty(dt)
    dt = console.RunOption.DataType;
end

if isa(setdtmethod, 'function_handle')
    nn = nargout(setdtmethod);
    ni = nargin(setdtmethod);
    argsin = {blkhdl, dt};
    if nn~=0 %if mandatory output exist, must be saRecorder
        actrec.Merge(setdtmethod(argsin{1:ni}));
    else
        setdtmethod(setdtmethod(argsin{1:ni}));
    end
elseif isstr(setdtmethod) % if string, it shall be the data type property
    if ~isempty(dt)
        if hilite
            actrec.SetParamHighlight(blkhdl, setdtmethod, dt);
        else
            actrec.SetParam(blkhdl, setdtmethod, dt);
        end
    end
elseif isequal(setdtmethod, -1)
    if ~isempty(dt)
        dlgparas = get_param(blkhdl, 'ObjectParameters');
        if isfield(dlgparas, 'OutDataTypeStr')
            if hilite
                actrec.SetParamHighlight(blkhdl, 'OutDataTypeStr', dt);
            else
                actrec.SetParam(blkhdl, 'OutDataTypeStr', dt);
            end
        end
    end
else
end
end