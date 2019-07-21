function varargout = Kinect(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


function untitled_OpeningFcn(hObject, ~, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = untitled_OutputFcn(~, ~, handles) 
varargout{1} = handles.output;
global Kinect_Depth;
global Kinect_RGB;
Kinect_Depth = videoinput('kinect', 2, 'Depth_640x480');
Kinect_RGB = videoinput('kinect', 1, 'RGB_640x480');

function pushbutton1_Callback(~, ~, ~) % Button1 = Preview

axes(findobj(gcf,'Tag','axes1'));
global Kinect_RGB;
Kinect_RGB_Res = Kinect_RGB.VideoResolution;
Kinect_RGB_nBands = Kinect_RGB.NumberOfBands;
Kinect_RGB_hImage = image( zeros(Kinect_RGB_Res(2), Kinect_RGB_Res(1), Kinect_RGB_nBands) );
preview(Kinect_RGB, Kinect_RGB_hImage);

axes(findobj(gcf,'Tag','axes2'));
global Kinect_Depth;
Kinect_Depth_Res = Kinect_Depth.VideoResolution;
Kinect_Depth_nBands = Kinect_Depth.NumberOfBands;
Kinect_Depth_hImage = image( zeros(Kinect_Depth_Res(2), Kinect_Depth_Res(1), Kinect_Depth_nBands) );
preview(Kinect_Depth, Kinect_Depth_hImage);



function pushbutton2_Callback(~, ~, ~) % Button2 = Start

if exist('image','dir')~=  7
    mkdir([cd,'/image']) % 与下一句一样
end
directory=[cd,'/image/']; %当前工作目录下文件夹

axes(findobj(gcf,'Tag','axes1'));
global Kinect_RGB;
RGB =getsnapshot(Kinect_RGB);
image_shot(1, 1, directory, Kinect_RGB);

axes(findobj(gcf,'Tag','axes2'));
global Kinect_Depth;
Kinect =getsnapshot(Kinect_Depth);
image_shot(1, 0, directory, Kinect_Depth);



function pushbutton3_Callback(~, ~, ~) % Button3 = Stop

if exist('image','dir')~=  7
    mkdir([cd,'/image']) % 与下一句一样
end
directory=[cd,'/image/']; %当前工作目录下文件夹

axes(findobj(gcf,'Tag','axes1'));
global Kinect_RGB;
image_shot(0, 1, directory, Kinect_RGB);
axes(findobj(gcf,'Tag','axes2'));
global Kinect_Depth;
image_shot(0, 0, directory, Kinect_Depth);



function image_shot(is_shot, RGB, directory, obj) % function to get picture according to RGB or depth
persistent i
if isempty(i)%判断数组为不为空
   i = 1; 
end



if is_shot
    if RGB
        %date_string = datestr(now,13)
        RGB_str = sprintf('frame-%06d.color',i);
        RGB_filename=[RGB_str];
        RGB_frame = getsnapshot(obj);%抓图
        imwrite(RGB_frame,[directory,RGB_filename,'.jpg']);%存图'
        i=i+1;
    else
        %date_string = datestr(now,13)
        depth_str = sprintf('frame-%06d.depth',i-1);
        depth_filename=[depth_str];
        depth_frame = getsnapshot(obj);%抓图
        imwrite(depth_frame,[directory,depth_filename,'.png']);%存图'
        i=i+1;
    end
else
    clear i;%清除局部变量
    delete(obj);%关闭摄像头
end


