function actrec = DictRename(obj, blkhdl)
%
actrec = saRecorder;
nam=get_param(objs(i),'Name');
newnam=saDictRenameString(nam,obj.Dictionary);
actrec.SetParam(objs(i), 'Name', newnam);
end