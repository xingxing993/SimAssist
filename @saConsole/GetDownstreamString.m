function thestr = GetDownstreamString(obj, hdl)
%GETOUTPORTSTRING gets representing string on the port
%
if hdl<0
    thestr = '';return;
end

if strcmp(get_param(hdl,'Type'),'block')
    thestr = getdownstreamstr_block(obj, hdl);
elseif strcmpi(get_param(hdl,'Type'),'line')
    lnname = get_param(hdl, 'Name');
    if isempty(lnname) || (lnname(1)=='<' && lnname(end)=='>')
        dstpts = get_param(hdl, 'DstPortHandle');
        thestr = '';
        for kk=1:numel(dstpts) % find the first non-empty string
            if dstpts(kk)>0
                thestr = obj.GetDownstreamString(dstpts(kk));
                if ~isempty(thestr)
                    break;
                end
            end
        end
        return;
    else
        thestr = lnname;return;
    end
elseif strcmpi(get_param(hdl,'Type'),'port')
    pttyp = get_param(hdl, 'PortType');
    if strcmp(pttyp, 'outport')
        lnofpt = get_param(hdl, 'Line');
        thestr = obj.GetDownstreamString(lnofpt);
    elseif strcmp(pttyp, 'inport')
        thestr = getdownstreamstr_inport(obj, hdl);
    elseif strcmp(pttyp, 'trigger')
        thestr = getdownstreamstr_trigger(obj,hdl);
    elseif strcmp(pttyp, 'enable')
        thestr = getdownstreamstr_enable(obj,hdl);
    else
        thestr = '';
    end
end
end


function thestr = getdownstreamstr_block(obj, blkhdl)
if strcmp(get_param(blkhdl,'BlockType'), 'Outport')
    parblk = get_param(blkhdl, 'Parent');
    ptnum = str2double(get_param(blkhdl, 'Port'));
    parpts = get_param(parblk, 'PortHandles');
    thestr = obj.GetDownstreamString(parpts.Outport(ptnum));
else
    blkpts = get_param(blkhdl, 'PortHandles');
    noutport = numel(blkpts.Outport);
    if noutport>0
        thestr = cell(noutport, 1);
        for i=1:noutport
            thestr{i} = obj.GetDownstreamString(blkpts.Outport(i));
        end
        if noutport==1
            thestr = thestr{1};
        end
    else
        thestr = '';
    end
end
end


function thestr = getdownstreamstr_inport(obj,pthdl)
parblk = get_param(get_param(pthdl, 'Parent'), 'Handle');% shall be equal to blkhdl
blklns = get_param(parblk, 'LineHandles');
btobj = obj.MapTo(parblk);
if isempty(btobj)
    thestr='';return;
end
if isempty(btobj.InportStringMethod)
    if numel(blklns.Outport)==1
        ln_thru = blklns.Outport(1);
        thestr = obj.GetDownstreamString(ln_thru);
    else
        thestr = get_param(parblk, 'Name');
    end
elseif isa(btobj.InportStringMethod, 'function_handle')
    n_arg = nargin(btobj.InportStringMethod);
    if n_arg==1
        thestr = btobj.InportStringMethod(pthdl);
    else
        appdata = struct('Console', obj, 'saObject', btobj);
        thestr = btobj.InportStringMethod(pthdl, appdata);
    end
elseif isstr(btobj.InportStringMethod)
    objpars = get_param(parblk, 'ObjectParameters');
    if isfield(objpars, btobj.InportStringMethod)
        thestr = get_param(parblk, btobj.InportStringMethod);
    else
        thestr = btobj.InportStringMethod;
    end
elseif isnumeric(btobj.InportStringMethod) && btobj.InportStringMethod>0
    ln_thru = blklns.Outport(min(btobj.InportStringMethod,end));
    thestr = obj.GetDownstreamString(ln_thru);
    % Special case: SISO, Single input, Single output
else
    thestr = '';
end
if iscellstr(thestr)
    thestr=thestr{1};
end
if isempty(thestr)
    thestr = get_param(parblk, 'Name');
end
end

function thestr = getdownstreamstr_trigger(obj,pthdl)
parsys = get_param(pthdl, 'Parent');
partyp = get_param(parsys, 'MaskType');
if strcmp(partyp, 'Stateflow')
    sfchart = get_param(parsys, 'Object');
    trigobj = sfchart.find('-isa','Stateflow.Event','Scope','Input');
    thestr = trigobj.Name;
else
    trigblk = find_system(parsys, 'LookUnderMasks','on', 'FollowLinks', 'on', 'BlockType', 'TriggerPort');
    thestr = get_param(trigblk, 'Name');
end
end

function thestr = getdownstreamstr_enable(obj,pthdl)
parsys = get_param(pthdl, 'Parent');
enblk = find_system(parsys, 'LookUnderMasks','on', 'FollowLinks', 'on', 'BlockType', 'EnablePort');
thestr = get_param(enblk, 'Name');
end