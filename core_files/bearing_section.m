function varargout = bearing_section(varargin)
%BEARING_SECTION MATLAB code file for bearing_section.fig
%      BEARING_SECTION, by itself, creates a new BEARING_SECTION or raises the existing
%      singleton*.
%
%      H = BEARING_SECTION returns the handle to a new BEARING_SECTION or the handle to
%      the existing singleton*.
%
%      BEARING_SECTION('Property','Value',...) creates a new BEARING_SECTION using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to bearing_section_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      BEARING_SECTION('CALLBACK') and BEARING_SECTION('CALLBACK',hObject,...) call the
%      local function named CALLBACK in BEARING_SECTION.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bearing_section

% Last Modified by GUIDE v2.5 03-Aug-2018 13:05:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @bearing_section_OpeningFcn, ...
    'gui_OutputFcn',  @bearing_section_OutputFcn, ...
    'gui_LayoutFcn',  [], ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before bearing_section is made visible.
function bearing_section_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for bearing_section
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Main uitable parameters
handles.my_table.ColumnName = {'Bearing no.','Shaft','<HTML>n<sub>RE</sub></HTML>','<HTML>d (mm)</HTML>','<HTML>D (mm)</HTML>','<HTML>&beta (deg)</HTML>','Distributed fault','Localized fault'};
% handles.my_table.ColumnName = {'Bearing no.','Shaft','Ball no.','Bearing roller d. (mm)','Pitch circle d. (mm)','Contact angle (deg)','Distributed fault','Localized fault'};
handles.my_table.ColumnWidth{1} = 90; handles.my_table.ColumnEditable(1) = 0;
handles.my_table.ColumnWidth{2} = 70; handles.my_table.ColumnEditable(2) = 1;
handles.my_table.ColumnWidth{3} = 70; handles.my_table.ColumnEditable(3) = 1;
handles.my_table.ColumnWidth{4} = 120; handles.my_table.ColumnEditable(4) = 1;
handles.my_table.ColumnWidth{5} = 120; handles.my_table.ColumnEditable(5) = 1;
handles.my_table.ColumnWidth{6} = 120; handles.my_table.ColumnEditable(6) = 1;
handles.my_table.ColumnWidth{7} = 100; handles.my_table.ColumnEditable(7) = 1; handles.my_table.ColumnFormat{8} =  'logical';
handles.my_table.ColumnWidth{8} = 100; handles.my_table.ColumnEditable(8) = 1; handles.my_table.ColumnFormat{9} =  'logical';

try
    main_table_bearing_data = evalin('base','main_table_bearing_data');
    main_table_bearing_mask = main_table_bearing_data;
    main_table_bearing_mask = data2mask_bearing(main_table_bearing_mask);
    handles.my_table.Data = main_table_bearing_mask;
    handles.my_table.ColumnWidth{1} = 90; handles.my_table.ColumnEditable(1) = 0;
    % initialize counter for new raws with automatic numbering
    count_new_raw = size(main_table_bearing_data,1);
    assignin('base','count_new_raw',count_new_raw);
catch
    % data initialization
    data = [];
    assignin('base','data',data);
    % default data
    main_table_bearing_mask = {1,1,9,8,38,9,false,false};
    assignin('base','main_table_bearing_mask',main_table_bearing_mask)
    handles.my_table.Data = main_table_bearing_mask;
    main_table_bearing_data = main_table_bearing_mask;
    main_table_bearing_data{1,7} = {'<HTML>periodic contribution (outer race period)</HTML>',0,0,0;
        '<HTML>periodic contribution (shaft rotation period)</HTML>',0,0,0;
        '<HTML>amplitude modulation [0,1]</HTML>',0,0,0;
        '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
        '<HTML>&zeta; (%)</HTML>',0,0,0};
    main_table_bearing_data{1,8} = {'<HTML>jitter (%&Delta&Theta<sub>imp</sub>)</HTML>',0,0,0;
        '<HTML>&mu of impact amplitude &delta </HTML>',0,0,0;
        '<HTML>&sigma of impact amplitude &delta </HTML>',0,0,0;
        '<HTML>periodic modulation [0,1] </HTML>',0,0,0;
        '<HTML>double impact amplitude (RE fault only) [0,1] </HTML>',0,0,0;
        '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
        '<HTML>&zeta; (%)</HTML>',0,0,0};
    assignin('base','main_table_bearing_data',main_table_bearing_data)
    % initialize counter for new raws with automatic numbering
    count_new_raw = 1; assignin('base','count_new_raw',count_new_raw);
