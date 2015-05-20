function thestr = GetUpstreamString(obj, hdl)
%GETOUTPORTSTRING gets representing string on the port
%
if hdl<0
    thestr = '';return;
end

if strcmp(get_param(hdl,'Type'),'block')
    thestr = getupstreamstr_block(obj, hdl);
elseif strcmp(get_param(hdl,'Type'),'line')
    lnname = regexprep(get_param(hdl, 'Name'),'[<>]','');
    if isempty(lnname)
        srcpt = get_param(hdl, 'SrcPortHandle');
        if srcpt<0
            thestr = ''; 
        else
            thestr = obj.GetUpstreamString(srcpt);
        end
    else
        thestr = lnname;
    end
elseif strcmp(get_param(hdl,'Type'),'port') %port
    pttyp = get_param(hdl, 'PortType');
    if ismember(get_param(hdl, 'PortType'), {'inport','trigger','enable'})
        lnofpt = get_param(hdl, 'Line');
        thestr = obj.GetUpstreamString(lnofpt);
    elseif strcmp(pttyp, 'outport')
        thestr = getupstreamstr_outport(obj, hdl);
    else
    end
end
end

function thestr = getupstreamstr_block(obj, blkhdl)
blktyp = get_param(blkhdl,'BlockType');
if ismember(blktyp, {'Inport','EnablePort','TriggerPort'})
    parblk = get_param(blkhdl, 'Parent');
    parpts = get_param(parblk, 'PortHandles');
    switch blktyp
        case 'Inport'
            ptnum = str2double(get_param(blkhdl, 'Port'));
            thestr = obj.GetUpstreamString(parpts.Inport(ptnum));
        case 'EnablePort'
            thestr = obj.GetUpstreamString(parpts.Enable);
        case 'TriggerPort'
            thestr = obj.GetUpstreamString(parpts.Trigger);
        otherwise
    end
else
    blkpts = get_param(blkhdl, 'PortHandles');
    ninport = numel(blkpts.Inport);
    if ninport>0
        thestr = cell(ninport, 1);
        for i=1:ninport
            thestr{i} = obj.GetUpstreamString(blkpts.Inport(i));
        end
        if ninport==1
            thestr = thestr{1};
        end
    else
        thestr = '';
    end
end
end

function thestr = getupstreamstr_outport(obj, pthdl)
parblk = get_param(get_param(pthdl, 'Parent'), 'Handle');
blklns = get_param(parblk, 'LineHandles');
ppgtsig = get_param(pthdl,'PropagatedSignals');
btobj = obj.MapTo(parblk);
if isempty(btobj)
    thestr='';return;
end
if ~isempty(ppgtsig)&&strcmpi(get_param(pthdl,'ShowPropagatedSignals'),'on')
    thestr=ppgtsig;
else
    if isempty(btobj.OutportStringMethod)
        if numel(blklns.Inport)==1
            ln_thru = blklns.Inport;
            thestr = obj.GetUpstreamString(ln_thru);
        else
            thestr = get_param(parblk, 'Name');
        end
    elseif isa(btobj.OutportStringMethod, 'function_handle')
        n_arg = nargin(btobj.OutportStringMethod);
        if n_arg==1
            thestr = btobj.OutportStringMethod(pthdl);
        else
            appdata = struct('Console', obj, 'saObject', btobj);
            thestr = btobj.OutportStringMethod(pthdl, appdata);
        end
    elseif isstr(btobj.OutportStringMethod)
        objpars = get_param(parblk, 'ObjectParameters');
        if isfield(objpars, btobj.OutportStringMethod)
            thestr = get_param(parblk, btobj.OutportStringMethod);
        else
            thestr = btobj.OutportStringMethod;
        end
    elseif isnumeric(btobj.OutportStringMethod) && btobj.OutportStringMethod>0
        ln_thru = blklns.Inport(min(btobj.OutportStringMethod,end));
        thestr = obj.GetUpstreamString(ln_thru);
        % Special case: SISO, Single input, Single output
    else
        thestr = '';
    end
end
if iscellstr(thestr)
    thestr=thestr{1};
end
if isempty(thestr)
    thestr = get_param(parblk, 'Name');
end

end