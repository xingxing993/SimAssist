function actrec = ReplaceStr(obj, lnhdl, oldstr, newstr)
%
actrec = saRecorder;
nam = get_param(lnhdl, 'Name');
if isempty(nam)
    return;
end
if strcmp(oldstr, '^') % add prefix
    newnam = [newstr, nam];
elseif strcmp(oldstr, '$') % append suffix
    newnam = [nam, newstr];
else
    newnam = regexprep(nam, oldstr, newstr);
end
    actrec.SetParam(lnhdl, 'Name',newnam);
end