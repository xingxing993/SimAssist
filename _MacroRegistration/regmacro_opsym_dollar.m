function sam = regmacro_opsym_dollar
% Registration of ??? macro in SimAssist

sam = saMacro('opsym_dollar');
sam.Pattern = '^\$';
sam.Callback = @opsym_dollar;
sam.Priority = 1; % $ operator shall first be tested
end

function [actrec, success] = opsym_dollar(cmdstr, console)
% test & joint of multiple commands
actrec = saRecorder; success = false;
optstr = strtrim(cmdstr(2:end));
if isempty(optstr)
    return;
end
if ismember(optstr, {'+','add'})
    add_new_block(console);
    success = true;
elseif optstr(1)=='-'
    opt = strtrim(optstr(2:end));
    if strcmp(opt, 'block')
        remove_sablock(console);
    elseif strcmp(opt, 'macro')
        remove_samacro(console);
    end
    success = true;
elseif strcmp(optstr, 'cmdlist')
    disp(console.UIGetPromptList(''));
    success = true;
elseif strcmp(optstr, 'saveas')
    saveas(console);
    success = true;
elseif strcmp(optstr, 'import')
    success = true;
else
    success = false;
end
end

function add_new_block(console)
newbt = saBlock(gcbh);
console.AddsaBlock(newbt);
msktyp = get_param(gcbh,'MaskType');
if ~isempty(msktyp)
    defaultpattern = lower(msktyp);
else
    defaultpattern = lower(get_param(gcbh,'Name'));
end
options.Resize='on';
options.WindowStyle='normal';
info = saDlg_AddNewBlock;
if ~isempty(info) && ~isempty(info.RoutinePattern)
    flds = fieldnames(info);
    for i=1:numel(flds)
        newbt.(flds{i}) = info.(flds{i});
    end
    sam = newbt.CreateRoutineMacro; % new default block macro
    console.AddMacro(sam);
    % backup newly added objects
    console.Newer = [console.Newer; newbt];
end
end


function remove_sablock(console)
sablkitems = console.BlockMap.keys';
protoblkitems = {console.ProtoBlocks.MapKey}';
liststr = [sablkitems;protoblkitems];
if ~isempty(liststr)
    [s,v] = listdlg('PromptString','Select block(s) to be removed:',...
        'OKString', 'Remove',...
        'SelectionMode','multiple',...
        'ListString',liststr);
    if v
        itms = liststr(s);
        % first remove proto blocks
        [protormvs, ia] = intersect(protoblkitems, itms);
        console.ProtoBlocks(ia) = [];
        maprmvs = setdiff(itms, protormvs);
        for i=1:numel(maprmvs)
            console.BlockMap.remove(maprmvs{i});
        end
    end
    
end
end

function remove_samacro(console)
liststr = {console.Macros.Name}';
if ~isempty(liststr)
    [s,v] = listdlg('PromptString','Select macro(s) to be removed:',...
        'OKString', 'Remove',...
        'SelectionMode','multiple',...
        'ListString',liststr);
    if v
        itms = liststr(s);
        [tmp, ia] = intersect(liststr, itms);
        console.Macros(ia) = [];
    end
end
end

function saveas(console)
sapath = fileparts(mfilename('fullpath'));
[filename, pathname] = uiputfile('*.mat', 'Save as',fullfile(sapath, '\..','SimAssistBuffer.mat'));
if isequal(filename,0) || isequal(pathname,0)
    return;
else
    buffile = fullfile(pathname, filename);
    Console = console;
    save(buffile, 'Console');
end
end