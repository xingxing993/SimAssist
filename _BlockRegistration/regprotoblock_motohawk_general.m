function sabt = regprotoblock_motohawk_general
%REGTYPE_???
% Registration of ??? type in SimAssist

sabt = saProtoBlock('motohawk_general');
sabt.CheckMethod = @check_proto;
sabt.ProtoProperty = ...
    {'MajorProperty', 'DictRenameMethod',...
    'InportStringMethod', 'OutportStringMethod',...
    'PropagateUpstreamStringMethod', 'PropagateDownstreamStringMethod', ...
    'RefineMethod', 'DataTypeMethod'};

sabt.MajorProperty = 'nam';
sabt.DictRenameMethod = {'nam','val','breakpoint_data','row_breakpoint_data','col_breakpoint_data','table_data'};

sabt.InportStringMethod = @(hdl)strrep(get_param(hdl, 'nam'), '''', '');
sabt.OutportStringMethod = @(hdl)strrep(get_param(hdl, 'nam'), '''', '');

sabt.PropagateUpstreamStringMethod = @set_string;
sabt.PropagateDownstreamStringMethod = @set_string;
sabt.RefineMethod = @refine_method;
sabt.DataTypeMethod = @set_datatype;

end

function tf = check_proto(blkhdl)
msktyp = get_param(blkhdl, 'MaskType');
if ~isempty(regexp(msktyp,'^MotoHawk', 'once'))
    tf = true;
else
    tf = false;
end
end


function actrec = set_string(blkhdl, str)
actrec = saRecorder;
objparas = get_param(blkhdl, 'ObjectParameters');
if isfield(objparas, 'nam')
    actrec.SetParam(blkhdl, 'nam', ['''', str, '''']);
end
if isfield(objparas, 'val')
    actrec.SetParam(blkhdl, 'val', str);
end
end

function actrec = refine_method(blkhdl)
actrec = saRecorder;
objparas = get_param(blkhdl, 'ObjectParameters');
if isfield(objparas, 'nam') && isfield(objparas, 'val')
    nam=get_param(blkhdl,'nam');
    val=get_param(blkhdl,'val');
    if isempty(nam)
        if isempty(val)
            return;
        else
            nam = ['''', val, ''''];
        end
    else
        val = strrep(nam, '''', '');
    end
    actrec.SetParam(blkhdl,'nam',nam,'val',val,'Name',val);
end
end

function actrec = set_datatype(blkhdl, dt)
actrec = saRecorder;
if isempty(dt)
    return;
end
dlgparas=get_param(blkhdl,'DialogParameters');
if isfield(dlgparas,'data_type')
    actrec.SetParamHighlight(blkhdl,'data_type',dt);
elseif isfield(dlgparas,'table_data_type')
    actrec.SetParamHighlight(blkhdl,'table_data_type',dt);
elseif isfield(dlgparas,'dt')
    actrec.SetParamHighlight(blkhdl,'dt',dt);
elseif isfield(dlgparas,'typ')
    actrec.SetParamHighlight(blkhdl,'typ',dt);
else
end
end