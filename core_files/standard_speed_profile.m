function varargout = standard_speed_profile(varargin)
%STANDARD_SPEED_PROFILE MATLAB code file for standard_speed_profile.fig
%      STANDARD_SPEED_PROFILE, by itself, creates a new STANDARD_SPEED_PROFILE or raises the existing
%      singleton*.
%
%      H = STANDARD_SPEED_PROFILE returns the handle to a new STANDARD_SPEED_PROFILE or the handle to
%      the existing singleton*.
%
%      STANDARD_SPEED_PROFILE('Property','Value',...) creates a new STANDARD_SPEED_PROFILE using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to standard_speed_profile_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      STANDARD_SPEED_PROFILE('CALLBACK') and STANDARD_SPEED_PROFILE('CALLBACK',hObject,...) call the
%      local function named CALLBACK in STANDARD_SPEED_PROFILE.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help standard_speed_profile

% Last Modified by GUIDE v2.5 24-Jul-2018 13:24:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @standard_speed_profile_OpeningFcn, ...
                   'gui_OutputFcn',  @standard_speed_profile_OutputFcn, ...
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


% --- Executes just before standard_speed_profile is made visible.
function standard_speed_profile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for standard_speed_profile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

try
    % find speed profile data in ws
    speed_profile = evalin('base','speed_profile');
    fr = speed_profile.fr1; assignin('base','fr',fr);
    fs = speed_profile.fs; assignin('base','fs',fs);
    fc1 = speed_profile.fc1; assignin('base','fc1',fc1);
    fc2 = speed_profile.fc2; assignin('base','fc2',fc2);
    fd = speed_profile.fd; assignin('base','fd',fd);
    fm = speed_profile.fm; assignin('base','fm',fm);
    M = speed_profile.M; assignin('base','M',M);
    theta = speed_profile.theta; assignin('base','theta',theta);
    ind = theta >= 0 & theta <= 2*pi;
    set(handles.fs, 'String', num2str(fs));
    set(handles.pointsXrev, 'String', num2str(M));
    set(handles.Nrevolutions, 'String', num2str(length(fr)/M));
    set(handles.fc1, 'String', num2str(fc));
    set(handles.fm, 'String', num2str(fm));
    set(handles.fd, 'String', num2str(fd));
    plot(theta(ind),fr(ind),'k');
    xlabel('angle (rad)')
    ylabel('rotational frequency (Hz)')
    set(gca,'fontsize',8)
    box off
catch
    % set standard values
    set(handles.fs, 'String', '10000');
    set(handles.pointsXrev, 'String', '5000');
    set(handles.Nrevolutions, 'String', '1');
    set(handles.fc1, 'String', '20');
    set(handles.fc2, 'String', '20');
    set(handles.fd, 'String', '1');
    set(handles.fm, 'String', '1');
end

% Set visibility
set(handles.save_button,'enable','off') 
set(handles.return_main_menu_button,'enable','off')
% UIWAIT makes standard_speed_profile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = standard_speed_profile_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function pointsXrev_Callback(hObject, eventdata, handles)
% hObject    handle to pointsXrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pointsXrev as text
%        str2double(get(hObject,'String')) returns contents of pointsXrev as a double
set(handles.save_button,'enable','off')
set(handles.check_plot_button,'enable','on')
set(handles.return_main_menu_button,'enable','off') 

% --- Executes during object creation, after setting all properties.
function pointsXrev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pointsXrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Nrevolutions_Callback(hObject, eventdata, handles)
% hObject    handle to Nrevolutions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nrevolutions as text
%        str2double(get(hObject,'String')) returns contents of Nrevolutions as a double
set(handles.save_button,'enable','off');
set(handles.check_plot_button,'enable','on');
set(handles.return_main_menu_button,'enable','off');

% --- Executes during object creation, after setting all properties.
function Nrevolutions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nrevolutions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fc1_Callback(hObject, eventdata, handles)
% hObject    handle to fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fc1 as text
%        str2double(get(hObject,'String')) returns contents of fc1 as a double
set(handles.save_button,'enable','off');
set(handles.check_plot_button,'enable','on');
set(handles.return_main_menu_button,'enable','off');

% --- Executes during object creation, after setting all properties.
function fc1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fd_Callback(hObject, eventdata, handles)
% hObject    handle to fd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fd as text
%        str2double(get(hObject,'String')) returns contents of fd as a double
set(handles.save_button,'enable','off');
set(handles.check_plot_button,'enable','on');
set(handles.return_main_menu_button,'enable','off'); 

