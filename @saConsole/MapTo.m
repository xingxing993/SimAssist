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
            saobj = getkey(obj.BlockMap, typ);
        case 'block'
            mapkey = saGetBlockMapKey(recvr);
            saobj = getkey(obj.BlockMap, mapkey);
        otherwise
    end
elseif ischar(recvr)
    mapkey = saGetBlockMapKey(recvr);
    saobj = getkey(obj.BlockMap,mapkey);
else
    % DEAD CODE
end

% if exact map not found in BlockMap, try to locate in ProtoBlocks
if isempty(saobj)
    for i=1:numel(obj.ProtoBlocks)
        mapkey = obj.ProtoBlocks(i).MapKey; 
        if ischar(recvr) && ismember(mapkey, {recvr, ['#',recvr]})
            saprotoobj = obj.ProtoBlocks(i);break;
        else
            try
                blkhdl = get_param(recvr, 'Handle');
                if obj.ProtoBlocks(i).Check(blkhdl)
                    saprotoobj = obj.ProtoBlocks(i);break;
                end
            end
        end
    end
end

% if still failed to map, return a new saBlock object
if isempty(saobj)
    saobj = saBlock(recvr);
    if exist('saprotoobj', 'var')==1 && ~isempty(saprotoobj)
        saobj.UseProto(saprotoobj);
    end
end
varargout{1} = saobj;
end



function res = getkey(map, key)
    ir = strcmp(map(:,1), key);
    if any(ir)
        res = map{ir, 2};
    else
        res = [];
    end
end

% function tf = iskey(map, key)
%     tf = any(strcmp(map(:,1), key));
% end