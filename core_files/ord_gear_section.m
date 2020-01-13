function varargout = ord_gear_section(varargin)
%
%   GUI for defining the ordinary gear parameters
%   output: cell matrix
% 
% M. Buzzoni
% Mar 2018

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ord_gear_section_OpeningFcn, ...
                   'gui_OutputFcn',  @ord_gear_section_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% Preamble (initialization and other stuff)
function ord_gear_section_OpeningFcn(hObject, ~, handles, varargin)

% Choose default command line output for ord_gear_section
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Main uitable parameters
handles.my_table.ColumnName = {'Gear no.','Shaft','Mating gear','No. of teeth','No. of mesh harmonics','Distributed fault','Localized fault','LTI system parameters'};
handles.my_table.ColumnWidth{1} = 100; handles.my_table.ColumnEditable(1) = 0;
handles.my_table.ColumnWidth{2} = 100; handles.my_table.ColumnEditable(2) = 1;
handles.my_table.ColumnWidth{3} = 100; handles.my_table.ColumnEditable(3) = 1;
handles.my_table.ColumnWidth{4} = 100; handles.my_table.ColumnEditable(4) = 1;
handles.my_table.ColumnWidth{5} = 100; handles.my_table.ColumnEditable(5) = 1;
handles.my_table.ColumnWidth{6} = 120; handles.my_table.ColumnEditable(6) = 1; handles.my_table.ColumnFormat{6} =  'logical';
handles.my_table.ColumnWidth{7} = 120; handles.my_table.ColumnEditable(7) = 1; handles.my_table.ColumnFormat{7} =  'logical';
handles.my_table.ColumnWidth{8} = 130; handles.my_table.ColumnEditable(8) = 1; handles.my_table.ColumnFormat{8} =  'logical';
% handles.my_table.ColumnWidth{9} = 130; handles.my_table.ColumnEditable(9) = 1; handles.my_table.ColumnFormat{9} =  'logical';

try
    main_table_ord_data = evalin('base','main_table_ord_data;');
    main_table_ord_mask = main_table_ord_data;
    main_table_ord_mask = data2mask(main_table_ord_mask);
    handles.my_table.Data = main_table_ord_mask;
catch
    % data initialization
    data = [];
    assignin('base','data',data);
    % default data
    main_table_ord_mask = {1,1,2,8,1,false,false,false; 2,2,1,11,1,false,false,false};
    assignin('base','main_table_ord_mask',main_table_ord_mask)
    handles.my_table.Data = main_table_ord_mask;
    main_table_ord_data = main_table_ord_mask;
    main_table_ord_data{1,5} = {1,0,0};
    main_table_ord_data{2,5} = {1,0,0};
    assignin('base','main_table_ord_data',main_table_ord_data)
end

% setting up the tables
handles.my_table.ColumnEditable(5) = 0;

% intialize dynamic titles
textLabel = sprintf('General settings for the gear fault signatures');
set(handles.dynamic_title, 'String', textLabel);


