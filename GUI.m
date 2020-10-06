function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 07-Jun-2019 17:29:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
global number
number=0;
% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.text2,'Visible', 'Off');


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net;
global ImagePath;
global number;
global ImageName;
number = number+1;
set(handles.text2,'Visible', 'On');
I = imread(ImagePath{number,1});
imshow(I);
% Run the detector.
pause(0.001);
scores=0;
[bboxes,scores,labels] = detect(net,I);
if scores~=0
    set(handles.text2,'Visible', 'Off');
    I = insertObjectAnnotation(I,'rectangle',bboxes,cellstr(labels));
    imshow(I);
    title(ImageName{number,1},'Interpreter', 'none','FontSize',16,'fontname','Helvetica');
else
    set(handles.text2,'Visible', 'Off');
    imshow(I);
    title('Failed','Interpreter', 'none','FontSize',16,'fontname','Helvetica');
end


% --- Executes on key press with focus on pushbutton1 and none of its controls.
function pushbutton1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selpath;
selpath = uigetdir
global ImagePath;
global ImageName;
foldername=dir(selpath)% 用於得出所有子文件的名字
lengthf = length(foldername)-2;
for i=1:lengthf
    filename=strcat(selpath,'/',foldername(i+2).name);
    imagename{i,1}=foldername(i+2).name;
    imagepath{i,1}=filename;
end
ImagePath = imagepath;
ImageName = imagename;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global net;
global ImagePath;
global number;
global ImageName;
number = number-1;
set(handles.text2,'Visible', 'On');
I = imread(ImagePath{number,1});
imshow(I);
% Run the detector.
pause(0.001);
scores=0;
[bboxes,scores,labels] = detect(net,I);
if scores~=0
    set(handles.text2,'Visible', 'Off');
    I = insertObjectAnnotation(I,'rectangle',bboxes,cellstr(labels));
    imshow(I);
    title(ImageName{number,1},'Interpreter', 'none','FontSize',16,'fontname','Helvetica');
else
    set(handles.text2,'Visible', 'Off');
    imshow(I);
    title('Failed','Interpreter', 'none','FontSize',16,'fontname','Helvetica');
end