end

set(handles.param_loc_table2,'visible','off')
set (handles.param_loc_table2,'ColumnWidth', {250,100,100,100})
handles.param_loc_table2.ColumnEditable(1) = 0;
handles.param_loc_table2.ColumnEditable(2) = 0;
handles.param_loc_table2.ColumnEditable(3) = 0;
handles.param_loc_table2.ColumnEditable(4) = 0;
%   distributed faults (PM)
set(handles.param_PM_table,'visible','off')
set (handles.param_PM_table,'ColumnWidth', {250,100,100,100})
handles.param_PM_table.ColumnEditable(1) = 0;
handles.param_PM_table.ColumnEditable(2) = 0;
handles.param_PM_table.ColumnEditable(3) = 0;
handles.param_PM_table.ColumnEditable(4) = 0;
% setting button visibility
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.proceed_button,'enable','off');
if count_new_raw == 1
    set(handles.delete_last_button,'enable','off');
else
    set(handles.delete_last_button,'enable','on');
end
set(handles.accept_button,'visible','off');
set(handles.del_param_button,'visible','off');
set(handles.outer_race_bool,'visible','off');
set(handles.inner_race_bool,'visible','off');
set(handles.roll_elem_bool,'visible','off');
set(handles.default_button,'visible','on');

% intialize dynamic titles
textLabel = sprintf('General settings for the bearing fault signatures');
set(handles.dynamic_title, 'String', textLabel);

% close without ask flag
cwa_ord_flag = 0;
assignin('base','cwa_ord_flag',cwa_ord_flag)

% static variable for mesh harmonic number
Nmh_static = 1;
assignin('base','Nmh_static',Nmh_static);

% static variable for recalling tables
table_names = {{},{},{},{},{},{},'param_PM_table','param_loc_table2'};
assignin('base','table_names',table_names);

% data matrix initialization
temp_data = [];
assignin('base','temp_data',temp_data);

% UIWAIT makes bearing_section wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = bearing_section_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% CODE FOR NEW RAW BUTTON
function new_raw_button_Callback(~, ~, handles)
% hObject    handle to new_raw_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tableData = evalin('base','main_table_bearing_data');
count_new_raw = size(tableData,1); % evalin('base', 'count_new_raw');
count_new_raw = count_new_raw + 1; assignin('base','count_new_raw',count_new_raw);


newRaw = [{count_new_raw}, {1}, {9}, {8}, {38}, {9}, {{'<HTML>periodic contribution (outer race period)</HTML>',0,0,0;
    '<HTML>periodic contribution (shaft rotation period)</HTML>',0,0,0;
    '<HTML>modulation amplitude [0,1] </HTML>',0,0,0;
    '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
    '<HTML>&zeta; (%)</HTML>',0,0,0}},{ {'<HTML>jitter (%&Delta&Theta<sub>imp</sub>)</HTML>',0,0,0;
    '<HTML>&mu of impact amplitude &delta </HTML>',0,0,0;
    '<HTML>&sigma of impact amplitude &delta </HTML>',0,0,0;
    '<HTML>periodic modulation </HTML>',0,0,0;
    '<HTML>double impact amplitude (RE fault only) </HTML>',0,0,0;
    '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
    '<HTML>&zeta; (%)</HTML>',0,0,0}}];
newData = [tableData;newRaw];