%   localized faults
set(handles.param_loc_table1,'visible','off')
handles.param_loc_table1.ColumnEditable(1) = 0;
handles.param_loc_table1.ColumnEditable(2) = 1;
handles.param_loc_table1.ColumnEditable(3) = 1;
handles.param_loc_table1.ColumnEditable(4) = 1;
set(handles.param_loc_table2,'visible','off')
handles.param_loc_table2.ColumnEditable(1) = 0;
handles.param_loc_table2.ColumnEditable(2) = 1;
handles.param_loc_table2.ColumnEditable(3) = 1;
handles.param_loc_table2.ColumnEditable(4) = 1;
set(handles.param_loc_table3,'visible','off')
handles.param_loc_table3.ColumnEditable(1) = 1;
handles.param_loc_table3.ColumnEditable(2) = 1;
handles.param_loc_table3.ColumnEditable(3) = 1;
%   distributed faults (AM)     
set(handles.param_AM_table,'visible','off')
handles.param_AM_table.ColumnEditable(1) = 0;
handles.param_AM_table.ColumnEditable(2) = 1;
handles.param_AM_table.ColumnEditable(3) = 1;
%   distributed faults (PM)
set(handles.param_PM_table,'visible','off')
handles.param_PM_table.ColumnEditable(1) = 0;
handles.param_PM_table.ColumnEditable(2) = 1;
handles.param_PM_table.ColumnEditable(3) = 1;
% 	mesh harmonics
set(handles.param_mesh_harm_table,'visible','off')
handles.param_mesh_harm_table.ColumnEditable(1) = 0;
handles.param_mesh_harm_table.ColumnEditable(2) = 1;
handles.param_mesh_harm_table.ColumnEditable(3) = 1;
% 	LTI parameters
set(handles.table_LTI_paramater,'visible','off')
handles.table_LTI_paramater.ColumnEditable(1) = 1;
handles.table_LTI_paramater.ColumnEditable(2) = 1;
set(handles.table_LTI_paramater_rand,'visible','off')
handles.table_LTI_paramater_rand.ColumnEditable(1) = 1;
handles.table_LTI_paramater_rand.ColumnEditable(2) = 1;
% 	cyclostationary parameters
set(handles.table_cyclostationary_distr,'visible','off')
handles.table_cyclostationary_distr.ColumnEditable(1) = 0;
handles.table_cyclostationary_distr.ColumnEditable(2) = 1;
handles.table_cyclostationary_distr.ColumnEditable(3) = 1;


% setting button visibility             
set(handles.default_button,'visible','on')
set(handles.title_cycl_distr,'visible','off')
set(handles.faulty_tooth_number,'visible','off')
set(handles.title_faulty_tooth,'visible','off')
set(handles.title1_distributed,'visible','off')
set(handles.title2_distributed,'visible','off')
set(handles.title_loc_contribution,'visible','off')
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.proceed_button,'enable','off');
set(handles.delete_last_button,'enable','off');
set(handles.add_mesh_harm_button,'visible','off');
set(handles.remove_mesh_harm_button,'visible','off');
set(handles.remove_mesh_harm_button,'enable','off');
set(handles.accept_button,'visible','off');
set(handles.del_param_button,'visible','off');
set(handles.title1_LTI,'visible','off');
set(handles.title2_LTI,'visible','off');

% intialize dynamic titles
% textLabel = sprintf('General settings for ordinary gear signals');
% set(handles.dynamic_title, 'String', textLabel);

% initialize counter for new raws with automatic numbering
count_new_raw = 2; assignin('base','count_new_raw',count_new_raw);

% close without ask flag
cwa_ord_flag = 0;
assignin('base','cwa_ord_flag',cwa_ord_flag)

% static variable for mesh harmonic number
Nmh_static = 1;
assignin('base','Nmh_static',Nmh_static);

% static variable for recalling tables
table_names = {{},{},{},{},'param_mesh_harm_table','param_AM_table','param_PM_table','param_loc_table1','param_loc_table2','param_loc_table3','faulty_tooth_number'};
assignin('base','table_names',table_names);

% data matrix initialization
temp_data = [];
assignin('base','temp_data',temp_data);
% UIWAIT makes ord_gear_section wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ord_gear_section_OutputFcn(~, ~, handles)
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
count_new_raw = evalin('base', 'count_new_raw');
count_new_raw = count_new_raw + 1; assignin('base','count_new_raw',count_new_raw);
tableData = evalin('base','main_table_ord_data');
% tableData = get(handles.my_table, 'data');
newData = [tableData; {count_new_raw,0,0,0,{0,0},false,false,false}];
main_table_ord_data = newData; assignin('base','main_table_ord_data',main_table_ord_data)
main_table_ord_mask = data2mask(main_table_ord_data); assignin('base','main_table_ord_mask',main_table_ord_mask)
handles.my_table.Data = main_table_ord_mask;
set(handles.proceed_button,'enable','off');
textLabel = sprintf('');
set(handles.delete_last_button,'enable','on');
set(handles.data_check_button,'enable','on');


