function sam = regmacro_adder_datastore
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('adder_datastore');
sam.Pattern = '^ds(w|r|m)';
sam.PromptMethod = {'dsm','dsr','dsw'};
sam.Callback = @adder_datastore;

end

function [actrec, success] =adder_datastore(cmdstr, console)
actrec=saRecorder;success = false;
%parse input command
regtmp = regexp(cmdstr, '^ds(w|r|m)\s*', 'tokens','once');
dstype=regtmp{1};
optstr = strtrim(regexprep(cmdstr, '^ds(w|r|m)\s*',''));
%
dsrsel=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','FindAll','on','BlockType','DataStoreRead','Selected','on');
dswsel=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','FindAll','on','BlockType','DataStoreWrite','Selected','on');
dsmsel=find_system(gcs,'SearchDepth',1,'LookUnderMasks','on','FollowLinks','on','FindAll','on','BlockType','DataStoreMemory','Selected','on');
dsblksel=[dsrsel; dswsel; dsmsel];
switch dstype
    case 'w'
        btobj = console.MapTo('DataStoreWrite');
    case 'r'
        btobj = console.MapTo('DataStoreRead');
    case 'm'
        btobj = console.MapTo('DataStoreMemory');
end
if isempty(dsblksel)
    actrec + Routines.majorprop_str_num(btobj, optstr, '');
else
    for i=1:numel(dsblksel)
        dsbtobj = console.MapTo(dsblksel(i));
        actrec + dsbtobj.CreateBroBlock(dsblksel(i), btobj.ConnectPort);
    end
end
success = true;
end