% newData = [tableData;{count_new_raw},{1},{9},{8},{38},{9},{'<HTML>periodic contribution (outer race period)</HTML>',0,0,0;
%     '<HTML>periodic contribution (shaft rotation period)</HTML>',0,0,0;
%     '<HTML>modulation amplitude </HTML>',0,0,0;
%     '<HTML>modulation form factor</HTML>',0,0,0},{'<HTML>jitter (%&Delta&Theta<sub>imp</sub>)</HTML>',0,0,0;
%     '<HTML>&mu of impact amplitude &delta </HTML>',0,0,0;
%     '<HTML>&sigma of impact amplitude &delta </HTML>',0,0,0;
%     '<HTML>periodic modulation </HTML>',0,0,0;
%     '<HTML>double impact amplitude (RE fault only) </HTML>',0,0,0;
%     '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
%     '<HTML>&zeta; (%)</HTML>',0,0,0}]
main_table_bearing_data = newData; assignin('base','main_table_bearing_data',main_table_bearing_data)
main_table_bearing_mask = data2mask_bearing(main_table_bearing_data); assignin('base','main_table_bearing_mask',main_table_bearing_mask)
handles.my_table.Data = main_table_bearing_mask;
set(handles.proceed_button,'enable','off');
textLabel = sprintf('');
set(handles.delete_last_button,'enable','on');

% CODE FOR DATA CHECK BUTTON
function data_check_button_Callback(~, ~, handles)
% hObject    handle to data_check_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main_table_bearing_mask = evalin('base', 'main_table_bearing_mask'); % update table
main_table_bearing_data = evalin('base', 'main_table_bearing_data'); % update table
y = checkFun_bearing(main_table_bearing_mask);

% check the shafts!
shafts = main_table_bearing_mask(:,2);
shafts = cell2mat(shafts);
try
    main_table_ord_mask = evalin('base', 'main_table_ord_mask'); % update table
    maxShaft = main_table_ord_mask(:,2);
    maxShaft = max(cell2mat(maxShaft));
    
catch
    maxShaft = 1;
end

wrongShaftsInd = shafts > maxShaft;
wrongShaftsInd = find(wrongShaftsInd);
if ~isempty(wrongShaftsInd)
    y = 1;
end

if y == 0
    set(handles.proceed_button,'enable','on');
    set(handles.data_check_button,'enable','off');
elseif y == 1
    set(handles.proceed_button,'enable','off');
    
    if ~isempty(wrongShaftsInd)
        main_table_bearing_mask(wrongShaftsInd,2) = {1};
        main_table_bearing_data(wrongShaftsInd,2) = {1};
        assignin('base','main_table_bearing_mask',main_table_bearing_mask)
        assignin('base','main_table_bearing_data',main_table_bearing_data)
        handles.my_table.Data = main_table_bearing_mask;
        warndlg(['The maximum shaft number is ' num2str(maxShaft) '. The wrong shaft numbers have been set as default.'],'Warning')
    end
    
end

% CODE FOR PROCEED BUTTON
function proceed_button_Callback(~, ~, handles)
% hObject    handle to proceed_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cwa_ord_flag = 1;
assignin('base','cwa_ord_flag',cwa_ord_flag);
tableData = get(handles.my_table, 'data');
assignin('base','tableData',tableData);
% main_menu
run('main_menu')
close('bearing_section')

% CODE FOR DELETE LAST RAW BUTTON
function delete_last_button_Callback(~, ~, handles)
% hObject    handle to delete_last_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close_flag = questdlg('Deleting the last raw you will delete all related parameters. Do you want to proceed?','Warning','Yes','No','No');
% Handle response
switch close_flag
    case 'Yes'
        close_flag = 1;
    case 'No'
        close_flag = 0;
end

