function varargout = user_defined_speed_profile(varargin)
% USER_DEFINED_SPEED_PROFILE MATLAB code for user_defined_speed_profile.fig
%      USER_DEFINED_SPEED_PROFILE, by itself, creates a new USER_DEFINED_SPEED_PROFILE or raises the existing
%      singleton*.
%
%      H = USER_DEFINED_SPEED_PROFILE returns the handle to a new USER_DEFINED_SPEED_PROFILE or the handle to
%      the existing singleton*.
%
%      USER_DEFINED_SPEED_PROFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in USER_DEFINED_SPEED_PROFILE.M with the given input arguments.
%
%      USER_DEFINED_SPEED_PROFILE('Property','Value',...) creates a new USER_DEFINED_SPEED_PROFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before user_defined_speed_profile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to user_defined_speed_profile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help user_defined_speed_profile

% Last Modified by GUIDE v2.5 27-Jun-2018 14:44:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @user_defined_speed_profile_OpeningFcn, ...
                   'gui_OutputFcn',  @user_defined_speed_profile_OutputFcn, ...
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


% --- Executes just before user_defined_speed_profile is made visible.
function user_defined_speed_profile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to user_defined_speed_profile (see VARARGIN)

% Choose default command line output for user_defined_speed_profile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% set visibility
set(handles.save_return_menu,'enable','off') 
set(handles.plot_check_button,'enable','on') 

% check if there is another speed profile in the ws
try
    speed_profile = evalin('base','speed_profile');
    fr = speed_profile.fr; assignin('base','fr',fr)
    fs = speed_profile.fs; assignin('base','fs',fs)
    M = speed_profile.M; assignin('base','M',M)
    theta = speed_profile.theta; assignin('base','theta',theta)
    set(handles.samplesXrevolution, 'String', num2str(M));
    set(handles.fs, 'String', num2str(fs));
    plot(theta,fr,'k');
    xlabel('angle (rad)')
    ylabel('rotational frequency (Hz)')
    set(gca,'fontsize',8)
    box off
    set(handles.pushbutton4,'enable','on')
    set(handles.save_return_menu,'enable','off') 
    set(handles.plot_check_button,'enable','on')
catch
    % default values
    M = 5000;
    fs = 10000;
    assignin('base','M',M)
    assignin('base','fs',fs)
    set(handles.samplesXrevolution, 'String', num2str(M));
    set(handles.fs, 'String', num2str(fs));
    set(handles.pushbutton4,'enable','on')
    set(handles.save_return_menu,'enable','off') 
    set(handles.plot_check_button,'enable','on')
end


% UIWAIT makes user_defined_speed_profile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = user_defined_speed_profile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function samplesXrevolution_Callback(hObject, eventdata, handles)
% hObject    handle to samplesXrevolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of samplesXrevolution as text
%        str2double(get(hObject,'String')) returns contents of samplesXrevolution as a double
M = evalin('base','M'); M = str2double(M);
% fs = evalin('base','fs'); fs = str2double(fs);

M = get(handles.samplesXrevolution,'String');
M = str2double(M);

if not(isreal(M) && rem(M,1)==0)
    warndlg('Please, insert an integer number of samples', 'Warning')
    M = evalin('base','M');
    set(handles.samplesXrevolution, 'String', M);
    return
elseif M < 0
    warndlg('Please, insert a positive number of samples', 'Warning')
    M = evalin('base','M');
    set(handles.samplesXrevolution, 'String', M);
    return    
else
    assignin('base','M',M)
end
set(handles.save_return_menu,'enable','off') 
set(handles.plot_check_button,'enable','on') 

% --- Executes during object creation, after setting all properties.
function samplesXrevolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplesXrevolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fs_Callback(hObject, eventdata, handles)
% hObject    handle to fs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fs as text
%        str2double(get(hObject,'String')) returns contents of fs as a double
fs = evalin('base','fs'); fs = str2double(fs);

fs = get(handles.fs,'String');
fs = str2double(fs);

if not(isreal(fs) && rem(fs,1)==0)
    warndlg('Please, insert an integer sampling frequency', 'Warning')
    fs = evalin('base','fs');
    set(handles.fs, 'String', fs);
    return
elseif fs < 0
    warndlg('Please, insert a positive sampling frequency', 'Warning')
    fs = evalin('base','fs');
    set(handles.fs, 'String', fs);
    return    
else
    assignin('base','fs',fs)
end
set(handles.save_return_menu,'enable','off')
set(handles.plot_check_button,'enable','on') 

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

% --- Executes on button press in plot_check_button.
function plot_check_button_Callback(hObject, eventdata, handles)
% hObject    handle to plot_check_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    fr = evalin('base','fr');
catch
    warndlg('Please, load a speed profile', 'Warning')
    return
end

M = evalin('base','M');
L = length(fr);
Nlap = floor(L/M);
if Nlap < 1
    warndlg('You must consider at least one revolution', 'Warning')
    return
end
theta = (0:L-1)*2*pi*Nlap/L; assignin('base','theta',theta);
L = length(theta);
fr = fr(1:L);
plot(theta,fr,'k');
xlabel('angle (rad)')
ylabel('rotational frequency (Hz)')
set(gca,'fontsize',8)
box off
set(handles.save_return_menu,'enable','on')
set(handles.plot_check_button,'enable','off') 

% --- Executes on button press in save_return_menu.
function save_return_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_return_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fr = evalin('base','fr');
theta = evalin('base','theta');
M = evalin('base','M');
fs = evalin('base','fs');
speed_profile.fr = fr;
speed_profile.theta = theta;
speed_profile.M = M;
speed_profile.fs = fs;
assignin('base','speed_profile',speed_profile)
evalin('base','clear fr M theta fs')
run('main_menu')
close('user_defined_speed_profile')

% --- Executes on button press in file_explorer_button.
function file_explorer_button_Callback(hObject, eventdata, handles)
% hObject    handle to file_explorer_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FILENAME, PATHNAME] = uigetfile();
set(handles.save_return_menu,'enable','off')
set(handles.plot_check_button,'enable','on') 
try
    fr = load([PATHNAME FILENAME]);
    name = fieldnames(fr);
    fr = fr.(name{1});
    fr = fr(:); % col. vector
    if size(fr,2) > 1
        warndlg('Input data must be a vector', 'Warning')
        return
    end
    assignin('base','fr',fr)
    set(handles.pushbutton4,'enable','off')
catch
    warndlg('Invalid format', 'Warning')
end

if not(isreal(fr))
    warndlg('Input vector must be real', 'Warning')
end

msgbox('File loaded successfully')



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('main_menu')
close('user_defined_speed_profile')
