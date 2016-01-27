function seq = ParseSeqExpr(obj, strin)
% check bracket sequence expression []
% Allows sequence expression in bracket includes ("#" indicates number(s)):
% "#:#", #:#:#, A:#:Z, a:#:z, "STR1, STR2, STR3", "STR1 STR2 STR3" and mix
% of the above
% Examples:
% "PRE[1:10]TAIL", "PRE[1:2:10,AA,BB,CC]TAIL"
% "PRE[a:e]TAIL, "PRE[a:3:z]TAIL", "PRE[AA,BB,CC,A:3:Z]TAIL"
if nargin<2
    strin = obj.OptionStr;
end
[seqstrs,pre_trail] = regexp(strin, '\[([\w\s,:]+)\]','tokens','split');
if isempty(seqstrs)
    seq = {strin}; return;
end
seqparts = cell(size(seqstrs));
for k=1:numel(seqstrs)
    seqstr = seqstrs{k}{1};
    seqel = regexp(seqstr, '\s|,','split');
    seq_part = {};
    for i=1:numel(seqel)
        if isempty(seqel)
            continue;
        end
        % convert number pattern into string if necessary, like 1:5, 1:2:9
        tmpseqpat1 = regexp(seqel{i}, '\d+:(\d+:)?\d+', 'match','once');
        if ~isempty(tmpseqpat1)
            seqnum = eval(tmpseqpat1);
            seq_part = [seq_part, arrayfun(@int2str, seqnum, 'UniformOutput',false)];
        else
            % convert number pattern into string if necessary, like A:E, a:2:k
            tmpseqpat2 = regexp(seqel{i}, '[A-Za-z]:(\d+:)?[A-Za-z]', 'match','once');
            if ~isempty(tmpseqpat2)
                tmpseqpat2 = eval(regexprep(tmpseqpat2, '([A-Za-z]):(\d+:)?([A-Za-z])', '''$1'':$2''$3'''));
                seq_part = [seq_part, arrayfun(@(x)x, tmpseqpat2, 'UniformOutput',false)];
            else
                seq_part = [seq_part, seqel{i}];
            end
        end
        seqparts{k} = seq_part;
    end
end
% extend align with the longest sequence
cnt_max = max(cellfun(@numel, seqparts));
for i=1:numel(seqparts)
    tmp = repmat(seqparts{i}, 1, ceil(cnt_max/numel(seqparts{i})));
    seqparts{i} = tmp(1:cnt_max);
end
%
[tmpvarlist{1:2:2*numel(pre_trail)-1}] = deal(pre_trail{:});
[tmpvarlist{2:2:2*numel(pre_trail)-1}] = deal(seqparts{:});
seq = strcat(tmpvarlist{:});
end