if close_flag == 1
    main_table_bearing_data = evalin('base','main_table_bearing_data');
    main_table_bearing_mask = evalin('base','main_table_bearing_mask');
    count_new_raw = size(main_table_bearing_data,1);% evalin('base', 'count_new_raw');
    main_table_bearing_data(count_new_raw,:) = []; assignin('base','main_table_bearing_data',main_table_bearing_data);
    main_table_bearing_mask(count_new_raw,:) = []; assignin('base','main_table_bearing_mask',main_table_bearing_mask);
    handles.my_table.Data = main_table_bearing_mask;
    count_new_raw = count_new_raw - 1; assignin('base','count_new_raw',count_new_raw);
    if count_new_raw < 2
        set(handles.delete_last_button,'enable','off');
    end
end

% CODE FOR DEFINING FAULT PARAMETERS (temp_data)
function my_table_CellEditCallback(~, eventdata, handles)
% hObject    handle to my_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'clear r c');
if ~isempty(eventdata.Indices)
    r = eventdata.Indices(1);
    c = eventdata.Indices(2);
    main_table_bearing_data = evalin('base','main_table_bearing_data');
    main_table_bearing_mask = evalin('base','main_table_bearing_mask');
    Nmh = size(main_table_bearing_data{r,5},1);
    % set def value or given parameters if available
    
    if c > 6
        % hide main table
        set(handles.my_table,'visible','off')
        set(handles.proceed_button,'visible','off')
        set(handles.delete_last_button,'visible','off')
        set(handles.new_raw_button,'visible','off')
        set(handles.data_check_button,'visible','off','enable','on')
        % display parameter table
        set(handles.accept_button,'visible','on');
        set(handles.discard_button,'enable','on','visible','on');
        set(handles.save_return_button,'enable','off','visible','on');
        set(handles.del_param_button,'visible','on');
        set(handles.del_param_button,'visible','on');
        set(handles.default_button,'visible','off');
    end
    
    %% warnings to be uncommented
    if c < 7
        test = get(handles.my_table,'data');
        test = test{r,c};
        if c == 2
            if not(isreal(test) && rem(test,1)==0)
                warndlg(['Shaft number must be positive and integer','Warning'])
                handles.my_table.Data = main_table_bearing_mask;
                return
            end
        elseif c == 3
            if not(isreal(test) && test > 0)
                warndlg(['Roll. element no. must be positive and integer','Warning'])
                handles.my_table.Data = main_table_bearing_mask;
                return
            end
        elseif c == 4
            if not(isreal(test) && test > 0)
                warndlg(['Bearing roller diameter must be positive and real','Warning'])
                handles.my_table.Data = main_table_bearing_mask;
                return
            end
        elseif c == 5
            if not(isreal(test) && test > 0)
                warndlg(['Pitch circle diameter must be positive and real','Warning'])
                handles.my_table.Data = main_table_bearing_mask;
                return
            end
        elseif c == 6
            if not(test >= 0)
                warndlg(['Contact angle must be non-zero','Warning'])
                handles.my_table.Data = main_table_bearing_mask;
                return
            end
        end
        %             if test <= 0
        %                 warndlg('Please, set a positive value','Warning')
        %                 handles.my_table.Data = main_table_bearing_mask;
        %                 return
        %             elseif not(isreal(test) && rem(test,1)==0)
        %                 warndlg('Please, set an integer value','Warning')
        %                 handles.my_table.Data = main_table_bearing_mask;
        %                 return
        %             else
        %                 main_table_bearing_data{r,c} = test;
        main_table_bearing_mask{r,c} = test;
        main_table_bearing_data{r,c} = main_table_bearing_mask{r,c};
        assignin('base','main_table_bearing_data',main_table_bearing_data);
        assignin('base','main_table_bearing_mask',main_table_bearing_mask);
        return
    end
end

