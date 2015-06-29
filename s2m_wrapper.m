function varargout = s2m_wrapper(rtsys, typespec, flink_flg, varargin)
actrec = saRecorder;
% simulink to motohawk convert wrapper
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(typespec)
    typespec = 'all';
end
if nargin<3 || isempty(flink_flg)
    flink_flg = false;
end
load_system('MotoHawk_lib');
rtsys = gcs;
typespec = strrep(typespec, 'all', 'pl, i1, i2, 1d, 2d, cal, probe');
typespec = strrep(typespec, 'table', '1d, 2d');
typespec = strrep(typespec, 'scalar', 'cal');
typespec = strrep(typespec, 'pretable', 'pl, i1, i2');
funtbl = {
    'pl',       @s2m_prelookup
    'i1',       @s2m_interp1d
    'i2',       @s2m_interp2d
    '1d',       @s2m_1DTbl
    '2d',       @s2m_2DTbl
    'cal',      @s2m_KCal
    'probe',    @s2m_probe
    };
patstr = sprintf('%s|',funtbl{:,1}); patstr = ['(',patstr(1:end-1),')'];
types = regexp(typespec, patstr, 'tokens');
types = unique([types{:}]);
[tmp, ia] = intersect(funtbl(:,1), types);
for i=1:numel(ia)
    fun = funtbl{ia(i), 2};
    if ~exist(func2str(fun)) % to handle those not implemented maybe, temporary solution
        continue;
    end
    actrec.Merge(fun(rtsys, flink_flg, varargin{:}));
end
varargout{1} = actrec;
end

%%
function actrec = s2m_1DTbl(rtsys,flink_flg,varargin)
actrec = saRecorder;
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(flink_flg)
    flink_flg = false;
end
if flink_flg
    flink_flg = 'on';
else
    flink_flg = 'off';
end
sel=varargin;
if strcmpi(get_param(bdroot(rtsys),'BlockDiagramType'),'library')
    set_param(bdroot(rtsys),'Lock','off');
