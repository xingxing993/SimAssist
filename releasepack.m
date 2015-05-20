function releasepack
if ~isdir('releases')
    mkdir('releases');
end
rtdir = pwd;
packdir = ['.\releases\SimAssist_V', datestr(now, 'yyyymmddHHMM')];
mkdir(packdir);

df = dir;
df = df(3:end);
copy_exlist = {'releases', 'demos','releasepack'};
for i=1:numel(df)
    if isempty(cell2mat(regexp(df(i).name, copy_exlist)))
        copyfile(df(i).name, fullfile(packdir, df(i).name));
    end
end
cd(packdir);
pcode_exlist = {'^SACFG_', 'whichtorun'};
pfolder(pwd, pcode_exlist);
cd(rtdir);

function pfolder(fd, pcode_exlist)
dfs = dir(fd);
ds = dfs([dfs.isdir]);
mfs = what(fd);
mfs = mfs.m;
for i=1:numel(mfs)
    if isempty(cell2mat(regexp(mfs{i}, pcode_exlist)))
        fmf = fullfile(fd, mfs{i});
        pcode(fmf, '-inplace');
        delete(fmf);
    end
end
for i=1:numel(ds)
    if ds(i).name~='.'
        pfolder(fullfile(fd, ds(i).name), pcode_exlist);
    end
end