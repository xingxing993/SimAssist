function dt = saStandardDataTypeStr(rawdt)
switch rawdt
    case {'single', 'sgl'}
        dt = 'single';
    case {'double', 'dbl'}
        dt = 'double';
    case {'boolean', 'bool'}
        dt = 'boolean';
    case {'uint8', 'u8'}
        dt = 'uint8';
    case {'uint16', 'u16'}
        dt = 'uint16';
    case {'uint32', 'u32'}
        dt = 'uint32';
    case {'int8', 'i8'}
        dt = 'int8';
    case {'int16', 'i16'}
        dt = 'int16';
    case {'int32', 'i32'}
        dt = 'int32';
    otherwise
        dt='';
end
end