% CODE FOR DATA CHECK BUTTON
function data_check_button_Callback(~, ~, handles)
% hObject    handle to data_check_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
main_table_ord_mask = evalin('base', 'main_table_ord_mask'); % update table
% main_table_ord_mask = handles.my_table.Data;
%
% handles.my_table.Data = main_table_ord_mask;
% tableData = get(handles.my_table, 'data');
y = checkFun(main_table_ord_mask);
if y == 0
    set(handles.proceed_button,'enable','on');
    set(handles.data_check_button,'enable','off');
elseif y == 1
    set(handles.proceed_button,'enable','off');
end

% check if the gm harmonics are nil
main_table_ord_data = evalin('base','main_table_ord_data');
v_noGMharm = zeros(1,size(main_table_ord_data,1));

for j = 1:size(main_table_ord_data,1)
    if sum(main_table_ord_data{j,5}{:,2}) == 0
        v_noGMharm(j) = 1;
    end
end

if sum(v_noGMharm) > 0
f = warndlg('There is at least one gear with gearmesh contribution set to zero','Warning');
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
close('ord_gear_section')

% CODE FOR DELETE LAST RAW BUTTON
function delete_last_button_Callback(~, ~, handles)
% hObject    handle to delete_last_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.data_check_button,'enable','on');
close_flag = questdlg('Deleting the last raw you will delete all related parameters. Do you want to proceed?','Warning','Yes','No','No');
% Handle response
switch close_flag
    case 'Yes'
        close_flag = 1;
    case 'No'
        close_flag = 0;
end

if close_flag == 1
    main_table_ord_data = evalin('base','main_table_ord_data');
    main_table_ord_mask = evalin('base','main_table_ord_mask');
    count_new_raw = size(main_table_ord_data,1); %evalin('base', 'count_new_raw');
    main_table_ord_data(count_new_raw,:) = []; assignin('base','main_table_ord_data',main_table_ord_data);
    main_table_ord_mask(count_new_raw,:) = []; assignin('base','main_table_ord_mask',main_table_ord_mask);
    handles.my_table.Data = main_table_ord_mask;
    count_new_raw = count_new_raw - 1; assignin('base','count_new_raw',count_new_raw);
    if count_new_raw < 3
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
    main_table_ord_data = evalin('base','main_table_ord_data');
    main_table_ord_mask = evalin('base','main_table_ord_mask');
    Nmh = size(main_table_ord_data{r,5},1);
    % set def value or given parameters if available
    
    if c > 5
        % hide main table
        set(handles.default_button,'visible','off')
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
    end
    
    if c < 5
        test = get(handles.my_table,'data');
        test = test{r,c};
        if c < 3 && r < 3
            warndlg('The first two shaft numbers cannot be modified','Warning')
            handles.my_table.Data = main_table_ord_mask;
            return
        end
        
        if test <= 0
            warndlg('Please, set a positive value','Warning')
            handles.my_table.Data = main_table_ord_mask;
            return
        elseif not(isreal(test) && rem(test,1)==0)
            warndlg('Please, set an integer value','Warning')
            handles.my_table.Data = main_table_ord_mask;
            return
        else
            main_table_ord_data{r,c} = test;
            main_table_ord_mask{r,c} = test;
            assignin('base','main_table_ord_data',main_table_ord_data);
            assignin('base','main_table_ord_mask',main_table_ord_mask);
            return
            %             handles.my_table.Data = test;
            %             assignin('base','main_table_ord_data',main_table_ord_data);
            %             assignin('base','main_table_ord_mask',main_table_ord_mask);
            %             return
        end
    end
    
    switch c
        case 6 % parameters of distributed fault
            set(handles.param_AM_table,'visible','on')
            set(handles.param_PM_table,'visible','on')
            set(handles.table_cyclostationary_distr,'visible','on')
            set(handles.title_cycl_distr,'visible','on')
            set(handles.title1_distributed,'visible','on')
            set(handles.title2_distributed,'visible','on')
            textLabel = sprintf('Settings for the distributed gear faults');
            set(handles.dynamic_title, 'String', textLabel);
            assignin('base','c',c);
            assignin('base','r',r);
            handles.param_AM_table.ColumnName = {'mesh harmonic no.','a [0,1]','<HTML>b (deg)</HTML>'};
            handles.param_PM_table.ColumnName = {'mesh harmonic no.','a [0,1]','<HTML>b (deg)</HTML>'};
            handles.table_cyclostationary_distr.ColumnName = {'mesh harmonic no.','a [0,1]','<HTML>b (deg)</HTML>'};
            if length( main_table_ord_data{r,c}) > 2
                handles.param_AM_table.Data = main_table_ord_data{r,c}(:,1:3);
                handles.param_PM_table.Data = main_table_ord_data{r,c}(:,4:6);
                handles.table_cyclostationary_distr.Data = main_table_ord_data{r,c}(:,7:9);
