function CreateMFile(obj)
msktyp = get_param(obj.GetSourcePath, 'MaskType');
if ~isempty(msktyp)
    nmprps = genvarname(strrep(msktyp,' ','_'));
else
    nmprps = genvarname(strrep(get_param(obj.GetSourcePath, 'Name'),' ','_'));
end

[fnstr, pathname] = uiputfile(['regblock_', nmprps, '.m'], 'Save to file');
if isequal(fnstr, 0)
    return;
end
[~, nmfunc] = fileparts(fnstr);
fid = fopen(fullfile(pathname, fnstr),'wt');

fprintf(fid, 'function sabt = %s\n', nmfunc);
fprintf(fid, '%%This function is automatically generated to represent the saBlock object that describes the behaviour of the block type\n');
fprintf(fid, 'sabt = saBlock(''%s'');\n', obj.GetSourcePath);
fprintf(fid, 'sabt.RoutinePattern = ''%s'';\n', obj.RoutinePattern);
if ~isempty(obj.RoutinePriority)
    fprintf(fid, 'sabt.RoutinePriority = %d;\n', obj.RoutinePriority);
else
    fprintf(fid, '%%sabt.RoutinePriority = [];\n');
end
if ischar(obj.RoutineMethod)
    fprintf(fid, 'sabt.RoutineMethod = ''%s'';\n', obj.RoutineMethod);
else
    fprintf(fid, '%%sabt.RoutineMethod = @SUBFUNCTION;\n');
end
% routine parameter struct
paraflds = fieldnames(obj.RoutinePara);
for i=1:numel(paraflds)
    fprintf(fid, 'sabt.RoutinePara.%s = ''%s'';\n', paraflds{i}, obj.RoutinePara.(paraflds{i}));
end
fprintf(fid, 'sabt.BlockPreferOption.ShowName = ''%s'';\n', obj.BlockPreferOption.ShowName);
fprintf(fid, 'sabt.BlockPreferOption.Selected = ''%s'';\n', obj.BlockPreferOption.Selected);
%% place holder properties
fprintf(fid, '\n\n%% CUSTOMIZE FUNCTIONS, SEE PROGRAMING REFERENCE DOCUMENT FOR DETAIL\n');
props = {...
    'PropagateUpstreamStringMethod', 'PropagateDownstreamStringMethod',...
    'OutportStringMethod', 'InportStringMethod',...
    'SetPropertyMethod',...
    'RollPropertyMethod',...
    'AnnotationMethod',...
    'RefineMethod',...
    'DictRenameMethod',...
    'StrReplaceMethod',...
    'AutoSizeMethod',...
    'AlignMethod',...
    'ColorMethod',...
    'CleanMethod',...
    'DataTypeMethod',...
    'ArrangePortMethod',...
    'PlusMethod',...
    'MinusMethod'};
for i=1:numel(props)
    fprintf(fid, '%%sabt.%s = @SUBFUNCTION/INTEGER/STRING/CELL...;\n',props{i});
end
fprintf(fid,'end\n');

% 
fprintf(fid, '\n\n\n');
fprintf(fid,'%%function actrec = SUBFUNCTION1(blkhdl, varargin)\n');
fprintf(fid,'%% %% blkhdl: Handle of block to be dealt with\n');
fprintf(fid,'%% %% actrec: saRecorder object that records the actions for undo and redo, optional\n');
fprintf(fid,'%%end\n\n');
fprintf(fid,'%%function actrec = SUBFUNCTION2(blkhdl, varargin)\n');
fprintf(fid,'%% %% blkhdl: Handle of block to be dealt with\n');
fprintf(fid,'%% %% actrec: saRecorder object that records the actions for undo and redo, optional\n');
fprintf(fid,'%%end\n\n');

fclose(fid);
end