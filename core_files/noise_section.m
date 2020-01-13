function varargout = noise_section(varargin)
% NOISE_SECTION MATLAB code for noise_section.fig
%      NOISE_SECTION, by itself, creates a new NOISE_SECTION or raises the existing
%      singleton*.
%
%      H = NOISE_SECTION returns the handle to a new NOISE_SECTION or the handle to
%      the existing singleton*.
%
%      NOISE_SECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NOISE_SECTION.M with the given input arguments.
%
%      NOISE_SECTION('Property','Value',...) creates a new NOISE_SECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before noise_section_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to noise_section_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help noise_section

% Last Modified by GUIDE v2.5 07-Aug-2018 11:09:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @noise_section_OpeningFcn, ...
                   'gui_OutputFcn',  @noise_section_OutputFcn, ...
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


% --- Executes just before noise_section is made visible.
function noise_section_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to noise_section (see VARARGIN)

% Choose default command line output for noise_section
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% check if there is another speed profile in the ws
try
    rng('default')
    fs = evalin('base','speed_profile'); fs = fs.fs;
    noise_mean = evalin('base','noise_mean');
    noise_variance = evalin('base','noise_variance');
    noise_nat_freq = evalin('base','noise_nat_freq');
    noise_damping = evalin('base','noise_damping');
    set(handles.noise_mean, 'String', num2str(noise_mean))
    set(handles.noise_variance, 'String', num2str(noise_variance))
    set(handles.nat_freq, 'String', num2str(noise_nat_freq))
    set(handles.damp, 'String', num2str(noise_damping))
    
    noise = sqrt(noise_variance).*randn(1,fs) + noise_mean;
    h = mySdofResponse(fs,noise_damping/100,noise_nat_freq,2^9);
    
    if sum(h) > 0
        noise = fftfilt(h,noise);
    end
    
    axes(handles.axes1)
    plot((0:length(noise)-1)/fs,noise,'k');
    xlabel('time (s)')
    set(gca,'fontsize',8)
    box off
    
    axes(handles.axes2)
    plot((0:2^9-1)*fs/2^9,db(2.*abs(fft(h))),'k');
    xlim([0 fs/2])
    xlabel('freq. (Hz)')
    ylabel('(dB)')
    set(gca,'fontsize',8)
    box off

    set(handles.back,'enable','on')
    set(handles.save_return_menu,'enable','off')
    set(handles.plot_check_button,'enable','off')
catch
    % default values
    noise_mean = 0;
    noise_variance = 1;
    noise_nat_freq = 0;
    noise_damping = 0;
    set(handles.noise_mean, 'String', num2str(noise_mean))
    set(handles.noise_variance, 'String', num2str(noise_variance))
    set(handles.nat_freq, 'String', num2str(noise_nat_freq))
    set(handles.damp, 'String', num2str(noise_damping))
end


% UIWAIT makes noise_section wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = noise_section_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function noise_mean_Callback(hObject, eventdata, handles)
% hObject    handle to noise_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_mean as text
%        str2double(get(hObject,'String')) returns contents of noise_mean as a double
set(handles.back,'enable','on')
set(handles.save_return_menu,'enable','off')
set(handles.plot_check_button,'enable','on')
% noise_mean_temp = str2double(get(handles.noise_mean,'String'));
% assignin('base','noise_mean_temp',noise_mean_temp);


% --- Executes during object creation, after setting all properties.
function noise_mean_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_mean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noise_variance_Callback(hObject, eventdata, handles)
% hObject    handle to noise_variance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noise_variance as text
%        str2double(get(hObject,'String')) returns contents of noise_variance as a double
set(handles.back,'enable','on')
set(handles.save_return_menu,'enable','off')
set(handles.plot_check_button,'enable','on')
% get(handles.noise_variance,'enable','off');
% noise_variance_temp = str2double(get(handles.noise_variance,'String'));
% assignin('base','noise_variance_temp',noise_variance_temp);

% --- Executes during object creation, after setting all properties.
function noise_variance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noise_variance (see GCBO)
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
fs = evalin('base','speed_profile');
fs = fs.fs;
noise_mean_temp = str2double(get(handles.noise_mean,'String'));
noise_variance_temp = str2double(get(handles.noise_variance,'String'));
noise_nat_freq_temp = str2double(get(handles.nat_freq,'String'));
noise_damping_temp = str2double(get(handles.damp,'String'));

noise = sqrt(noise_variance_temp).*randn(1,fs) + noise_mean_temp;
h = mySdofResponse(fs,noise_damping_temp/100,noise_nat_freq_temp,2^9);

if sum(h) > 0
    noise = fftfilt(h,noise);
end

rng('default')
axes(handles.axes1)
plot((0:length(noise)-1)/fs,noise,'k');
xlabel('time (s)')
set(gca,'fontsize',8)
box off

axes(handles.axes2)
plot((0:2^9-1)*fs/2^9,db(2.*abs(fft(h))),'k');
xlim([0 fs/2])
xlabel('freq. (Hz)')
ylabel('(dB)')
set(gca,'fontsize',8)
box off

set(handles.back,'enable','on')
set(handles.save_return_menu,'enable','on')
set(handles.plot_check_button,'enable','off')

% --- Executes on button press in save_return_menu.
function save_return_menu_Callback(hObject, eventdata, handles)
% hObject    handle to save_return_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
noise_mean = str2double(get(handles.noise_mean,'String'));
noise_variance = str2double(get(handles.noise_variance,'String'));
noise_nat_freq = str2double(get(handles.nat_freq,'String'));
noise_damping = str2double(get(handles.damp,'String'));

assignin('base','noise_mean',noise_mean)
assignin('base','noise_variance',noise_variance)
assignin('base','noise_nat_freq',noise_nat_freq)
assignin('base','noise_damping',noise_damping)
run('main_menu')
close('noise_section')

% --- Executes on button press in back.
function back_Callback(hObject, eventdata, handles)
% hObject    handle to back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('main_menu')
close('noise_section')

function nat_freq_Callback(hObject, eventdata, handles)
% hObject    handle to nat_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nat_freq as text
%        str2double(get(hObject,'String')) returns contents of nat_freq as a double
set(handles.back,'enable','on')
set(handles.save_return_menu,'enable','off')
set(handles.plot_check_button,'enable','on')

% --- Executes during object creation, after setting all properties.
function nat_freq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nat_freq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function damp_Callback(hObject, eventdata, handles)
% hObject    handle to damp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of damp as text
%        str2double(get(hObject,'String')) returns contents of damp as a double
set(handles.back,'enable','on')
set(handles.save_return_menu,'enable','off')
set(handles.plot_check_button,'enable','on')

% --- Executes during object creation, after setting all properties.
function damp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to damp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