%                 set(handles.cycl_distr, 'String', main_table_ord_data{r,c}{1,7});
            else
                handles.param_AM_table.Data = {1,0,0};
                handles.param_PM_table.Data = {1,0,0};
                handles.table_cyclostationary_distr.Data = {1,0,0};
                for ind = 2:Nmh
                    tableData1 = get(handles.param_AM_table, 'data');
                    newData1 = [tableData1; {ind,0,0}];
                    tableData2 = get(handles.param_PM_table, 'data');
                    newData2 = [tableData2; {ind,0,0}];
                    tableData3 = get(handles.table_cyclostationary_distr, 'data');
                    newData3 = [tableData3; {ind,0,0}];
                    handles.param_AM_table.Data = newData1;
                    handles.param_PM_table.Data = newData2;
                    handles.table_cyclostationary_distr.Data = newData3;
                end
%                 set(handles.cycl_distr, 'String','0');
            end
            
            
        case 7
            set(handles.faulty_tooth_number,'visible','on')
            set(handles.title_faulty_tooth,'visible','on')
            set(handles.param_loc_table1,'visible','on')
            set(handles.param_loc_table2,'visible','on')
            set(handles.param_loc_table3,'visible','on')
            set(handles.title_loc_contribution,'visible','on')
            set(handles.title1_distributed,'visible','on')
            set(handles.title2_distributed,'visible','on')
            textLabel = sprintf('Settings for the localized gear faults');
            set(handles.dynamic_title, 'String', textLabel);
            assignin('base','c',c);
            assignin('base','r',r);
            handles.param_loc_table1.ColumnName = {'mesh harmonic no.','a [0,1]','<HTML>b (deg)</HTML>','<HTML>&sigma;</HTML>'};
            handles.param_loc_table2.ColumnName = {'mesh harmonic no.','a [0,1]','<HTML>b (deg)</HTML>','<HTML>&sigma;</HTML>'};
            handles.param_loc_table3.ColumnName = {'<HTML>W</HTML>','<HTML>&sigma;</HTML>'};
            if length( main_table_ord_data{r,c}) > 2
%                 for r_ind = 1:
                handles.param_loc_table1.Data = main_table_ord_data{r,c}(:,1:4);
                handles.param_loc_table2.Data = main_table_ord_data{r,c}(:,5:8);
                handles.param_loc_table3.Data = main_table_ord_data{r,c}(9:10);