% --- Executes during object creation, after setting all properties.
function fd_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fm_Callback(hObject, eventdata, handles)
% hObject    handle to fm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fm as text
%        str2double(get(hObject,'String')) returns contents of fm as a double
set(handles.save_button,'enable','off');
set(handles.check_plot_button,'enable','on');
set(handles.return_main_menu_button,'enable','off');

% --- Executes during object creation, after setting all properties.
function fm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in check_plot_button.
function check_plot_button_Callback(hObject, eventdata, handles)
% hObject    handle to check_plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

M = str2double(get(handles.pointsXrev,'String'));
Nrevolutions = str2double(get(handles.Nrevolutions,'String'));
fc1 = str2double(get(handles.fc1,'String'));
fc2 = str2double(get(handles.fc2,'String'));
fm = str2double(get(handles.fm,'String'));
L = Nrevolutions*M;
fd = str2double(get(handles.fd,'String'));
fs = str2double(get(handles.fs,'String'));
theta = (0:L-1)*Nrevolutions*2*pi/L; assignin('base','theta',theta);
fc = (theta./theta(end)) .*(fc2 - fc1) + fc1;
fr = fc + fd.*cos(fm.*theta);

if M < fs/((min(fc-fd)))
    warndlg('Increse Fs or Samples per revolution','Warning')
else
    set(handles.save_button,'enable','on')
    set(handles.check_plot_button,'enable','off')
    assignin('base','M',M);
    assignin('base','Nrevolutions',Nrevolutions);
    assignin('base','fc',fc);
    assignin('base','fc1',fc1);
    assignin('base','fc2',fc2);
    assignin('base','fd',fd);
    assignin('base','fm',fm);
    assignin('base','fs',fs);
    assignin('base','L',L);
    plot(theta,fr,'k') %, xlim([0 2*pi])
    xlabel('angle (rad)')
    ylabel('rotational frequency (Hz)')
    set(gca,'fontsize',8)
    box off
end

% --- Executes on button press in save_button.
function save_button_Callback(hObject, eventdata, handles)
% hObject    handle to save_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.return_main_menu_button,'enable','on');
M = str2double(get(handles.pointsXrev,'String'));
Nrevolutions = str2double(get(handles.Nrevolutions,'String'));
fc1 = str2double(get(handles.fc1,'String'));
fc2 = str2double(get(handles.fc2,'String'));
fm = str2double(get(handles.fm,'String'));
L = Nrevolutions*M;
fd = str2double(get(handles.fd,'String'));
fs = str2double(get(handles.fs,'String'));
theta = (0:L-1)*Nrevolutions*2*pi/L; assignin('base','theta',theta);
fc = (theta./theta(end)) .*(fc2 - fc1) + fc1;
fr = fc + fd.*cos(fm.*theta);

set(handles.return_main_menu_button,'enable','on')
evalin('base','M');
evalin('base','Nrevolutions;');
evalin('base','fc1;');
evalin('base','fc2;');
evalin('base','fd;');
evalin('base','fm;');
evalin('base','fs;');
evalin('base','L;');
speed_profile.fr = fr;
speed_profile.theta = theta;
speed_profile.M = M;
speed_profile.fs = fs;
speed_profile.fc1 = fc1;
speed_profile.fc2 = fc2;
speed_profile.fd = fd;
speed_profile.fm = fm;
speed_profile.L = L;
assignin('base','speed_profile',speed_profile);
evalin('base','clear fr M theta fs fc fc1 fc2 fd fm L Nrevolutions');
eval('clc');
% evalin('base','clear fr M theta fs fc1 fd fm L Nrevolutions')
set(handles.save_button,'enable','off')

function fs_Callback(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs as text
%        str2double(get(hObject,'String')) returns contents of fs as a double
fs = str2double(get(handles.fs,'String'));
set(handles.save_button,'enable','off');
set(handles.check_plot_button,'enable','on');
set(handles.return_main_menu_button,'enable','off');

% --- Executes during object creation, after setting all properties.
function fs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in return_main_menu_button.
function return_main_menu_button_Callback(hObject, eventdata, handles)
% hObject    handle to return_main_menu_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('main_menu')
close('standard_speed_profile')



function fc2_Callback(hObject, eventdata, handles)
% hObject    handle to fc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fc2 as text
%        str2double(get(hObject,'String')) returns contents of fc2 as a double
set(handles.save_button,'enable','off');
set(handles.check_plot_button,'enable','on');
set(handles.return_main_menu_button,'enable','off');


% --- Executes during object creation, after setting all properties.
function fc2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
