function varargout = main_speed_profile(varargin)
% MAIN_SPEED_PROFILE MATLAB code for main_speed_profile.fig
%      MAIN_SPEED_PROFILE, by itself, creates a new MAIN_SPEED_PROFILE or raises the existing
%      singleton*.
%
%      H = MAIN_SPEED_PROFILE returns the handle to a new MAIN_SPEED_PROFILE or the handle to
%      the existing singleton*.
%
%      MAIN_SPEED_PROFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN_SPEED_PROFILE.M with the given input arguments.
%
%      MAIN_SPEED_PROFILE('Property','Value',...) creates a new MAIN_SPEED_PROFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before main_speed_profile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_speed_profile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main_speed_profile

% Last Modified by GUIDE v2.5 27-Feb-2018 11:23:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_speed_profile_OpeningFcn, ...
                   'gui_OutputFcn',  @main_speed_profile_OutputFcn, ...
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


% --- Executes just before main_speed_profile is made visible.
function main_speed_profile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main_speed_profile (see VARARGIN)

% Choose default command line output for main_speed_profile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes main_speed_profile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = main_speed_profile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in import.
function import_Callback(hObject, eventdata, handles)
% hObject    handle to import (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('user_defined_speed_profile')
close('main_speed_profile')

% --- Executes on button press in standard.
function standard_Callback(hObject, eventdata, handles)
% hObject    handle to standard (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
run('standard_speed_profile')
close('main_speed_profile')