%                 end
                set(handles.faulty_tooth_number, 'String', main_table_ord_data{r,c}{1,11});
            else
                handles.param_loc_table1.Data = {1,0,0,0};
                handles.param_loc_table2.Data = {1,0,0,0};
                for ind = 2:Nmh
                    tableData1 = get(handles.param_loc_table1, 'data');
                    newData1 = [tableData1; {ind,0,0,0}];
                    handles.param_loc_table1.Data = newData1;
                    tableData2 = get(handles.param_loc_table2, 'data');
                    newData2 = [tableData2; {ind,0,0,0}];
                    handles.param_loc_table2.Data = newData1;
                end
                handles.param_loc_table3.Data = {1,0.0002};
                set(handles.faulty_tooth_number, 'String','1');
            end
        case 8
            set(handles.title1_LTI,'visible','on');
            set(handles.title2_LTI,'visible','on');
            set(handles.table_LTI_paramater_rand,'visible','on')
            set(handles.table_LTI_paramater,'visible','on')
            textLabel = sprintf('Settings for the LTI systems');
            set(handles.dynamic_title, 'String', textLabel);
            assignin('base','c',c);
            assignin('base','r',r);
            handles.table_LTI_paramater_rand.ColumnName = {'<HTML>f<sub>n</sub> (Hz)</HTML>','<HTML>&zeta; (%)</HTML>'};
            handles.table_LTI_paramater.ColumnName = {'<HTML>f<sub>n</sub> (Hz)</HTML>','<HTML>&zeta; (%)</HTML>'};
            
            if length( main_table_ord_data{r,c}) > 2
                handles.table_LTI_paramater.Data = main_table_ord_data{r,c}(1:2);
                handles.table_LTI_paramater_rand.Data = main_table_ord_data{r,c}(3:4);
            else
                handles.table_LTI_paramater.Data = {0,0};
                handles.table_LTI_paramater_rand.Data = {0,0};
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

% intialize dynamic titles
textLabel = sprintf('General settings for the bearing fault signatures');
set(handles.dynamic_title, 'String', textLabel);

%save data
new_data = evalin('base','temp_data;');
main_table_ord_data = evalin('base','main_table_ord_data;');
main_table_ord_data{r,c} = new_data{r,c};
assignin('base','main_table_ord_data',main_table_ord_data);
main_table_ord_mask = data2mask(main_table_ord_data);
% main_table_ord_mask{r,5} = Nmh_static;
assignin('base','main_table_ord_mask',main_table_ord_mask);

if c == 5
    for ind = 6:7
        if length(main_table_ord_data{r,ind}) > 2 && size(main_table_ord_data{r,ind},1) ~= Nmh_static % && size(main_table_ord_data{r,5},1) - size(main_table_ord_data{r,ind},1) > 0
            missingNmh = Nmh_static - size(main_table_ord_data{r,ind},1);
            if missingNmh > 0
                if ind == 6
                    tableData = main_table_ord_data{r,ind};
                    for k = 1:abs(missingNmh)
                        tableData = [tableData; {1,0,0,1,0,0,1,0,0}];
                    end
                    main_table_ord_data{r,ind} = tableData;
                elseif ind == 7
                    tableData = main_table_ord_data{r,ind};
                    for k = 1:abs(missingNmh)
                        tableData = [tableData; {1,0,0,0,1,0,0,0,1,0.0002,'1'}];
                    end
                    main_table_ord_data{r,ind} = tableData;
%                 elseif ind == 8
%                     tableData = main_table_ord_data{r,ind};
%                     W = tableData{1,6};
%                     sigma = tableData{1,7};
%                     faultedTooth = tableData{1,8};
%                     for k = 1:abs(missingNmh)
%                         newData = [tableData; {r,0,0,0,0,W,sigma,faultedTooth}];
%                     end
%                     main_table_ord_data{r,ind} = tableData;
                end
            elseif missingNmh < 0
                for k = 1:abs(missingNmh)
                    main_table_ord_data{r,ind}(end,:) = [];
                end
                %                 elseif ind == 8
            end
        end
    end
end
assignin('base','main_table_ord_data',main_table_ord_data);


%return to main
set(handles.title1_LTI,'visible','off');
set(handles.title2_LTI,'visible','off');
set(handles.table_LTI_paramater_rand,'visible','off')
set(handles.table_LTI_paramater,'visible','off')
set(handles.table_cyclostationary_distr,'visible','off')
set(handles.title_cycl_distr,'visible','off')
set(handles.faulty_tooth_number,'visible','off')
set(handles.title_faulty_tooth,'visible','off')
set(handles.title_loc_contribution,'visible','off')
set(handles.param_loc_table3,'visible','off')
set(handles.title1_distributed,'visible','off')
set(handles.title2_distributed,'visible','off')
set(handles.default_button,'visible','on')
set(handles.my_table,'visible','on');
set(handles.proceed_button,'visible','on');
set(handles.delete_last_button,'visible','on');
set(handles.new_raw_button,'visible','on');
set(handles.data_check_button,'visible','on','enable','on')
set(handles.param_loc_table1,'visible','off');
set(handles.param_loc_table2,'visible','off');
set(handles.param_AM_table,'visible','off');
set(handles.param_PM_table,'visible','off');
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.add_mesh_harm_button,'visible','off');
set(handles.remove_mesh_harm_button,'visible','off');
set(handles.discard_button,'visible','off');
set(handles.save_return_button,'visible','off');
set(handles.param_mesh_harm_table,'visible','off');
set(handles.accept_button,'visible','off');
set(handles.del_param_button,'visible','off');

