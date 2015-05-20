function varargout = BuildMap(obj)
pold = pwd;

regmap = containers.Map;
p = mfilename('fullpath');
sepidx = strfind(p, filesep);
regfolder = [p(1:sepidx(end-1)), '_BlockRegistration'];
fs = what(regfolder);
regfs = [fs.m, fs.p];
regfs = regexprep(regfs, '\.(m|p)$','');
cd(regfolder);


% run proto block files first
protofls = regfs(strmatch('regprotoblock_', regfs));
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
    regobjs = eval(regfs{i});
    for k=1:numel(regobjs)
        if ~isempty(regobjs(k).MapKey)
            regobjs(k).Console = obj;
            regmap(regobjs(k).MapKey) = regobjs(k);
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
btobjs = regmap.values;
for i=1:numel(btobjs)
    if ismember(btobjs{i}.ObjectType, {'block','protoblock'})&&~isempty(btobjs{i}.RoutinePattern)
        routinemacros = [routinemacros; btobjs{i}.CreateRoutineMacro];
    end
end
obj.Macros = [obj.Macros; routinemacros];
% return to previous directory
cd(pold);
end