switch c
    case 7  % parameters of distributed fault
        textLabel = sprintf('Settings for the distributed bearing faults');
        set(handles.dynamic_title, 'String', textLabel);
        boolNames = {'outer_race_bool','inner_race_bool','roll_elem_bool'};
        set(handles.default_button,'visible','off');
        set(handles.param_PM_table,'visible','on')
        set(handles.outer_race_bool,'visible','on');
        set(handles.inner_race_bool,'visible','on');
        set(handles.roll_elem_bool,'visible','on');
        assignin('base','c',c);
        assignin('base','r',r);
        handles.param_PM_table.Data = main_table_bearing_data{r,c};
        test = main_table_bearing_data{r,c};
        test = test(:,2:end);
        for k = 1:size(test,2)
            if isempty(find(cell2mat(test(:,k))))
                set(handles.(boolNames{k}),'value',false)
                handles.param_PM_table.ColumnEditable(k+1) = 0;
            else
                set(handles.(boolNames{k}),'value',true)
                handles.param_PM_table.ColumnEditable(k+1) = 1;
            end
        end
    case 8 % parameters of localized fault
        textLabel = sprintf('Settings for the localized bearing faults');
        set(handles.dynamic_title, 'String', textLabel);
        boolNames = {'outer_race_bool','inner_race_bool','roll_elem_bool'};
        set(handles.default_button,'visible','off');
        set(handles.param_loc_table2,'visible','on')
        set(handles.outer_race_bool,'visible','on');
        set(handles.inner_race_bool,'visible','on');
        set(handles.roll_elem_bool,'visible','on');
        assignin('base','c',c);
        assignin('base','r',r);
        handles.param_loc_table2.Data = main_table_bearing_data{r,c};
        test = main_table_bearing_data{r,c};
        test = test(:,2:end);
        for k = 1:size(test,2)
            if isempty(find(cell2mat(test(:,k))))
                set(handles.(boolNames{k}),'value',false)
                handles.param_loc_table2.ColumnEditable(k+1) = 0;
            else
                set(handles.(boolNames{k}),'value',true)
                handles.param_loc_table2.ColumnEditable(k+1) = 1;
            end
        end
end


% CODE FOR SAVE AND RETURN BUTTON (submenu fault parameter definition)
function save_return_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_return_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r = evalin('base', 'r;');
c = evalin('base', 'c;');
Nmh_static = evalin('base', 'Nmh_static;');
%save data
new_data = evalin('base','temp_data;');
main_table_bearing_data = evalin('base','main_table_bearing_data;');
main_table_bearing_data{r,c} = new_data{r,c};
assignin('base','main_table_bearing_data',main_table_bearing_data);
main_table_bearing_mask = data2mask_bearing(main_table_bearing_data);

textLabel = sprintf('General settings for the bearing fault signatures');
set(handles.dynamic_title, 'String', textLabel);

test = main_table_bearing_data;
test = test{1,1};
test = cell2mat(test(:,2:end));
boolLabels = {'outer_race_bool','inner_race_bool','roll_elem_bool'};
for k = 1:size(test,2)
    checkBool(k) = isempty(find(test(:,k)));
    %         set(handles.(boolLabels{k}),'value',0)
    %         if c == 7
    %             handles.param_PM_table.ColumnEditable(k+1) = 0;
    %         elseif c == 8
    %             handles.param_loc_table2.ColumnEditable(k+1) = 0;
    %         end
    %     end
end

% handles.inner_race_bool,'visible','off');
% handles.roll_elem_bool,'visible','off');


% main_table_bearing_mask{r,5} = Nmh_static;
assignin('base','main_table_bearing_mask',main_table_bearing_mask);

%return to main
set(handles.my_table,'visible','on');
set(handles.proceed_button,'visible','on');
set(handles.delete_last_button,'visible','on');
set(handles.new_raw_button,'visible','on');
set(handles.data_check_button,'visible','on','enable','on')
set(handles.param_loc_table2,'visible','off');
set(handles.param_PM_table,'visible','off');
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.accept_button,'visible','off');
set(handles.del_param_button,'visible','off');
set(handles.outer_race_bool,'visible','off');
set(handles.inner_race_bool,'visible','off');
set(handles.roll_elem_bool,'visible','off');
set(handles.default_button,'visible','on');