handles.my_table.Data = main_table_ord_mask;
evalin('base', 'clear r c Nmh temp_data');
temp_data = [];
assignin('base','temp_data',temp_data);
clear Nmh_static

% CODE FOR DON'T SAVE AND RETURN BUTTON (submenu fault parameter definition)
function discard_button_Callback(hObject, eventdata, handles)
% hObject    handle to discard_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% intialize dynamic titles
textLabel = sprintf('General settings for the bearing fault signatures');
set(handles.dynamic_title, 'String', textLabel);


r = evalin('base', 'r;');
c = evalin('base', 'c;');

%just return to main without update data
set(handles.title1_LTI,'visible','off');
set(handles.title2_LTI,'visible','off');
set(handles.table_LTI_paramater_rand,'visible','off')
set(handles.table_LTI_paramater,'visible','off')
set(handles.table_cyclostationary_distr,'visible','off')
set(handles.title_cycl_distr,'visible','off')
set(handles.faulty_tooth_number,'visible','off')
set(handles.title_faulty_tooth,'visible','off')
set(handles.title_loc_contribution,'visible','off')
set(handles.param_loc_table3,'visible','off')
set(handles.default_button,'visible','on')
set(handles.my_table,'visible','on')
set(handles.proceed_button,'visible','on')
set(handles.delete_last_button,'visible','on')
set(handles.new_raw_button,'visible','on')
set(handles.data_check_button,'visible','on','enable','on')
set(handles.title1_distributed,'visible','off')
set(handles.title2_distributed,'visible','off')
set(handles.title_loc_contribution,'visible','off')
set(handles.param_loc_table1,'visible','off')
set(handles.param_loc_table2,'visible','off')
set(handles.param_AM_table,'visible','off')
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

%keep old data
main_table_ord_data = evalin('base','main_table_ord_data');
main_table_ord_mask = evalin('base','main_table_ord_mask');
Nmh_static = main_table_ord_mask(r,5);
assignin('base','main_table_ord_data',main_table_ord_data);
main_table_ord_mask = data2mask(main_table_ord_data);
assignin('base','main_table_ord_mask',main_table_ord_mask);
handles.my_table.Data = main_table_ord_mask;
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
set(handles.default_button,'visible','off')
if ~isempty(eventdata.Indices)
    r = eventdata.Indices(1);
    c = eventdata.Indices(2);
    main_table_ord_data = evalin('base','main_table_ord_data'); % test
    tableData = get(handles.my_table,'data');
    Nmh_static = tableData{r,5}; assignin('base','Nmh_static',Nmh_static)
    
    if c == 5 % parameters of mesh harmonics
        assignin('base','c',c);
        assignin('base','r',r);
        textLabel = sprintf('Parameters for mesh harmonics');
        set(handles.dynamic_title, 'String', textLabel);
        % hide main table
        set(handles.my_table,'visible','off')
        set(handles.proceed_button,'visible','off')
        set(handles.delete_last_button,'visible','off')
        set(handles.new_raw_button,'visible','off')
        set(handles.data_check_button,'visible','off','enable','on');
        % display parameter table
        set(handles.add_mesh_harm_button,'visible','on');
        set(handles.remove_mesh_harm_button,'visible','on')
        set(handles.param_mesh_harm_table,'visible','on')
        set(handles.discard_button,'visible','on','enable','on');
        set(handles.save_return_button,'visible','on','enable','off');
        set(handles.accept_button,'visible','on');
        handles.param_mesh_harm_table.Data = {1,1,0};
        handles.param_mesh_harm_table.ColumnName = {'mesh harmonic no.','Amplitude','Phase (deg)'};
        for ind = 2:evalin('base','Nmh_static')
            tableData = get(handles.param_mesh_harm_table, 'data');
            newData = [tableData; {ind,0,0}];
            handles.param_mesh_harm_table.Data = newData;
        end
        handles.param_mesh_harm_table.Data = main_table_ord_data{r,c}; % test
    end
