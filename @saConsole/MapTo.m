function varargout = MapTo(obj, recvr)

% SAOBJ = MAPTO(OBJ, RECVR) determines the map key, and gets the saObject, saBlock or
% saProtoBlock type definition object
% RECVR may be:
% - handle of a block, line, port, annotation
% - string of map key (blocktype, masktype, blockpath or #protoblock)
% - string of block full path

saobj = [];
% first try exact match in BlockMap
if isnumeric(recvr)
    typ = get_param(recvr,'Type');
    switch typ
        case {'line','port','annotation'}
            if obj.BlockMap.isKey(typ)
                saobj = obj.BlockMap(typ);
            end
        case 'block'
            mapkey = saGetBlockMapKey(recvr);
            if obj.BlockMap.isKey(mapkey)
                saobj = obj.BlockMap(mapkey);
            end
        otherwise
    end
elseif ischar(recvr)
    mapkey = saGetBlockMapKey(recvr);
    if obj.BlockMap.isKey(mapkey)
        saobj = obj.BlockMap(mapkey);
    end
else
    % DEAD CODE
end

% if exact map not found in BlockMap, try to locate in ProtoBlocks
if isempty(saobj)
    for i=1:numel(obj.ProtoBlocks)
        mapkey = obj.ProtoBlocks(i).MapKey; 
        if isstr(recvr) && ismember(mapkey, {recvr, ['#',recvr]})
            saobj = obj.ProtoBlocks(i);break;
        else
            try
                blkhdl = get_param(recvr, 'Handle');
                if obj.ProtoBlocks(i).Check(blkhdl)
                    saobj = obj.ProtoBlocks(i);break;
                end
            end
        end
    end
end

% if still failed to map, return an empty saBlock object
if isempty(saobj)
    saobj = saBlock('#NO_MATCH#');
end
varargout{1} = saobj;
