function varargout = BuildMap(obj)
pold = pwd;

% regmap = containers.Map;
regmap = {};
p = mfilename('fullpath');
sepidx = strfind(p, filesep);
regfolder = [p(1:sepidx(end-1)), '_BlockRegistration'];
fs = what(regfolder);
regfs = [fs.m, fs.p];
regfs_mat = fs.mat;
regfs = regexprep(regfs, '\.(m|p)$','');
cd(regfolder);


% run proto block files first
protofls = regfs(strncmp('regprotoblock_', regfs, numel('regprotoblock_')));
protos = [];
for i=1:numel(protofls)
    regobjs = eval(protofls{i});
    protos = [protos; regobjs];
end
[protos.Console] = deal(obj);
[tmp, iprio] = sort([protos.ProtoPriority]);
obj.ProtoBlocks = protos(iprio);

% run block type files
regfs = setdiff(regfs, protofls);
for i=1:numel(regfs)
try
    regobjs = eval(regfs{i});
catch
	continue;
end
    for k=1:numel(regobjs)
        if ~isempty(regobjs(k).MapKey)
            regobjs(k).Console = obj;
            if isempty(regmap) || ~any(strcmp(regobjs(k).MapKey, regmap(:,1)))
                regmap = [regmap; {regobjs(k).MapKey, regobjs(k)}];
            else
                warning('SimAssist:ImportIgnore', 'Map key <%s> already exists in the list', regobjs(k).MapKey);
            end
        end
    end
end
% append block types stored in .mat file, 'Newer' variable
for i=1:numel(regfs_mat)
    matbts = whos('-file',regfs_mat{i},'newer');
    if ~isempty(matbts)
        load(regfs_mat{i}, 'newer');
        regobjs = newer;
        for k=1:numel(regobjs)
            if ~isempty(regobjs(k).MapKey)
                if ~any(strcmp(regobjs(k).MapKey, regmap(:,1)))
                    regmap = [regmap; {regobjs(k).MapKey, regobjs(k)}];
                else
                    warning('SimAssist:ImportIgnore', 'Map key <%s> already exists in the list', regobjs(k).MapKey);
                end
            end
        end
    end
end

obj.BlockMap = regmap;
% create routine macros
routinemacros = [];
for i=1:numel(obj.ProtoBlocks)
    if ~isempty(obj.ProtoBlocks(i).RoutinePattern)
        routinemacros = [routinemacros; obj.ProtoBlocks(i).CreateRoutineMacro];
    end
end
btobjs = regmap(:,2);
for i=1:numel(btobjs)
    if ismember(btobjs{i}.ObjectType, {'block','protoblock'})&&~isempty(btobjs{i}.RoutinePattern)
        routinemacros = [routinemacros; btobjs{i}.CreateRoutineMacro];
    end
end
obj.Macros = [obj.Macros; routinemacros];
% return to previous directory
cd(pold);
end