end

% CODE FOR ADDING MESH HARMONICS (submenu mesh harmonics)
function add_mesh_harm_button_Callback(hObject, eventdata, handles)
c = evalin('base','c');
r = evalin('base','r');
actual_Nmh = evalin('base','Nmh_static');
actual_Nmh = actual_Nmh + 1;
assignin('base','Nmh_static',actual_Nmh);
tableData = get(handles.param_mesh_harm_table, 'data');
newData = [tableData; {actual_Nmh,0,0}];
handles.param_mesh_harm_table.Data = newData;

% % va nel salvataggio
% for ind = 6:9
%     if length(main_table_ord_data{c,ind}) > 2 & size(main_table_ord_data{c,ind},1) ~= size(main_table_ord_data{c,5},1)
%         if ind == 6
%             tableData = get(handles.param_AM_table, 'data');
%             newData = [tableData; {ind,0,0}];
%             handles.param_AM_table.Data = newData;
%         elseif ind == 8
%             % devo aggiungere una riga
%             tableData = get(handles.param_loc_table1, 'data');
%             newData = [tableData; {r,0,0,0,0}];
%             main_table_ord_data.Data = newData;
%         end
%     end
% end

set(handles.remove_mesh_harm_button,'enable','on');
set(handles.discard_button,'visible','on','enable','on');
set(handles.save_return_button,'visible','on','enable','off');

% CODE FOR REMOVING MESH HARMONICS (submenu mesh harmonics)
function remove_mesh_harm_button_Callback(hObject, eventdata, handles)
actual_Nmh = evalin('base','Nmh_static');
% actual_Nmh = evalin('base', 'Nmh_static');
tableData = get(handles.param_mesh_harm_table, 'data');
tableData(actual_Nmh,:) = [];
handles.param_mesh_harm_table.Data = tableData;
actual_Nmh = actual_Nmh - 1
assignin('base','Nmh_static',actual_Nmh);
if actual_Nmh < 2
    set(handles.remove_mesh_harm_button,'enable','off');
end
set(handles.discard_button,'visible','on','enable','off');
set(handles.save_return_button,'visible','on','enable','off');

% CODE FOR DATA ACCEPTANCE BUTTON WITHIN WS (all submenus)
function accept_button_Callback(hObject, eventdata, handles)

table_names = evalin('base','table_names');
c = evalin('base','c');
r = evalin('base','r');
Nmh_static = evalin('base','Nmh_static');
Nmh = Nmh_static;
thisHandle = table_names{evalin('base','c')};
if c == 6
    temp_data = get(handles.param_AM_table,'Data');
    temp_data2 = get(handles.param_PM_table,'Data');
    temp_data3 = get(handles.table_cyclostationary_distr,'Data');
%     temp_data3 = {get(handles.cycl_distr,'String')};
%     temp_data3 = repmat(temp_data3,Nmh,1);
    temp_data = [temp_data, temp_data2 temp_data3];
    data = get(handles.my_table,'Data');
    data{r,c} = temp_data;
    assignin('base','temp_data',data)
elseif c == 7
    temp_data = get(handles.param_loc_table1,'Data');
    temp_data2 = get(handles.param_loc_table2,'Data');
    temp_data3 = get(handles.param_loc_table3,'Data');
    temp_data4 = {get(handles.faulty_tooth_number,'String')};
    temp_data3 = repmat(temp_data3,Nmh,1);
    temp_data4 = repmat(temp_data4,Nmh,1);
    temp_data = [temp_data, temp_data2, temp_data3, temp_data4];
    data = get(handles.my_table,'Data');
    data{r,c} = temp_data;
    assignin('base','temp_data',data);
