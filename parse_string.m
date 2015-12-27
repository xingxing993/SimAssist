function [bestsplit,opt]=parse_string(ts,dict)
if isempty(ts)
    bestsplit = struct('String', '', 'StrangeCharCount', 0, 'StrangerList', {{}});
    opt = bestsplit;
    return;
end

charcnt=numel(ts);
maxlen=max(cellfun(@numel,dict));
minlen=min(cellfun(@numel,dict));


for i=1:numel(ts)
    bitinfo(i).Index=i;
    tmp=[];mch=[];
    for j=minlen:maxlen
        match=dict(strcmp(ts(i:min(charcnt,i+j-1)),dict));
        if ~isempty(match)
            tmp.MatchStr=match{1};
            tmp.MatchLength=numel(match{1});
            tmp.MatchEnd=i+j-1;
            mch=[mch;tmp];
        end
        if i+j-1>=charcnt
            break;
        end
    end
    bitinfo(i).Match=mch;
    bitinfo(i).Valid=~isempty(bitinfo(i).Match);
end
anchor=bitinfo([bitinfo.Valid]);
for i=1:numel(anchor)
    anchgrp=[anchor.Index];
    for j=1:numel(anchor(i).Match)
        enemy=anchgrp(anchgrp<=min([anchor(i).Match(j).MatchEnd])&anchgrp>anchor(i).Index);
        anchor(i).Match(j).Enemy=enemy;
    end
end
listidx=get_anchor_list(anchor);
if isempty(listidx)
    opt.String={ts};
    opt.StrangeCharCount=numel(ts);
    opt.StrangerList={ts};
    bestsplit=opt;
    return;
end
for i=1:numel(listidx)
    brkpt=listidx{i};
    tmpstr={};
    tmpcnt=0;
    tmpstrnger={};
    if brkpt(1).Index~=1
        stranger=ts(1:brkpt(1).Index-1);
        tmpstr=[stranger,tmpstr];
        tmpstrnger=[tmpstrnger,stranger];
        tmpcnt=tmpcnt+numel(stranger);
    end
    for j=1:numel(brkpt)-1
        tmpstr=[tmpstr,ts(brkpt(j).Index:brkpt(j).MatchEnd)];
        if brkpt(j).MatchEnd+1<brkpt(j+1).Index
            stranger=ts(brkpt(j).MatchEnd+1:brkpt(j+1).Index-1);
            tmpstr=[tmpstr,stranger];
            tmpstrnger=[tmpstrnger,stranger];
            tmpcnt=tmpcnt+numel(stranger);
        end
    end
    tmpstr=[tmpstr,ts(brkpt(end).Index:brkpt(end).MatchEnd)];
    if brkpt(end).MatchEnd+1<=charcnt
        stranger=ts(brkpt(end).MatchEnd+1:end);
        tmpstr=[tmpstr,stranger];
        tmpstrnger=[tmpstrnger,stranger];
        tmpcnt=tmpcnt+numel(stranger);
    end
    strangercnt(i)=tmpcnt;
    opt(i).String=tmpstr;
    opt(i).StrangeCharCount=tmpcnt;
    opt(i).StrangerList=tmpstrnger;
end
[~,idx]=min([opt.StrangeCharCount]);
bestsplit=opt(idx);


function listidx=get_anchor_list(anchor)
if isempty(anchor)
    listidx={};
    return;
end
for j=1:numel(anchor(1).Match)
    if isempty(anchor(1).Match(j).Enemy)
        tmp.Index=anchor(1).Index;
        tmp.MatchEnd=anchor(1).Match(j).MatchEnd;
        listidx=cellcat(tmp,get_anchor_list(anchor(2:end)));
    else
        newanchor=anchor([anchor.Index]>max(anchor(1).Match(j).Enemy));
        tmp.Index=anchor(1).Index;
        tmp.MatchEnd=anchor(1).Match(j).MatchEnd;
        listidx=cellcat(tmp,get_anchor_list(newanchor));
        for i=1:numel(anchor(1).Match(j).Enemy)
            newanchor=anchor([anchor.Index]>=anchor(1).Match(j).Enemy(i));
            listidx=[listidx;get_anchor_list(newanchor)];
        end
    end
end


function clout=cellcat(arr,clin)
clout=clin;
if isempty(clin)
    clout={arr};
    return;
else
    for i=1:numel(clin)
        clout{i}=[arr,clin{i}];
    end
end

