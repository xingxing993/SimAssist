function actrec = DictRename(obj, blkhdl)
%
actrec = saRecorder;
nam=get_param(blkhdl,'Name');
newnam=saDictRenameString(nam,obj.Dictionary);
actrec.SetParam(blkhdl, 'Name', newnam);
end