elseif c == 8
    temp_data = get(handles.table_LTI_paramater,'Data');
    temp_data2 = get(handles.table_LTI_paramater_rand,'Data');
    temp_data = [temp_data, temp_data2];
    data = get(handles.my_table,'Data');
    data{r,c} = temp_data;
    assignin('base','temp_data',data);
elseif c == 5
    temp_data = get(handles.(thisHandle),'Data');
%     temp_data = get(handles.(thisHandle),'Data');
    data = get(handles.my_table,'Data');
    data{r,c} = temp_data;
    assignin('base','temp_data',data);
end

set(handles.discard_button,'visible','on','enable','on');
set(handles.save_return_button,'visible','on','enable','on');
temp_data = get(handles.param_mesh_harm_table, 'data');

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
    main_table_ord_data = evalin('base','main_table_ord_data');
    main_table_ord_data{r,c} = 0;
    main_table_ord_data{r,5} = Nmh_static;
    assignin('base','main_table_ord_data',main_table_ord_data);
    main_table_ord_mask = data2mask(main_table_ord_data);
    assignin('base','main_table_ord_mask',main_table_ord_mask);
    handles.my_table.Data = main_table_ord_mask;
    
    %just return to main without update data
    set(handles.default_button,'visible','on')
    set(handles.table_LTI_paramater_rand,'visible','off')
    set(handles.table_LTI_paramater,'visible','off')
    set(handles.table_cyclostationary_distr,'visible','off')
    set(handles.title_cycl_distr,'visible','off')
    set(handles.faulty_tooth_number,'visible','off')
    set(handles.title_faulty_tooth,'visible','off')
    set(handles.title_loc_contribution,'visible','off')
    set(handles.param_loc_table3,'visible','off')
    set(handles.my_table,'visible','on')
    set(handles.proceed_button,'visible','on')
    set(handles.delete_last_button,'visible','on')
    set(handles.new_raw_button,'visible','on')
    set(handles.data_check_button,'visible','on','enable','on')
    set(handles.param_loc_table1,'visible','off')
    set(handles.param_loc_table2,'visible','off')
    set(handles.param_AM_table,'visible','off')
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
    set(handles.title1_distributed,'visible','off');
    set(handles.title2_distributed,'visible','off');
    set(handles.title1_LTI,'visible','off');
    set(handles.title2_LTI,'visible','off');
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



function faulty_tooth_number_Callback(hObject, eventdata, handles)
% hObject    handle to faulty_tooth_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of faulty_tooth_number as text
%        str2double(get(hObject,'String')) returns contents of faulty_tooth_number as a double


% --- Executes during object creation, after setting all properties.
function faulty_tooth_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to faulty_tooth_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cycl_distr_Callback(hObject, eventdata, handles)
% hObject    handle to cycl_distr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cycl_distr as text
%        str2double(get(hObject,'String')) returns contents of cycl_distr as a double


% --- Executes during object creation, after setting all properties.
function cycl_distr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cycl_distr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in default_button.
function default_button_Callback(hObject, eventdata, handles)
% hObject    handle to default_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close_flag = questdlg('Do you want to restore default paramaters?','Warning','Yes','No','No');
% Handle response
switch close_flag
    case 'Yes'
        eval('clear(''main_table_ord_data'')')
        eval('clear(''main_table_ord_mask'')')
        data = [];
        assignin('base','data',data);
        % default data
        main_table_ord_mask = {1,1,2,23,1,false,false,false; 2,2,1,11,1,false,false,false};
        assignin('base','main_table_ord_mask',main_table_ord_mask)
        handles.my_table.Data = main_table_ord_mask;
        main_table_ord_data = main_table_ord_mask;
        main_table_ord_data{1,5} = {1,0,0};
        main_table_ord_data{2,5} = {1,0,0};
        assignin('base','main_table_ord_data',main_table_ord_data)
    case 'No'
end
