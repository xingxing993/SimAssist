function ports=getBGPorts(obj)
blks=obj.BlockHandles;
Inports=[];
Outports=[];
for i=1:numel(blks)
    lns=get_param(blks(i),'LineHandles');
    pts=get_param(blks(i),'PortHandles');
    for j=1:numel(lns.Inport)
        if lns.Inport(j)>0
            if ~ismember(get_param(lns.Inport(j),'SrcBlockHandle'),blks)
                Inports=[Inports;pts.Inport(j)];
            end
        end
    end
    for j=1:numel(lns.Outport)
        if lns.Outport(j)>0
            if ~ismember(get_param(lns.Outport(j),'DstBlockHandle'),blks)
                Outports=[Outports;pts.Outport(j)];
            end
        end
    end
end
ports.Inports=Inports;
ports.Outports=Outports;
end