handles.my_table.Data = main_table_bearing_mask;
evalin('base', 'clear r c Nmh temp_data');
temp_data = [];
assignin('base','temp_data',temp_data);
clear Nmh_static

% CODE FOR DON'T SAVE AND RETURN BUTTON (submenu fault parameter definition)
function discard_button_Callback(hObject, eventdata, handles)
% hObject    handle to discard_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

r = evalin('base', 'r;');
c = evalin('base', 'c;');

textLabel = sprintf('General settings for the bearing fault signatures');
set(handles.dynamic_title, 'String', textLabel);

%just return to main without update data
set(handles.my_table,'visible','on')
set(handles.proceed_button,'visible','on')
set(handles.delete_last_button,'visible','on')
set(handles.new_raw_button,'visible','on')
set(handles.data_check_button,'visible','on','enable','on')
set(handles.param_loc_table2,'visible','off')
set(handles.param_PM_table,'visible','off')
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.accept_button,'visible','off');
set(handles.del_param_button,'visible','off');
set(handles.outer_race_bool,'visible','off');
set(handles.inner_race_bool,'visible','off');
set(handles.roll_elem_bool,'visible','off');
set(handles.default_button,'visible','on');

%keep old data
main_table_bearing_data = evalin('base','main_table_bearing_data');
main_table_bearing_mask = evalin('base','main_table_bearing_mask');
Nmh_static = main_table_bearing_mask(r,5);
assignin('base','main_table_bearing_data',main_table_bearing_data);
main_table_bearing_mask = data2mask_bearing(main_table_bearing_data);
assignin('base','main_table_bearing_mask',main_table_bearing_mask);
handles.my_table.Data = main_table_bearing_mask;
evalin('base', 'clear r c Nmh temp_data');
temp_data = [];
assignin('base','temp_data',temp_data);
clear Nmh_static

% --- Executes when selected cell(s) is changed in my_table.
function my_table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to my_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
evalin('base', 'clear r c');
set(handles.discard_button,'enable','off');
set(handles.proceed_button,'enable','off');
set(handles.save_return_button,'enable','off');
set(handles.data_check_button,'enable','on');
if ~isempty(eventdata.Indices)
    r = eventdata.Indices(1);
    c = eventdata.Indices(2);
    tableData = get(handles.my_table,'data');
end


% CODE FOR DATA SAVING BUTTON WITHIN WS (all submenus)
function accept_button_Callback(hObject, eventdata, handles)

table_names = evalin('base','table_names');
data = evalin('base','main_table_bearing_data');
c = evalin('base','c');
r = evalin('base','r');
% Nmh_static = evalin('base','Nmh_static');
% Nmh = Nmh_static;
thisHandle = table_names{evalin('base','c')};
if c > 6
    temp_data = get(handles.(thisHandle),'Data');
    %     data =
    %     data = get(handles.my_table,'Data');
    data{r,c} = temp_data;
    assignin('base','temp_data',data);
else
    temp_data = get(handles.(thisHandle),'Data');
    %     data = get(handles.my_table,'Data');
    data{r,c} = temp_data;
    assignin('base','temp_data',data);
end
test = temp_data;
test = cell2mat(test(:,2:end));
boolLabels = {'outer_race_bool','inner_race_bool','roll_elem_bool'};
% for k = 1:size(test,2)
%     if isempty(find(test(:,k)))
%         set(handles.(boolLabels{k}),'value',0)
%         if c == 7
%             handles.param_PM_table.ColumnEditable(k+1) = 0;
%         elseif c == 8
%             handles.param_loc_table2.ColumnEditable(k+1) = 0;
%         end
%     end
% end


set(handles.discard_button,'visible','on','enable','on');
set(handles.save_return_button,'visible','on','enable','on');

