function varargout = main_menu(varargin)
%
%   GUI of the main menu
% 
% M. Buzzoni
% Mar 2018


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_menu_OpeningFcn, ...
                   'gui_OutputFcn',  @main_menu_OutputFcn, ...
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

% --- Executes just before main_menu is made visible.
function main_menu_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_menu (see VARARGIN)

% Choose default command line output for main_menu
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.bearing_button,'enable','off')
set(handles.ord_gear_button,'enable','off')
set(handles.noise_button,'enable','off')
set(handles.gen_signal,'enable','off')

WSvariableName = whos;
WSvariableName = {WSvariableName.name};

try
    evalin('base','speed_profile;');
    set(handles.bearing_button,'enable','on')
    set(handles.ord_gear_button,'enable','on')
    %     set(handles.noise_button,'enable','on')
end

try
    evalin('base','main_table_bearing_data;');
    set(handles.gen_signal,'enable','on')
    set(handles.noise_button,'enable','on')
end

try
    evalin('base','main_table_ord_data;');
    set(handles.gen_signal,'enable','on')
    set(handles.noise_button,'enable','on')
end

% % flag for speed profile
% flagSpeedProfile = 0;
% assignin('base','flagSpeedProfile',flagSpeedProfile)
% % flag for speed profile
% cwa_main_flag = 0;
% assignin('base','cwa_main_flag',cwa_main_flag)

% set visibility
try
    evalin('base','speed')
catch
% set(handles.ord_gear_button,'enable','off')
% set(handles.noise_button,'enable','off')
% set(handles.bearing_button,'enable','off')
end

% UIWAIT makes main_menu wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_menu_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in speed_profile_button.
function speed_profile_button_Callback(hObject, eventdata, handles)
% hObject    handle to speed_profile_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
flagSpeedProfile = 1;
assignin('base','flagSpeedProfile',flagSpeedProfile);
cwa_main_flag = 0;
assignin('base','cwa_main_flag',cwa_main_flag);

run('main_speed_profile')
close('main_menu')

% --- Executes on button press in ord_gear_button.
function ord_gear_button_Callback(hObject, eventdata, handles)
% hObject    handle to ord_gear_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('ord_gear_section')
close('main_menu')

% --- Executes on button press in noise_button.
function noise_button_Callback(hObject, eventdata, handles)
% hObject    handle to noise_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('noise_section')
close('main_menu')

% --- Executes on button press in bearing_button.
function bearing_button_Callback(hObject, eventdata, handles)
% hObject    handle to bearing_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('bearing_section')
close('main_menu')

function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

cwa_main_flag = 0;

try
cwa_main_flag = evalin('base','cwa_main_flag');
end

if cwa_main_flag == 1
    ch_flag = questdlg('Exit? (you will lose all data)','Warning','Yes','No','No');
    % Handle response
    switch close_flag
        case 'Yes'
            close_flag = 1;
            delete(hObject);
        case 'No'
            close_flag = 0;
    end
else
    cwa_main_flag = 0; assignin('base','cwa_main_flag',cwa_main_flag)
    delete(hObject);
end


% --- Executes on button press in gen_signal.
function gen_signal_Callback(hObject, eventdata, handles)
% hObject    handle to gen_signal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% must check whether bearing or gear sections are present
speed_profile = evalin('base','speed_profile');

try
    main_table_bearing_data = evalin('base','main_table_bearing_data');
    main_table_bearing_mask = evalin('base','main_table_bearing_mask');
catch
    main_table_bearing_data = [];
    main_table_bearing_mask = [];
end

try
    main_table_ord_data = evalin('base','main_table_ord_data');
    main_table_ord_mask = evalin('base','main_table_ord_mask');
catch
    main_table_ord_data = [];
    main_table_ord_mask = [];
end

try
    noise_mean = evalin('base','noise_mean');
    noise_variance = evalin('base','noise_variance');
    noise_damping = evalin('base','noise_damping');
    noise_nat_freq = evalin('base','noise_nat_freq');
catch
    noise_mean = 0;
    noise_variance = 0;
    noise_damping = 0;
    noise_nat_freq = 0;
end
[simulatedSignal,t,fr] = funSignalGenerator(speed_profile,main_table_bearing_data,main_table_bearing_mask,main_table_ord_data,main_table_ord_mask,noise_mean,noise_variance,noise_nat_freq,noise_damping);
assignin('base','simulatedSignal',simulatedSignal)
assignin('base','t',t)
assignin('base','fr',fr)
