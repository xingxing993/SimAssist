function proplist = saGetStringDialogParameter(blkhdl)
dlgparas = get_param(blkhdl, 'DialogParameters');
if isstruct(dlgparas)
    idx = structfun(@(fld)strcmp(fld.Type, 'string'), dlgparas);
    paranames = fieldnames(dlgparas);
    proplist = [paranames(idx); cellstr('Name')];
else
    proplist={};
end
end