end
tbls=find_system(rtsys,'FollowLinks',flink_flg,'LookUnderMasks','on','FindAll','on','BlockType','Lookup',sel{:});
for i=1:numel(tbls)
    bpname=get_param(tbls(i),'InputValues');
    tblname=get_param(tbls(i),'Table');
    old_dt = get_param(tbls(i),'OutDataTypeStr');
    mh_dt = s2m_data_type(old_dt);
    blkpth=getfullname(tbls(i));
    newblk = actrec.ReplaceBlock(tbls(i),'MotoHawk_lib/Lookup Tables/motohawk_table_1d');
    actrec.SetParam(blkpth,...
        'nam',['''',tblname,''''],...
        'table_data',tblname,...
        'bp_nam',['''',bpname,''''],...
        'breakpoint_data',bpname,...
        'table_data_type',mh_dt,...
        'AttributesFormatString','X: %<breakpoint_data>\n Y: %<table_data>');
end
end



%%
function actrec = s2m_2DTbl(rtsys,flink_flg,varargin)
actrec = saRecorder;
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(flink_flg)
    flink_flg = false;
end
if flink_flg
    flink_flg = 'on';
else
    flink_flg = 'off';
end
sel=varargin;
if strcmpi(get_param(bdroot(rtsys),'BlockDiagramType'),'library')
    set_param(bdroot(rtsys),'Lock','off');
end
tbls=find_system(rtsys,'FollowLinks',flink_flg,'FindAll','on','BlockType','Lookup2D',sel{:});
for i=1:numel(tbls)
    rbpname=get_param(tbls(i),'RowIndex');
    cbpname=get_param(tbls(i),'ColumnIndex');
    tblname=get_param(tbls(i),'Table');
    old_dt = get_param(tbls(i),'OutDataTypeStr');
    mh_dt = s2m_data_type(old_dt, true);
    blkpth=getfullname(tbls(i));
    newblk = actrec.ReplaceBlock(tbls(i),'MotoHawk_lib/Lookup Tables/motohawk_table_2d');
    actrec.SetParam(blkpth,...
        'nam',['''',tblname,''''],...
        'table_data',tblname,...
        'row_nam',['''',rbpname,''''],...
        'row_breakpoint_data',rbpname,...
        'col_nam',['''',cbpname,''''],...
        'col_breakpoint_data',cbpname,...
        'table_data_type',mh_dt,...
        'AttributesFormatString','X: %<row_breakpoint_data>\nY: %<col_breakpoint_data>\nZ: %<table_data>');
end
end

%%
function actrec = s2m_KCal(rtsys,flink_flg,varargin)
actrec = saRecorder;
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(flink_flg)
    flink_flg = false;
end
if flink_flg
    flink_flg = 'on';
else
    flink_flg = 'off';
end
sel=varargin;
if strcmpi(get_param(bdroot(rtsys),'BlockDiagramType'),'library')
    set_param(bdroot(rtsys),'Lock','off');
end

consts=find_system(rtsys,'FollowLinks',flink_flg,'Regexp','on','FindAll','on','BlockType','Constant','Value','^[^0-9.\-\[]\w*',sel{:});
for i=1:numel(consts)
    calname=get_param(consts(i),'Value');
    old_dt = get_param(consts(i), 'OutDataTypeStr');
    mh_dt = s2m_data_type(old_dt, true);
    % filter those not calibrations
    if ismember(calname, {'inf','true','false','TRUE','FALSE'})
        continue;
    elseif ~isempty(regexp(calname,'^[^a-zA-z_]'))
        continue;
%     elseif ~isempty(regexp(calname,'^C_TICK'))
%         continue;
%     elseif ~isempty(regexp(calname,'^ENUM'))
%         continue;
%     elseif ~isempty(regexp(calname,'^SY_'))
%         continue;
%     elseif ~isempty(regexp(calname,'^SYNC_TICK'))
%         continue;
    elseif ~isempty(regexp(calname,'[/*.-+()%!]')) % conatins special characters
        continue;
    else
    end
    blkpth=getfullname(consts(i));
    newblk = actrec.ReplaceBlock(consts(i),'MotoHawk_lib/Calibration & Probing Blocks/motohawk_calibration');
    actrec.SetParam(blkpth,...
        'nam',['''',calname,''''],...
        'val',calname,...
        'data_type',mh_dt);
end
end

%%
function actrec = s2m_probe(rtsys,flink_flg, varargin)
actrec = saRecorder;
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(flink_flg)
    flink_flg = false;
end
if flink_flg
    flink_flg = 'on';
else
    flink_flg = 'off';
end
if strcmpi(get_param(bdroot(rtsys),'BlockDiagramType'),'library')
    set_param(bdroot(rtsys),'Lock','off');
end
pts=find_system(rtsys,'FollowLinks',flink_flg,'FindAll','on','MustResolveToSignalObject','on');
for i=1:numel(pts)
    tgtsys=get_param(get_param(pts(i),'Parent'),'Parent');
    ln=get_param(pts(i),'Line');
    lnname=get_param(ln,'Name');
    ptpos=get_param(pts(i),'Position');
    blkpos=[ptpos(1)+120,max(ptpos(2)-40,5),ptpos(1)+270,max(ptpos(2)-20,25)];
    prbblk=actrec.AddBlock('-s-D-n','MotoHawk_lib/Calibration & Probing Blocks/motohawk_probe',[tgtsys,'/probe_',lnname],...
        'Position',blkpos,'nam',['''',lnname,'''']);
    actrec.AddLine(tgtsys,pts(i),prbblk);
    actrec.SetParam(pts(i),'MustResolveToSignalObject','off');
end
end


%%
function mh_dt = s2m_data_type(simulink_dt, table)
if nargin<2
    table = false;
end
if strcmp(simulink_dt, 'Inherit: Inherit from ''Constant value''')
    mh_dt = 'Inherit from ''Default Value''';
elseif strcmp(simulink_dt, 'Inherit: Inherit via back propagation')
    if ~table
        mh_dt = 'Inherit via back propagation';
    else
        mh_dt = 'Inherit from ''Table Data''';
    end
elseif strcmp(simulink_dt, 'Inherit: Same as input') % 1D table
    mh_dt = 'Inherit from ''Table Data''';
elseif strcmp(simulink_dt, 'Inherit: Same as first input') %2D table
    mh_dt = 'Inherit from ''Table Data''';
else
    mh_dt = simulink_dt;
end
end

%%
function s2m_single2double(rtsys,flink_flg,varargin)
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(flink_flg)
    flink_flg = false;
end
if flink_flg
    flink_flg = 'on';
else
    flink_flg = 'off';
end
if strcmpi(get_param(bdroot(rtsys),'BlockDiagramType'),'library')
    set_param(bdroot(rtsys),'Lock','off');
end
sel = varargin;
tgts=find_system(rtsys,'FollowLinks',flink_flg,'LookUnderMasks','on','FindAll','on','OutDataTypeStr','single',sel{:});
for i=1:numel(tgts)
    set_param(tgts(i),'OutDataTypeStr','double');
end
sfs=find_system(rtsys,'FollowLinks',flink_flg,'LookUnderMasks','on','FindAll','on','BlockType','SubSystem','MaskType','Stateflow',sel{:});
for i=1:numel(sfs)
    rtobj=get_param(sfs(i),'Object');
    tgts=rtobj.find('-isa','Stateflow.Data','DataType','single');
    for j=1:numel(tgts)
        tgts(j).DataType='double';
    end
end
end