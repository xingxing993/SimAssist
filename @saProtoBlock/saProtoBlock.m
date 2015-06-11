classdef saProtoBlock < saObject
    properties
        % ProtoBlock Properties
        ProtoType
        ProtoPriority = 10; % priority of this proto block when checking the same block
        ProtoCheckMethod
        ProtoProperty = {}; % key properties to be inherited when use this proto block type
        %
        RoutinePattern
        RoutineMethod
        RoutinePara
        RoutinePriority = 20;
        % 
        MajorProperty % string or cell of strings with 2 column {Prop, StringAdaptMethod}
        
        % if have other bro-blocks, like From/Goto/GotoVisibility, DataStoreRead/Write/Memory
        BroBlockType % combined with ConnectPort to determine BroType
        CreateBroBlockMethod
        GetBroMethod
        
        % PROPERTIES USED IN ADD OPERATION
        BlockSize %[Width, Height]
        % LayoutSize shall be a structure that includes geometry parameters in block layout, e.g.:
        % HorizontalMargin : distance_to_other_block,
        % PortSpacing : port_to_port
        % CharWidt : width_of_display_char
        LayoutSize = struct( 'HorizontalMargin', 40,...
            'VerticalMargin',30,...
            'PortSpacing', 30,...
            'CharWidth', 8,...
            'ToLineOffset', [50 50])
        BlockPreferOption = struct('ShowName','off','Selected','off')
        PostAddMethod
        % GENERIC PROPERTIES USED IN ADD TO PORT
        DefaultDataType = '' % Default inherit datatype string
        ConnectPort = [1 1] % [inport, outport], default index of port when connected
        
        % PropagateUpstreamStringMethod and PropagateDownstreamStringMethod may be:
        % 1: function handler that accepts port handle as input, see the
        % suffix below for predefined arguments, the other parameter can be
        % appended if necessary
        % 2: string that indicates the set property name of the block
        PropagateUpstreamStringMethod %(BlockHandle)
        PropagateDownstreamStringMethod %(BlockHandle)
        % OutportStringMethod and InportStringMethod may be:
        % 1: function handler that accepts port handle as input, see the
        % suffix below for predefined arguments, the other parameter can be
        % appended if necessary
        % 2: numeric value that specifies bypass the block through port N of the other side
        % 3: string that indicates the property name of the block
        OutportStringMethod %(PortHandle)
        InportStringMethod %(PortHandle)
        %
        
        SetPropertyMethod = -1 % use PropertyList or auto-generated dialog parameter list
        RollPropertyMethod
        AnnotationMethod
        RefineMethod
        DictRenameMethod
        StrReplaceMethod = 2 % use StrReplaceDefaults
        AutoSizeMethod = -1 % use default vertical extend behavior
        AlignMethod = -1
        ColorMethod = -1
        CleanMethod
        DataTypeMethod% = -1
        ArrangePortMethod = {[], []}
        
        
        PlusMethod
        MinusMethod
        MultiplyMethod
    end
    
    properties (Constant)
        Dictionary = SACFG_DICTIONARY;
        ShowWaitbarThreshold = 15;
        StrReplaceDefaults = {
            'Name';'Value';'GotoTag';'DataStoreName';'InputValues';'Table';'mxTable';'BreakpointsData';'OutputSignals';'OutMax';'OutMin';'RowIndex';'ColumnIndex';...
            'UserSpecifiedLogName';'AttributesFormatString';'Description';'Tag';'UpperLimit';'LowerLimit';... %'BlockDescription'
            'VariableName';...
            'nam';'bp_nam';'val';'breakpoint_data';'table_data';'msg';'msgl';'row_nam';'col_nam';'row_breakpoint_data';'col_breakpoint_data';... %%MotoHawk blocks
            'varname';...  %%SiLTest blocks
            };
    end
    
    methods
        function obj = saProtoBlock(varargin)
            obj = obj@saObject('protoblock');
            if nargin>0
                obj.ProtoType = varargin{1};
                if varargin{1}(1)~='#' %prefix with "#" symbol for proto block by convention
                    obj.MapKey = ['#', obj.ProtoType];
                else
                    obj.MapKey = obj.ProtoType;
                end
            end
        end
        %%
        function varargout = Dispatch(obj, varargin)
            [varargout{1:nargout}] = obj.Console.Dispatch(varargin{:});
        end
        %%
        function varargout = DispatchH(obj, varargin)
            [varargout{1:nargout}] = obj.Console.DispatchH(varargin{:});
        end
        
    end
end