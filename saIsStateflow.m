function [tf, sftyp] = saIsStateflow(hdl)
if ischar(hdl)
    hdl = get_param(hdl, 'Handle');
end
if isprop(hdl, 'SFBlockType')
    sfbtyp = get_param(hdl, 'SFBlockType');
    if ~strcmpi(sfbtyp, 'NONE')
        switch sfbtyp
            case 'Chart'
                tf = true; sftyp = 'Stateflow';
            case {'Truth Table', 'State Transition Table'}
                tf = true;  sftyp = sfbtyp;
            otherwise
                tf = false; sftyp = '';
        end
    else
        tf = false; sftyp = '';
    end
else
    tf = false; sftyp = '';
end
end