% CODE FOR DATA DELETE PARAMETERS BUTTON WITHIN WS (all submenus)
function del_param_button_Callback(hObject, eventdata, handles)
% hObject    handle to del_param_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close_flag = questdlg('The parameters of this section will be deleted. Do you want to proceed?','Warning','Yes','No','No');
% Handle response
switch close_flag
    case 'Yes'
        close_flag = 1;
    case 'No'
        close_flag = 0;
end

if close_flag == 1
    
    c = evalin('base','c');
    r = evalin('base','r');
    Nmh_static = evalin('base', 'Nmh_static');
    main_table_bearing_data = evalin('base','main_table_bearing_data');
    main_table_bearing_data{r,c} = 0;
    main_table_bearing_data{r,5} = Nmh_static;
    assignin('base','main_table_bearing_data',main_table_bearing_data);
    main_table_bearing_mask = data2mask_bearing(main_table_bearing_data);
    assignin('base','main_table_bearing_mask',main_table_bearing_mask);
    handles.my_table.Data = main_table_bearing_mask;
    
    %just return to main without update data
    set(handles.my_table,'visible','on')
    set(handles.proceed_button,'visible','on')
    set(handles.delete_last_button,'visible','on')
    set(handles.new_raw_button,'visible','on')
    set(handles.data_check_button,'visible','on','enable','on')
    set(handles.param_loc_table1,'visible','off')
    set(handles.param_loc_table2,'visible','off')
    set(handles.param_PM_table,'visible','off')
    set(handles.discard_button,'visible','off');
    set(handles.save_return_button,'visible','off');
    set(handles.add_mesh_harm_button,'visible','off');
    set(handles.remove_mesh_harm_button,'visible','off')
    set(handles.discard_button,'visible','off');
    set(handles.save_return_button,'visible','off');
    set(handles.param_mesh_harm_table,'visible','off');
    set(handles.accept_button,'visible','off');
    set(handles.del_param_button,'visible','off');
    set(handles.default_button,'visible','on');
    
end

% CODE FOR CLOSING CHECK (all submenus)
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cwa_ord_flag = evalin('base','cwa_ord_flag');
if cwa_ord_flag == 0
    close_flag = questdlg('Exit? (you will lose all data)','Warning','Yes','No','No');
    % Handle response
    switch close_flag
        case 'Yes'
            close_flag = 1;
            delete(hObject);
        case 'No'
            close_flag = 0;
    end
else
    cwa_ord_flag = 0;
    assignin('base','cwa_ord_flag',cwa_ord_flag);
    delete(hObject);
end

% --- Executes on button press in outer_race_bool.
function outer_race_bool_Callback(hObject, eventdata, handles)
% hObject    handle to outer_race_bool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of outer_race_bool
actualBool = get(hObject,'Value'); % actual value on click
r = evalin('base','r');
c = evalin('base','c');

if actualBool == 1
    set(handles.save_return_button,'enable','off');
    if c == 7
        handles.param_PM_table.ColumnEditable(2) = 1;
%         handles.param_PM_table.Data(:,2) = {0;0;0;0;0};
    elseif c == 8
        handles.param_loc_table2.ColumnEditable(2) = 1;
%         handles.param_loc_table2.Data(:,2) = {0;0;0;0;0;0;0};
    end
else
    if c == 7
        set(handles.save_return_button,'enable','off');
        handles.param_PM_table.ColumnEditable(2) = 0;
%         handles.param_PM_table.Data(:,2) = {0;0;0;0;0};
    elseif c == 8
        handles.param_loc_table2.ColumnEditable(2) = 0;
%         handles.param_loc_table2.Data(:,2) = {0;0;0;0;0;0;0};
    end
end

% --- Executes on button press in inner_race_bool.
function inner_race_bool_Callback(hObject, eventdata, handles)
% hObject    handle to inner_race_bool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of inner_race_bool
actualBool = get(hObject,'Value'); % actual value on click
c = evalin('base','c');
if actualBool == 1
    set(handles.save_return_button,'enable','off');
    if c == 7
        handles.param_PM_table.ColumnEditable(3) = 1;
        handles.param_PM_table.Data(:,3) = {0;0;0;0;0};
    elseif c == 8
        handles.param_loc_table2.ColumnEditable(3) = 1;
        handles.param_loc_table2.Data(:,3) = {0;0;0;0;0;0;0};
    end
