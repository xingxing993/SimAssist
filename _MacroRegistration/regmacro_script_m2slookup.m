function sam = regmacro_script_m2slookup
%REGMACRO_???
% Registration of ??? macro in SimAssist

sam = saMacro('script_m2slookup');
sam.Pattern = '^m2s';
sam.Callback = @script_m2slookup;
sam.Priority = 40;
end

function [actrec, success] =script_m2slookup(cmdstr, console)
actrec=saRecorder;success = false;
opt = strtrim(regexprep(cmdstr, '^m2s\s*', ''));
switch opt
    case 'p1'
        actrec + m2s_p1(console);
        success = true;
    case 'p2'
        actrec + m2s_p2(console);
        success = true;
    otherwise
        success = false;
end
end

function actrec = m2s_p1(console)
actrec = saRecorder;
objs1=saFindSystem(gcs, 'block', [], 'MaskType', 'MotoHawk Interpolation (1-D)');
objs2=saFindSystem(gcs, 'block', [], 'MaskType', 'MotoHawk Interpolation Reference (1-D)');
objhdls = [objs1; objs2];
l1bt = console.MapTo('Lookup');
for i=1:numel(objhdls)
    itpblk = objhdls(i);
    if strcmp(get_param(itpblk, 'MaskType'), 'MotoHawk Interpolation Reference (1-D)')
        dtstr = 'dt';
    else
        dtstr = 'data_type';
    end
    lns = get_param(itpblk, 'LineHandles');
    preblk = get_param(lns.Inport(1), 'SrcBlockHandle');
    tblnm = regexprep(strrep(get_param(itpblk,'nam'), '''', ''), 'Tbl$', '');
    tbldt = get_param(itpblk,dtstr);
    bpnm = regexprep(strrep(get_param(preblk,'nam'), '''', ''), 'IdxArr$', '');
    bpdt = get_param(preblk,dtstr);
    pos2 = get_param(itpblk, 'Position');
    pos1 = get_param(preblk, 'Position');
    l1pos = [pos1(1:2), pos2(3:4)];
    
    delete_block(itpblk);
    delete_block(preblk);
    delete_line(lns.Inport);
    actrec + l1bt.AddBlock(l1pos, 'Table', tblnm, 'InputValues', bpnm, 'OutDataTypeStr', m2s_data_type(tbldt, '1D'));
end
end

function actrec = m2s_p2(console)
actrec = saRecorder;
objs1=saFindSystem(gcs, 'block', [], 'MaskType', 'MotoHawk Interpolation (2-D)');
objs2=saFindSystem(gcs, 'block', [], 'MaskType', 'MotoHawk Interpolation Reference (2-D)');
objhdls = [objs1; objs2];
l2bt = console.MapTo('Lookup2D');
for i=1:numel(objhdls)
    itpblk = objhdls(i);
    if strcmp(get_param(itpblk, 'MaskType'), 'MotoHawk Interpolation Reference (2-D)')
        dtstr = 'dt';
    else
        dtstr = 'data_type';
    end
    lns = get_param(itpblk, 'LineHandles');
    preblk1 = get_param(lns.Inport(1), 'SrcBlockHandle');
    preblk2 = get_param(lns.Inport(2), 'SrcBlockHandle');
    tblnm = regexprep(strrep(get_param(itpblk,'nam'), '''', ''), 'Map$', '');
    tbldt = get_param(itpblk,dtstr);
    xnm = regexprep(strrep(get_param(preblk1,'nam'), '''', ''), 'IdxArr$', '');
    xdt = get_param(preblk1,dtstr);
    ynm = regexprep(strrep(get_param(preblk2,'nam'), '''', ''), 'IdxArr$', '');
    ydt = get_param(preblk2,dtstr);
    pos3 = get_param(itpblk, 'Position');
    pos1 = get_param(preblk1, 'Position');
    l2pos = [pos1(1:2), pos3(3:4)];
    
    delete_block(itpblk);
    delete_block(preblk1);
    delete_block(preblk2);
    delete_line(lns.Inport);
    actrec + l2bt.AddBlock(l2pos, 'Table', tblnm, 'RowIndex', xnm, 'ColumnIndex',ynm, 'OutDataTypeStr', m2s_data_type(tbldt, '2D'));
end
end


%%
function sdt = m2s_data_type(mh_dt, type)
if nargin<2
    type = '';
end
if strcmp(mh_dt, 'Inherit from ''Default Value''')
    sdt = 'Inherit: Inherit from ''Constant value''';
elseif strcmp(mh_dt, 'Inherit via back propagation')
    sdt = 'Inherit: Inherit via back propagation';
elseif strcmp(mh_dt, 'Inherit from ''Table Data''')
    if strcmpi(type,'1D')
        sdt =  'Inherit: Same as input'; % 1D table
    elseif strcmpi(type,'2D')
        sdt = 'Inherit: Same as first input';
    else
        sdt = mh_dt;
    end
else
    sdt = mh_dt;
end
end