function sam = regmacro_temp_dsmlib
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('temp_dsmlib');
sam.Pattern = '^(tmpaddio)';
sam.Callback = @temp_dsmlib;

end

function [actrec, success] =temp_dsmlib(cmdstr, console)
actrec=saRecorder;success = false;
optstr = regexprep(cmdstr, 'tmpaddio', '');
lns = get_param(gcb,'LineHandles');
pts = get_param(gcb,'PortHandles');
lnname = get_param(lns.Inport(1),'Name');
kw = regexprep(lnname, 'VDSM_(\w+?)(Err|Warn)?_flg', '$1');
cnstbt = console.MapTo('Constant');
opbt = console.MapTo('Outport');
termbt = console.MapTo('Terminator');
gndbt = console.MapTo('Ground');
option.PropagateString = false;
if optstr=='1'
    cnstbt.AddBlockToPort(pts.Inport(2), option, 'Value', ['VDSM_', kw, 'ErrThld1_cnt']);
    gndbt.AddBlockToPort(pts.Inport(3));
    opbt.AddBlockToPort(pts.Outport(1), option, 'Name', ['VDSM_', kw, 'ErrAct1_flg']);
    termbt.AddBlockToPort(pts.Outport(2));
elseif optstr=='2'
    cnstbt.AddBlockToPort(pts.Inport(2), option, 'Value', ['VDSM_', kw, 'ErrThld1_cnt']);
    cnstbt.AddBlockToPort(pts.Inport(3), option, 'Value', ['VDSM_', kw, 'ErrThld2_cnt']);
    opbt.AddBlockToPort(pts.Outport(1), option, 'Name', ['VDSM_', kw, 'ErrAct1_flg']);
    opbt.AddBlockToPort(pts.Outport(2), option, 'Name', ['VDSM_', kw, 'ErrAct2_flg']);
else
    cnstbt.AddBlockToPort(pts.Inport(3), option, 'Value', ['VDSM_', kw, 'WarnThld_cnt']);
    cnstbt.AddBlockToPort(pts.Inport(4), option, 'Value', ['VDSM_', kw, 'ErrThld1_cnt']);
    cnstbt.AddBlockToPort(pts.Inport(5), option, 'Value', ['VDSM_', kw, 'ErrThld2_cnt']);
    opbt.AddBlockToPort(pts.Outport(1), option, 'Name', ['VDSM_', kw, 'WarnAct_flg']);
    opbt.AddBlockToPort(pts.Outport(2), option, 'Name', ['VDSM_', kw, 'ErrAct1_flg']);
    opbt.AddBlockToPort(pts.Outport(3), option, 'Name', ['VDSM_', kw, 'ErrAct2_flg']);    
end
success = true;
end