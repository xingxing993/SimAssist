function varargout = m2s_wrapper(rtsys, typespec, flink_flg, varargin)
% motohawk to simulink convert wrapper
actrec = saRecorder;
if nargin<1 || isempty(rtsys)
    rtsys = gcs;
end
if nargin<2 || isempty(typespec)
    typespec = 'all';
end
if nargin<3 || isempty(flink_flg)
    flink_flg = false;
end
hdls = [];
typespec = strrep(typespec, 'all', 'pl, i1, i2, 1d, 2d, cal, dr');
typespec = strrep(typespec, 'table', '1d, 2d');
typespec = strrep(typespec, 'scalar', 'cal, dr');
typespec = strrep(typespec, 'pretable', 'pl, i1, i2');
funtbl = {
    %cmd        function
    'pl',       @m2s_prelookup
    'i1',       @m2s_interp1d
    'i2',       @m2s_interp2d
    '1d',       @m2s_1DTbl
    '2d',       @m2s_2DTbl
    'cal',      @m2s_KCal
    'dr',       @m2s_dataread
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
    actrec.Merge(fun(rtsys, flink_flg,varargin{:}));
end
varargout{1} = actrec;
end



%%
function actrec = m2s_KCal(rtsys,flink_flg,varargin)
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
mhcals=find_system(rtsys,'FollowLinks',flink_flg,'Regexp','on','MaskType','MotoHawk Calibration',sel{:});

for i=1:numel(mhcals)
    nam=strrep(get_param(mhcals{i},'nam'),'''','');
    val=get_param(mhcals{i},'val');
    data_type=get_param(mhcals{i},'data_type');
    sdt = m2s_data_type(data_type);
    showname=get_param(mhcals{i},'ShowName');
    newblk = actrec.ReplaceBlock(mhcals{i},'Constant');
    actrec.SetParam(newblk,...
        'ShowName','off',...
        'Value',val,...
        'OutDataTypeStr',sdt);
end
end

%%
function actrec = m2s_1DTbl(rtsys,flink_flg,varargin)
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
mhcals=find_system(rtsys,'FollowLinks',flink_flg,'LookUnderMasks','on','MaskType','MotoHawk Lookup Table (1-D)',sel{:});

for i=1:numel(mhcals)
    bpdata=strrep(get_param(mhcals{i},'breakpoint_data'),'''','');
    tbldata=get_param(mhcals{i},'table_data');
    data_type=get_param(mhcals{i},'table_data_type');
    sdt = m2s_data_type(data_type, '1D');
    newblk=actrec.ReplaceBlock(mhcals{i},'Lookup');
    actrec.SetParam(newblk,...
        'ShowName','off',...
        'InputValues',bpdata,...
        'Table',tbldata,...
        'OutDataTypeStr',sdt,...
        'LookUpMeth','Interpolation-Use End Values',...
        'AttributesFormatString','X: %<InputValues>\nY: %<Table>');
end
end

%%
function actrec = m2s_2DTbl(rtsys,flink_flg,varargin)
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
mhcals=find_system(rtsys,'FollowLinks',flink_flg,'LookUnderMasks','on','MaskType','MotoHawk Lookup Table (2-D)',sel{:});

for i=1:numel(mhcals)
    rowbpdata=strrep(get_param(mhcals{i},'row_breakpoint_data'),'''','');
    colbpdata=strrep(get_param(mhcals{i},'col_breakpoint_data'),'''','');
    tbldata=get_param(mhcals{i},'table_data');
    data_type=get_param(mhcals{i},'table_data_type');
    sdt = m2s_data_type(data_type, '2D');
    showname=get_param(mhcals{i},'ShowName');
    newblk=actrec.ReplaceBlock(mhcals{i},'Lookup2D');
    actrec.SetParam(newblk,...
        'ShowName',showname,...
        'RowIndex',rowbpdata,...
        'ColumnIndex',colbpdata,...
        'Table',tbldata,...
        'OutDataTypeStr',sdt,...
        'LookUpMeth','Interpolation-Use End Values',...
        'AttributesFormatString','X: %<RowIndex>\nY: %<ColumnIndex>\nZ: %<Table>');
end
end

function actrec = m2s_DataRead(rtsys,flink_flg,varargin)
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
mhcals=find_system(rtsys,'FollowLinks',flink_flg,'LookUnderMasks','on','MaskType','MotoHawk Data Read',sel{:});
for i=1:numel(mhcals)
    nam=strrep(get_param(mhcals{i},'nam'),'''','');
    data_type=get_param(mhcals{i},'typ');
    sdt = m2s_data_type(data_type);
    showname=get_param(mhcals{i},'ShowName');
    newblk=actrec.ReplaceBlock(mhcals{i},'Constant');
    actrec.SetParam(newblk,'ShowName',showname,'Value',nam,'OutDataTypeStr',sdt);
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