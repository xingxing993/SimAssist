function block = AddBlock(obj,varargin)
% varargin: {option, src, dst, prop1, val1, ...}
% parse argument
N = struct('flg',false,'extra',''); %-n/N: Hide/Show Name
S = struct('flg',true,'extra','');  %-s/S: Selected Off/On
D = struct('flg',false,'extra',''); %-d/D: Prefix with gcs/Use full path as destination
optstr = varargin{1};
opts = regexp(optstr,'\-([a-zA-Z])(\w*)','tokens');
for i=1:numel(opts)
    tmp=struct('flg',logical(opts{i}{1}-lower(opts{i}{1})),'extra',opts{i}{2});
    eval([upper(opts{i}{1}),'=tmp;']); % override
end
src = varargin{2};
if D.flg
    dst = varargin{3};
else
    dst = [gcs, '/', varargin{3}];
end
if isempty(strfind(src, '/'))
    src = ['built-in/', src];
end
prop=varargin(4:end);
if S.flg
    prop=[prop,{'Selected','on'}];
else
    prop=[prop,{'Selected','off'}];
end
if N.flg
    prop=[prop,{'ShowName','on'}];
else
    prop=[prop,{'ShowName','off'}];
end
sa = saAction('add_block', src, dst, prop{:});
obj.PushItem(sa);
block = sa.Handle;
end