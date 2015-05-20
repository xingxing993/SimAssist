classdef saBlockGroup
    properties
        Name
        BlockHandles
    end
    
    properties (Dependent = true)
        BlockCount
        Boundary
    end
    
    methods
        function obj=saBlockGroup(varargin)
            if nargin==1
                if isnumeric(varargin{1})
                    obj.BlockHandles=varargin{1};
                    obj.Name='';
                elseif isstr(varargin{1})
                    strin=varargin{1};
                    if strcmpi(strin,'Selected')
                        blks=find_system(gcs,'FindAll','on','SearchDepth',1,'Type','block','Selected','on');
                        obj.BlockHandles=setdiff(blks,get_param(gcs,'Handle'));
                        obj.Name='';
                    end
                end
            elseif nargin==2
                obj.BlockHandles=varargin{2};
                obj.Name=varargin{1};
            else
                obj.BlockHandles=[];
                obj.Name='';
            end
        end
        %%
        function BlockCount=get.BlockCount(obj)
            BlockCount=numel(obj.BlockHandles);
        end
        %%
        function bd=get.Boundary(obj)
            if obj.BlockCount<1
                bd=[];
                return;
            end
            blks=obj.BlockHandles;
            bd=get_param(blks(1),'Position');
            for i=2:obj.BlockCount
                pos=get_param(blks(i),'Position');
                mintmp=min(bd,pos);
                maxtmp=max(bd,pos);
                bd=[mintmp(1:2),maxtmp(3:4)];
            end
        end
    end
end