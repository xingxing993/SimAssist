function actrec = SetProperty(obj, lnhdl, propval, ~)
actrec = saRecorder;
actrec.SetParam(lnhdl, 'Name', propval);
end