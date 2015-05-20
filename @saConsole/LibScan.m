function [blks, msktyps] = LibScan(obj, libnames)
if nargin<2 || isempty(libnames)
    syss = find_system('SearchDepth',0);
    if ~isempty(syss)
        [si,v] = listdlg('PromptString','Select from current loaded block diagrams:',...
            'ListSize', [160, 300],...
            'ListString',syss);
        if v
           rtsys = syss(si);
        else
            return;
        end
    else
        [mdlfile, pathname] = uigetfile('*.mdl', 'Pick an model file','MultiSelect', 'on');
        if isequal(mdlfile,0) || isequal(pathname,0)
            return;
        else
            open(fullfile(pathname, mdlfile));
            rtsys = regexprep(mdlfile, '\.mdl$', '', 'once');
        end
    end
    rtsys = cellstr(rtsys);
else
    rtsys = cellstr(libnames);
end
for i=1:numel(rtsys)
    load_system(rtsys{i});
    blks = find_system(rtsys{i}, 'Mask', 'on');
    msktyps = get_param(blks,'MaskType');
    blks = blks(~cellfun('isempty', msktyps));
    msktyps = get_param(blks, 'MaskType');
    % generate excel
    excel = actxserver('excel.application');
    excel.Visible = true;
    wbk = excel.Workbooks.Add;
    sht = wbk.ActiveSheet;
    sht.Cells.Font.Name='Arial Unicode MS'; sht.Cells.Font.Size=10;
    nblk = numel(blks);
    actrng = sht.Range('A1:D1');
    actrng.Value = {'MaskType', 'ShortCut', 'SourcePath', 'Priority'};
    actrng.Interior.Color=13995603;
    actrng.Font.Bold=1;
    actrng.HorizontalAlignment=3;
    actrng.BorderAround(true);
    sht.Range(['A2:A', int2str(1+nblk)]).Value = msktyps;
    sht.Range(['B2:B', int2str(1+nblk)]).Value = lower(msktyps);
    sht.Range(['C2:C', int2str(1+nblk)]).Value = blks;
    sht.Range(['D2:D', int2str(1+nblk)]).Value = 50;
end