else
    if c == 7
        set(handles.save_return_button,'enable','off');
        handles.param_PM_table.ColumnEditable(3) = 0;
        handles.param_PM_table.Data(:,3) = {0;0;0;0;0};
    elseif c == 8
        handles.param_loc_table2.ColumnEditable(3) = 0;
        handles.param_loc_table2.Data(:,3) = {0;0;0;0;0;0;0};
    end
end


% --- Executes on button press in roll_elem_bool.
function roll_elem_bool_Callback(hObject, eventdata, handles)
% hObject    handle to roll_elem_bool (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of roll_elem_bool
actualBool = get(hObject,'Value'); % actual value on click
c = evalin('base','c');
r = evalin('base','c');

if actualBool == 1
    set(handles.save_return_button,'enable','off');
    if c == 7
        handles.param_PM_table.ColumnEditable(4) = 1;
        handles.param_PM_table.Data(:,4) = {0;0;0;0;0};
    elseif c == 8
        handles.param_loc_table2.ColumnEditable(4) = 1;
        handles.param_loc_table2.Data(:,4) = {0;0;0;0;0;0;0};
    end
else
    if c == 7
        set(handles.save_return_button,'enable','off');
        handles.param_PM_table.ColumnEditable(4) = 0;
        handles.param_PM_table.Data(:,4) = {0;0;0;0;0};
    elseif c == 8
        handles.param_loc_table2.ColumnEditable(4) = 0;
        handles.param_loc_table2.Data(:,4) = {0;0;0;0;0;0;0};
    end
end


% --- Executes when entered data in editable cell(s) in param_PM_table.
function param_PM_table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to param_PM_table (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
set(handles.save_return_button,'enable','off');


% --- Executes on button press in default_button.
function default_button_Callback(hObject, eventdata, handles)
% hObject    handle to default_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close_flag = questdlg('Do you want to restore default paramaters?','Warning','Yes','No','No');
% Handle response
switch close_flag
    case 'Yes'
        eval('clear(''main_table_bearing_data'')')
        eval('clear(''main_table_bearing_mask'')')
        data = [];
        assignin('base','data',data);
        % default data
        % data initialization
        data = [];
        assignin('base','data',data);
        % default data
        main_table_bearing_mask = {1,1,9,8,38,9,false,false};
        assignin('base','main_table_bearing_mask',main_table_bearing_mask)
        handles.my_table.Data = main_table_bearing_mask;
        main_table_bearing_data = main_table_bearing_mask;
        main_table_bearing_data{1,7} = {'<HTML>periodic contribution (outer race period)</HTML>',0,0,0;
            '<HTML>periodic contribution (shaft rotation period)</HTML>',0,0,0;
            '<HTML>amplitude modulation</HTML>',0,0,0;
            '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
            '<HTML>&zeta; (%)</HTML>',0,0,0};
        main_table_bearing_data{1,8} = {'<HTML>jitter (%&Delta&Theta<sub>imp</sub>)</HTML>',0,0,0;
            '<HTML>&mu of impact amplitude &delta </HTML>',0,0,0;
            '<HTML>&sigma of impact amplitude &delta </HTML>',0,0,0;
            '<HTML>periodic modulation </HTML>',0,0,0;
            '<HTML>double impact amplitude (RE fault only) </HTML>',0,0,0;
            '<HTML>f<sub>n</sub>(Hz)</HTML>',0,0,0;
            '<HTML>&zeta; (%)</HTML>',0,0,0};
        assignin('base','main_table_bearing_data',main_table_bearing_data)
        % initialize counter for new raws with automatic numbering
        count_new_raw = 1; assignin('base','count_new_raw',count_new_raw);
    case 'No'
end
