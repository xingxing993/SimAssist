function [btobjs, macroobjs] = ImportBlockTypesExcel(obj)
excel = actxGetRunningServer('excel.application');
sht = excel.ActiveSheet;
rawtxt = sht.UsedRange.Value;
btobjs = [];
macroobjs = [];
for i=2:size(rawtxt, 1) % start from 2nd row
    [sabt, sam] = create_saobject(rawtxt{i,:});
    sabt.Console = obj;
    obj.Map(sabt.MapKey) = sabt;
    sam.Console = obj;
    btobjs = [btobjs; sabt];
    macroobjs = [macroobjs; sam];
end
[tmp, iprio] = sort([macroobjs.Priority]);
macroobjs = macroobjs(iprio);
obj.Macros = macroobjs;
end


function [sabt, sam] = create_saobject(varargin)
[msktyp, pattern, srcpath, priority] = varargin{1:4};
dlgparas = get_param(srcpath, 'DialogParameters');
if ~isempty(dlgparas)
    dlgparas = fieldnames(dlgparas);
else
    dlgparas={};
end
blktyp = get_param(srcpath, 'BlockType');
% create saBlock object
sabt = saBlock(blktyp, msktyp, srcpath);
if ~isempty(dlgparas)
    sabt.MajorProperty = dlgparas{1};
end
% create macro object
sam = saMacroAdder(sabt, pattern);
sam.Priority = priority;
end
