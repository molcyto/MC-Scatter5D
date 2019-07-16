function varargout = scatter5d(varargin)
% Script developed and implemented by Marten Postma 2015, part of the
% Nature Protocol Bindels et al. publication

% SCATTER5D M-file for scatter5d.fig
%      SCATTER5D, by itself, creates a new SCATTER5D or raises the existing
%      singleton*.
%
%      H = SCATTER5D returns the handle to a new SCATTER5D or the handle to
%      the existing singleton*.
%
%      SCATTER5D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SCATTER5D.M with the given input arguments.
%
%      SCATTER5D('Property','Value',...) creates a new SCATTER5D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before scatter5d_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to scatter5d_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help scatter5d

% Last Modified by GUIDE v2.5 19-May-2019 15:20:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @scatter5d_OpeningFcn, ...
                   'gui_OutputFcn',  @scatter5d_OutputFcn, ...
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


% --- Executes just before scatter5d is made visible.
function scatter5d_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to scatter5d (see VARARGIN)

% Choose default command line output for scatter5d
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes scatter5d wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(0,'defaultTextFontSize', 20)


set(handles.output, 'doublebuffer', 'on');

strs = {'Show Plot Tools and Dock Figure', 'Hide Plot Tools', 'Print Figure' ...
        'Save Figure', 'Open File', 'New Figure', 'Insert Legend', 'Edit Plot' ...
        'Insert Colorbar', 'Link Plot', 'Data Cursor', 'Brush/Select Data'};
setToolbarButtons(handles, strs, 'off');

function setToolbarButtons(handles, strs, state)
h = findall(handles.output);
N = length(strs);
for n=1:N
    h2 = findall(h, 'ToolTipString', strs{n});
    set(h2, 'visible', state);
end

% --- Outputs from this function are returned to the command line.
function varargout = scatter5d_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles)
% hObject    handle to load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in loadButton.

if isappdata(handles.output, 'pathName')
    pathName = getappdata(handles.output, 'pathName');
else
    pathName = '.';
end;

[fileName, pathName, filterindex] = uigetfile(fullfile(pathName,'*.*'), 'pick data file');
if ~isempty(fileName)
    fullFile = fullfile(pathName,fileName); 
    setappdata(handles.output, 'pathName', pathName);
    setappdata(handles.output, 'pathName', fullFile);
    [pathName, Name, ext] = fileparts(fileName);    
    setappdata(handles.output, 'firstLoad', 1);
    switch ext    
        case {'.xls','.xlsx'}
            loadData(fullFile, handles);    
        case '.mat'
            loadSession(fullFile, handles);                                
    end;
end;

function loadSession(fileName, handles)

d = load(fileName);
session = d.session;
set(handles.filetxt, 'string', fileName);

set(handles.xpop,'string', session.dataLabels);
set(handles.ypop,'string', session.dataLabels);
set(handles.zpop,'string', session.dataLabels);
set(handles.cpop,'string', session.dataLabels);
set(handles.datapop,'string', session.labels, 'value',session.selection);

set(handles.xpop,'value', session.xpop); 
set(handles.ypop,'value', session.ypop);  
set(handles.zpop,'value', session.zpop);  
set(handles.cpop,'value', session.cpop);
slabels = cat(1,session.dataLabels, {'none'});
set(handles.spop,'value', session.spop);
set(handles.spop,'string', slabels);
set(handles.colormap,'value', session.mappop);
set(handles.linescheck,'value', session.linesCheck);
set(handles.labelscheck,'value', session.labelsCheck);

setappdata(handles.output, 'session', session);

setLimits(handles, 'x');
setLimits(handles, 'y');
setLimits(handles, 'z');
setLimits(handles, 'c');
setLimits(handles, 's');

setXData(handles);
setYData(handles);
setZData(handles);
setCData(handles);
setSData(handles);

setXLabel(handles);
setYLabel(handles);
setZLabel(handles);
setCLabel(handles);

setColors(handles);
setShapes(handles);
setSelection(handles);

setMenuListbox(handles);

setupDataGraph(handles);

function setLimits(handles, chn)
session = getappdata(handles.output, 'session');
switch lower(chn)
    case 'x'
        set(handles.xmin,'string',num2str(session.limits(session.xpop,1)));
        set(handles.xmax,'string',num2str(session.limits(session.xpop,2)));
    case 'y'
        set(handles.ymin,'string',num2str(session.limits(session.ypop,1)));
        set(handles.ymax,'string',num2str(session.limits(session.ypop,2)));
    case 'z'
        set(handles.zmin,'string',num2str(session.limits(session.zpop,1)));
        set(handles.zmax,'string',num2str(session.limits(session.zpop,2)));
    case 'c'
        set(handles.cmin,'string',num2str(session.limits(session.cpop,1)));
        set(handles.cmax,'string',num2str(session.limits(session.cpop,2)));
    case 's'
        set(handles.smin,'string',num2str(session.limits(session.spop,1)));
        set(handles.smax,'string',num2str(session.limits(session.spop,2)));        
end;

function lim = getLimits(handles, chn)
session = getappdata(handles.output, 'session');
switch lower(chn)
    case 'x'
        lim = session.limits(session.xpop,:);
    case 'y'
        lim = session.limits(session.ypop,:);
    case 'z'
        lim = session.limits(session.zpop,:);
    case 'c'
        lim = session.limits(session.cpop,:);
    case 's'
        lim = session.limits(session.spop,:);        
end;


function setAxisLimits(handles, chn)
session = getappdata(handles.output, 'session');
lim = session.limits;

switch lower(chn)
    case 'x'
        set(handles.axes1, 'xlim', lim(session.xpop,:));
    case 'y'
        set(handles.axes1, 'ylim', lim(session.ypop,:));
    case 'z'
        set(handles.axes1, 'zlim', lim(session.zpop,:));
    case 'c'
        setColors(handles);
        updateColors(handles);
        plotColorScale(handles, handles.axes2);
    case 's'
        setShapes(handles);        
end;


function loadData(fileName, handles)
% this function loads raw data from an excel file, where the sheet with the
% data should be called 'data'
% the first column contains the well names

[data, txt] = xlsread(fileName, 'data');
dataLabels = txt(1,3:end);
wells = txt(2:end,1);
labels = txt(2:end,2); 
N = size(data,1);

session = struct;
session.data = data;
session.wells = wells;
session.dataLabels = dataLabels';
session.labels = labels;
session.markers = repmat(1,N,1);
session.flatColors = repmat(1,N,1);
session.labelVisible = repmat({'on'},N,1);
session.linesVisible = repmat({'off'},N,1);
session.selection = (1:N)';
session.labelsCheck = get(handles.labelscheck, 'value');
session.linesCheck = get(handles.linescheck, 'value');

session.limits = [min(data); max(data)]';

set(handles.filetxt, 'string', fileName);

set(handles.xpop,'string', session.dataLabels);
set(handles.ypop,'string', session.dataLabels);
set(handles.zpop,'string', session.dataLabels);
set(handles.cpop,'string', session.dataLabels);
slabels = cat(1,session.dataLabels, {'none'});
set(handles.spop,'string', slabels);
set(handles.datapop,'string', session.labels, 'value',session.selection);

set(handles.xpop,'value', 1); session.xpop = 1;
set(handles.ypop,'value', 2); session.ypop = 2;
set(handles.zpop,'value', 3); session.zpop = 3;
set(handles.cpop,'value', 4); session.cpop = 4;
set(handles.spop,'value', 5); session.spop = 5;

session.AZEL = get(handles.axes1,'view');

setappdata(handles.output, 'session', session);

setXData(handles);
setYData(handles);
setZData(handles);
setCData(handles);
setSData(handles);

setXLabel(handles);
setYLabel(handles);
setZLabel(handles);
setCLabel(handles);

setColors(handles);
setShapes(handles);
setSelection(handles);

setLimits(handles, 'x');
setLimits(handles, 'y');
setLimits(handles, 'z');
setLimits(handles, 'c');
setLimits(handles, 's');

setMenuListbox(handles);
setupDataGraph(handles);


function setupDataGraph(handles)
% this function sets up the graph 

session = getappdata(handles.output, 'session');

axes(handles.axes1);
delete(get(handles.axes1,'children'));
hold on;

firstSessionLoad = getappdata(handles.output, 'firstLoad');
if ~firstSessionLoad
    session.AZEL = get(handles.axes1,'view');
end

X = getXData(handles);
Y = getYData(handles);
Z = getZData(handles);
cols = getColors(handles);
sel = getSelection(handles);

lh = plotLines(handles);

N = length(X);

phScatter = scatter3(X(1), Y(1), Z(1), 40, cols(1,:), 'filled');
set(phScatter, 'Marker', getMarkerSymbol(session.markers(1)), 'visible', isSelected(sel, 1));
setMenu(handles, phScatter, 1);
set(handles.axes1,'view', session.AZEL);
for n=2:N
    phScatter(n) = scatter3(X(n), Y(n), Z(n), 40, cols(n,:),'filled');
    set(phScatter(n), 'Marker', getMarkerSymbol(session.markers(n)), 'visible', isSelected(sel, n));
    setMenu(handles, phScatter(n), n);
end
hold off;
box on;
handles.axes1.BoxStyle = 'full';
grid on;
setappdata(handles.output, 'phScatter', phScatter);

xlabel(getXLabel(handles));
ylabel(getYLabel(handles));
zlabel(getZLabel(handles));

plotColorScale(handles, handles.axes2);

setAxisLimits(handles, 'x');
setAxisLimits(handles, 'y');
setAxisLimits(handles, 'z');
setAxisLimits(handles, 'c');

plotLabels(handles);
setColors(handles);

function lh = plotLines(handles)

session = getappdata(handles.output, 'session');
X = getXData(handles);
Y = getYData(handles);
Z = getZData(handles);

AZEL = get(handles.axes1, 'view');
XP = getPlanePosition(handles, AZEL, 'x');
YP = getPlanePosition(handles, AZEL, 'y');
ZP = getPlanePosition(handles, AZEL, 'z');

N = length(X);
for n=1:N
    lh(n,1) = plot3([X(n) XP(1)], [Y(n) Y(n)], [Z(n) Z(n)], 'linewidth',0.5, 'color',[0.8 0.8 0.8], 'visible', session.linesVisible{n}); 
    lh(n,2) = plot3([X(n) X(n)], [Y(n) YP(1)  ], [Z(n) Z(n)], 'linewidth',0.5, 'color',[0.8 0.8 0.8], 'visible', session.linesVisible{n}); 
    lh(n,3) = plot3([X(n) X(n)], [Y(n) Y(n)], [Z(n) ZP(1)  ], 'linewidth',0.5, 'color',[0.8 0.8 0.8], 'visible', session.linesVisible{n}); 
end;
setappdata(handles.output, 'lh', lh);

function pos = getPlanePosition(handles, AZEL, plane)
xLim  = [str2num(get(handles.xmin,'string')) str2num(get(handles.xmax,'string'))];
yLim  = [str2num(get(handles.ymin,'string')) str2num(get(handles.ymax,'string'))];
zLim  = [str2num(get(handles.zmin,'string')) str2num(get(handles.zmax,'string'))];
switch plane
    case 'x'
        xLim  = [str2num(get(handles.xmin,'string')) str2num(get(handles.xmax,'string'))];
        if (AZEL(1) > 0 && AZEL(1) < 180) || (AZEL(1) > -360 && AZEL(1) < -180) 
            pos(1) = xLim(1); 
            pos(2) = xLim(2); 
        else
            pos(1) = xLim(2); 
            pos(2) = xLim(1); 
        end        
    case 'y'
        yLim  = [str2num(get(handles.ymin,'string')) str2num(get(handles.ymax,'string'))];
        if (AZEL(1) > 90 && AZEL(1) < 270) || (AZEL(1) > -270 && AZEL(1) < -90)
            pos(1) = yLim(1); 
            pos(2) = yLim(2); 
        else
            pos(1) = yLim(2); 
            pos(2) = yLim(1); 
        end
    case 'z'
        zLim  = [str2num(get(handles.zmin,'string')) str2num(get(handles.zmax,'string'))];
        if AZEL(2) < 0 
            pos(1) = zLim(2); 
            pos(2) = zLim(1); 
        else
            pos(1) = zLim(1);
            pos(2) = zLim(2);
        end
end


function updateLines(handles)

session = getappdata(handles.output, 'session');
lh = getappdata(handles.output, 'lh');
X = getXData(handles);
Y = getYData(handles);
Z = getZData(handles);

AZEL = get(handles.axes1, 'view');
XP = getPlanePosition(handles, AZEL, 'x');
YP = getPlanePosition(handles, AZEL, 'y');
ZP = getPlanePosition(handles, AZEL, 'z');

N = length(X);
for n=1:N
    set(lh(n,1), 'xdata', [X(n) XP(1)  ], 'ydata', [Y(n) Y(n)], 'zdata', [Z(n) Z(n)]); 
    set(lh(n,2), 'xdata', [X(n) X(n)], 'ydata', [Y(n) YP(1)  ], 'zdata', [Z(n) Z(n)]); 
    set(lh(n,3), 'xdata', [X(n) X(n)], 'ydata', [Y(n) Y(n)], 'zdata', [Z(n) ZP(1)  ]); 
end
setappdata(handles.output, 'lh', lh);


function plotColorScale(handles, xh)
cLim = getLimits(handles, 'c');
axes(xh);
C = getCData(handles);
map = cLim(1) + diff(cLim)*(0:255)/255;
imagesc([0 1],map(:),[map(:) map(:)]);
set(xh,'ylim', cLim, 'xtick',[]);
set(xh,'yaxislocation', 'right','xticklabel',[],'ydir','normal');
ylabel(xh,getCLabel(handles));
colormap(getColormap(handles));

function plotLabels(handles)
axes(handles.axes1);
session = getappdata(handles.output, 'session');
labels = cellfun(@(x) sprintf('  %s',x), session.labels,'uniformoutput',false);
th = text(session.X, session.Y, session.Z, labels, 'visible', 'off');
set(th,'fontsize',7);
setappdata(handles.output, 'th', th);
setLabelVisibility(handles);


function state = isSelected(sel, n)
if nnz(ismember(sel,n)) == 1
    state = 'on';
else
    state = 'off';
end

function setLineVisibility(handles)
session = getappdata(handles.output, 'session');
lh = getappdata(handles.output, 'lh');
sel = getSelection(handles);
if get(handles.linescheck,'value')
    for n=1:size(lh,1)
        if strcmp(isSelected(sel, n), 'on') == 1
            set(lh(n,:), 'visible', session.linesVisible{n});
        else
            set(lh(n,:), 'visible', 'off');
        end
    end
else 
    set(lh, 'visible', 'off');
end

function setLabelVisibility(handles)
session = getappdata(handles.output, 'session');
th = getappdata(handles.output, 'th');
sel = getSelection(handles);
if get(handles.labelscheck,'value')
    for n=1:length(th)
        if strcmp(isSelected(sel, n), 'on') == 1
            set(th(n), 'visible', session.labelVisible{n});
        else
            set(th(n), 'visible', 'off');
        end
    end
else 
    set(th, 'visible', 'off');
end

function updateSelection(handles)
phScatter = getappdata(handles.output, 'phScatter');
sel = getSelection(handles);
for n=1:length(phScatter)
    set(phScatter(n), 'visible', isSelected(sel, n));
end;

function indx = getSelection(handles)
session = getappdata(handles.output, 'session');
indx = session.selection;

function setSelection(handles)
session = getappdata(handles.output, 'session');
session.selection = get(handles.datapop,'value');
setappdata(handles.output, 'session', session);

function xLabel = getXLabel(handles)
session = getappdata(handles.output, 'session');
xLabel = session.xLabel;

function setXLabel(handles)
session = getappdata(handles.output, 'session');
xstr = get(handles.xpop,'string');
session.xpop = get(handles.xpop,'value');
session.xLabel = xstr{session.xpop};
setappdata(handles.output, 'session', session);

function yLabel = getYLabel(handles)
session = getappdata(handles.output, 'session');
yLabel = session.yLabel;

function setYLabel(handles)
session = getappdata(handles.output, 'session');
ystr = get(handles.ypop,'string');
session.ypop = get(handles.ypop,'value');
session.yLabel = ystr{session.ypop};
setappdata(handles.output, 'session', session);

function zLabel = getZLabel(handles)
session = getappdata(handles.output, 'session');
zLabel = session.zLabel;

function setZLabel(handles)
session = getappdata(handles.output, 'session');
zstr = get(handles.zpop,'string');
session.zpop = get(handles.zpop,'value');
session.zLabel = zstr{session.zpop};
setappdata(handles.output, 'session', session);

function cLabel = getCLabel(handles)
session = getappdata(handles.output, 'session');
cLabel = session.cLabel;

function setSLabel(handles)
session = getappdata(handles.output, 'session');
sstr = get(handles.spop,'string');
session.spop = get(handles.spop,'value');
session.sLabel = sstr{session.zpop};
setappdata(handles.output, 'session', session);

function sLabel = getSLabel(handles)
session = getappdata(handles.output, 'session');
sLabel = session.sLabel;

function setCLabel(handles)
session = getappdata(handles.output, 'session');
cstr = get(handles.cpop,'string');
session.cpop = get(handles.cpop,'value');
session.cLabel = cstr{session.cpop};
setappdata(handles.output, 'session', session);

function setXData(handles)
session = getappdata(handles.output, 'session');
indx = get(handles.xpop,'value');
session.X = session.data(:,indx);
setappdata(handles.output, 'session', session);

function X = getXData(handles)
session = getappdata(handles.output, 'session');
X = session.X;

function setYData(handles)
session = getappdata(handles.output, 'session');
indx = get(handles.ypop,'value');
session.Y = session.data(:,indx);
setappdata(handles.output, 'session', session);

function Y = getYData(handles)
session = getappdata(handles.output, 'session');
Y = session.Y;

function setZData(handles)
session = getappdata(handles.output, 'session');
indx = get(handles.zpop,'value');
session.Z = session.data(:,indx);
setappdata(handles.output, 'session', session);

function Z = getZData(handles)
session = getappdata(handles.output, 'session');
Z = session.Z;

function setCData(handles)
session = getappdata(handles.output, 'session');
indx = get(handles.cpop,'value');
session.C = session.data(:,indx);
setappdata(handles.output, 'session', session);

function C = getCData(handles)
session = getappdata(handles.output, 'session');
C = session.C;

function setSData(handles)
session = getappdata(handles.output, 'session');
cstr = get(handles.spop,'string');
cval = get(handles.spop,'value');
switch cstr{cval}
    case {'none'}
        session.S = ones(size(session.data,1),1);
    otherwise
        indx = get(handles.spop,'value');
        session.S = session.data(:,indx);
end;

setappdata(handles.output, 'session', session);

function S = getSData(handles)
session = getappdata(handles.output, 'session');
S = session.S;

function map = getColormap(handles)

cstr = get(handles.colormap,'string');
cval = get(handles.colormap,'value');
switch cstr{cval}
    case 'jet'
        map = jet(256);
    case 'fire'
        map = lut('fire', 256);
    case 'orange hot'
        map = lut('Orange Hot', 256);
    case 'red hot'
        map = lut('Red Hot', 256);        
    otherwise
        map = jet(256);
end;

function updateColors(handles)
cols = getColors(handles);
phScatter = getappdata(handles.output, 'phScatter');
for n=1:length(phScatter)
    set(phScatter(n), 'CData', cols(n, :));
end

function setColors(handles)
session = getappdata(handles.output, 'session');
cstr = get(handles.colormap,'string');
cval = get(handles.colormap,'value');
switch cstr{cval}
    case {'jet','fire','red hot','orange hot'}
        session.colors = getColorsFromMap(handles, getColormap(handles));
        set(handles.axes2,'visible','on');
        set(get(handles.axes2,'children'),'visible','on')        
    case 'flat'
        session.colors = getMarkerColor(session.flatColors);
        set(handles.axes2,'visible','off');
        set(get(handles.axes2,'children'),'visible','off');
end;
setappdata(handles.output, 'session', session);

function cols = getColors(handles)
session = getappdata(handles.output, 'session');
cols = session.colors;

function shapes = getShapes(handles)
session = getappdata(handles.output, 'session');
shapes = session.shapes;

function cols = getColorsFromMap(handles, map)
I = getCData(handles);
cLim = getLimits(handles, 'c');

indx0 = isnan(I);
I(indx0) = min(I);

Imin = cLim(1);
Imax = cLim(2);
Irange = Imax-Imin;

indx = floor(255*(I - Imin)/(Imax-Imin)) + 1;

cols = zeros(length(I),3);

indx2 = find(I>cLim(2));
cols(indx2,:) = repmat(map(256,:),length(indx2),1);
indx2 = find(I<cLim(1));
cols(indx2,:) = repmat(map(1,:),length(indx2),1);
indx2 = find(I>=cLim(1) & I<cLim(2));
cols(indx2,:) = map(indx(indx2),:);

cols(indx0,:) = repmat([0.6 0.6 0.6],nnz(indx0),1);

function shapes = setShapes(handles)
session = getappdata(handles.output, 'session');
cstr = get(handles.spop,'string');
cval = get(handles.spop,'value');
switch cstr{cval}
    case {'none'}
        session.shapes = ones(size(session.data,1),1);    
    otherwise
        S = getSData(handles);
        sLim = getLimits(handles, 's');
        indx0 = isnan(S);
        S(S<sLim(1)) = sLim(1);
        S(S>sLim(2)) = sLim(2);
        S = (S-sLim(1))/diff(sLim);
        range = 3;  % maximum shape scaling
        shapes = (S + 1/(range-1))./(1 - S + 1/(range-1));
        shapes(indx0) = 0;
        session.shapes = shapes;
end
setappdata(handles.output, 'session', session);

function setMenu(handles, h, n)
% creates a menu for each point in the scatter plot
session = getappdata(handles.output, 'session');
set(h,'tag', session.wells{n});
mainMenu = uicontextmenu;
item = uimenu(mainMenu, 'Label', 'Label visible', 'checked', session.labelVisible{n}, 'Callback', {@setVisibility, handles, n});

lineMenu = uimenu('parent', mainMenu, 'Label','Lines visible');
options = {'on','off'};
for k=1:length(options)    
    hh(k) = uimenu('Parent', lineMenu, 'Label', options{k}, 'Checked' , session.linesVisible{n}, 'Callback', {@setMarkerLineVisibility, handles, k, n});    
end

infoMenu = uimenu('parent', mainMenu, 'Label',sprintf('info : %s', session.labels{n}));
data = session.data(n,:);
labels = session.dataLabels;
for k=1:length(labels)
    hh(k) = uimenu('Parent', infoMenu, 'Label', sprintf('%s : %g', labels{k}, data(k)));    
end

markerMenu = uimenu('parent', mainMenu, 'Label','Marker');
markers = {'circle','square','diamond','triangle (down)','triangle (up)'};
for k=1:length(markers)
    if session.markers(n) == k  chk = 'on'; else chk = 'off'; end;
    hh(k) = uimenu('Parent', markerMenu, 'Label', markers{k}, 'Checked' , chk, 'Callback', {@setMarker, handles, k, n});    
end

colorMenu = uimenu('parent', mainMenu, 'Label','Color');
colors = {'blue','green','red','cyan','magenta','yellow','gray','black'};
for k=1:length(colors)
    if session.flatColors(n) == k  chk = 'on'; else chk = 'off'; end;
    hh(k) = uimenu('Parent', colorMenu, 'Label', colors{k}, 'Checked' , chk, 'Callback', {@setColor, handles, k, n});    
end

set(h, 'uicontextmenu', mainMenu);

function setMenuListbox(handles)
% creates a menu for the listbox that can be used for changing settings for 
% multiple entries

mainMenu = uicontextmenu;

visMenu = uimenu('parent', mainMenu, 'Label','Labels visible');
options = {'on','off'};
for k=1:length(options)
    hh(k) = uimenu('Parent', visMenu, 'Label', options{k}, 'Callback', {@setGroupVisibility, handles, k});    
end;

lineMenu = uimenu('parent', mainMenu, 'Label','Lines visible');
options = {'on','off'};
for k=1:length(options)
    hh(k) = uimenu('Parent', lineMenu, 'Label', options{k}, 'Callback', {@setGroupLineVisibility, handles, k});    
end;

markerMenu = uimenu('parent', mainMenu, 'Label','Marker');
markers = {'circle','square','diamond','triangle (down)','triangle (up)'};
for k=1:length(markers)
    hh(k) = uimenu('Parent', markerMenu, 'Label', markers{k}, 'Callback', {@setGroupMarker, handles, k});    
end;

colorMenu = uimenu('parent', mainMenu, 'Label','Color');
colors = {'blue','green','red','cyan','magenta','yellow','gray','black'};
for k=1:length(colors)
    hh(k) = uimenu('Parent', colorMenu, 'Label', colors{k}, 'Callback', {@setGroupColor, handles, k});    
end;

set(handles.datapop, 'uicontextmenu', mainMenu);

function setGroupVisibility(src,eventdata, handles, state)
session = getappdata(handles.output, 'session');
phScatter = getappdata(handles.output, 'phScatter');
th = getappdata(handles.output, 'th');
sel = getSelection(handles);
states = {'on','off'};
for n=1:length(sel)
    set(th(sel(n)),'visible', states{state});
    session.labelVisible(sel(n)) = states(state);    
    h = findobj( get(phScatter(sel(n)),'UIContextMenu'),'Label', 'Label visible');
    set(h, 'checked', states{state});
end;
setappdata(handles.output, 'session', session);

function setGroupLineVisibility(src,eventdata, handles, state)
session = getappdata(handles.output, 'session');
lh = getappdata(handles.output, 'lh');
phScatter = getappdata(handles.output, 'phScatter');
sel = getSelection(handles);
states = {'on','off'};
for n=1:length(sel)
    if get(handles.labelscheck,'value')
        set(lh(sel(n),:),'visible', states{state});
    end;
    h = get(findobj( get(phScatter(sel(n)),'UIContextMenu'),'Label', 'Lines visible'),'children');
    set(h,'checked','off');
    states = {'on','off'};
    indx = ismember(get(h,'label'),states{state});
    set(h(indx),'checked','on');    
    session.linesVisible(sel(n)) = states(state);    
end;
setappdata(handles.output, 'session', session);

function setGroupMarker(src,eventdata, handles, marker)
session = getappdata(handles.output, 'session');
phScatter = getappdata(handles.output, 'phScatter');
sel = getSelection(handles);
for n=1:length(sel)
    session.markers(sel(n)) = marker;
    set(phScatter(sel(n)),'Marker', getMarkerSymbol(marker));
    h = get(findobj( get(phScatter(sel(n)),'UIContextMenu'),'Label', 'Marker'),'children');
    set(h,'checked','off');
    markerNames = {'circle','square','diamond','triangle (down)','triangle (up)'};
    indx = ismember(get(h,'label'),markerNames{marker});
    set(h(indx),'checked','on');   
end;
setappdata(handles.output, 'session', session);

function setGroupColor(src,eventdata, handles, colnr)
session = getappdata(handles.output, 'session');
phScatter = getappdata(handles.output, 'phScatter');
sel = getSelection(handles);
for n=1:length(sel)
    session.flatColors(sel(n)) = colnr;
    set(phScatter(sel(n)),'CData', getMarkerColor(colnr));
    h = get(findobj( get(phScatter(sel(n)),'UIContextMenu'),'Label', 'Color'),'children');
    set(h,'checked','off');
    markerColors = {'blue','green','red','cyan','magenta','yellow','gray','black'};
    indx = ismember(get(h,'label'),markerColors{colnr});
    set(h(indx),'checked','on');       
end;
setappdata(handles.output, 'session', session);
setColors(handles);

function setVisibility(src,eventdata, handles, nr)
session = getappdata(handles.output, 'session');
phScatter = getappdata(handles.output, 'phScatter');
th = getappdata(handles.output, 'th');
chk = get(src,'checked');
switch chk
    case 'on'
        set(src,'checked', 'off');
        set(th(nr),'visible', 'off');
        session.labelVisible(nr) = {'off'};
    case 'off'
        set(src,'checked', 'on');
        if get(handles.labelscheck,'value')
            set(th(nr),'visible', 'on');
        end;
        session.labelVisible(nr) = {'on'};          
end;
setappdata(handles.output, 'session', session);

function setMarkerLineVisibility(src,eventdata, handles, state, nr)
session = getappdata(handles.output, 'session');
lh = getappdata(handles.output, 'lh');
h = get(get(src,'Parent'), 'Children');
set(h,'checked','off');
states = {'on','off'};
indx = ismember(get(h,'label'),states{state});
set(h(indx),'checked','on');
if state == 1
         if get(handles.linescheck,'value')
            set(lh(nr,:),'visible', 'on');
         end;
        session.linesVisible(nr) = {'on'};
else
        set(lh(nr,:),'visible', 'off');
        session.linesVisible(nr) = {'off'};         
end;
setappdata(handles.output, 'session', session);

function setMarker(src,eventdata, handles, marker, nr)
session = getappdata(handles.output, 'session');
phScatter = getappdata(handles.output, 'phScatter');

h = get(get(src,'Parent'), 'Children');
set(h,'checked','off');

markerNames = {'circle','square','diamond','triangle (down)','triangle (up)'};
indx = ismember(get(h,'label'),markerNames{marker});
set(h(indx),'checked','on');

session.markers(nr) = marker;
set(phScatter(nr),'Marker', getMarkerSymbol(marker));
setappdata(handles.output, 'session', session);

function markerSymbol = getMarkerSymbol(n)

markerSymbols = {'o','s','d','v','^'};
markerSymbol = markerSymbols{n};

function col = getMarkerColor(n)

markerColors = [[0 0 1];[0 0.5 0];[1 0 0];[0 0.75 0.75];[0.75 0 0.75];[0.75 0.75 0];[0.5 0.5 0.5]; [0 0 0]];
col = markerColors(n,:);

function setColor(src,eventdata, handles, colnr, nr)

session = getappdata(handles.output, 'session');
phScatter = getappdata(handles.output, 'phScatter');

h = get(get(src,'Parent'), 'Children');
set(h,'checked','off');

markerColors = {'blue','green','red','cyan','magenta','yellow','gray','black'};
indx = ismember(get(h,'label'),markerColors{colnr});
set(h(indx),'checked','on');

session.flatColors(nr) = colnr;
set(phScatter(nr),'CData', getMarkerColor(colnr));
setappdata(handles.output, 'session', session);
setColors(handles);

% --- Executes on selection change in xpop.
function xpop_Callback(hObject, eventdata, handles)
% hObject    handle to xpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns xpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from xpop
setXData(handles);
setXLabel(handles);
axes(handles.axes1);
xlabel(getXLabel(handles));
setLimits(handles, 'x');
setAxisLimits(handles, 'x');
updateXData(handles);
updateLines(handles);

function setLabelPosition(th,dim,v)
pos = get(th,'position');
pos = cell2mat(pos);
pos(:,dim) = v(:);
for n=1:length(v)
     set(th(n),'position',pos(n,:));    
end;

function updateXData(handles)
X = getXData(handles);
ph = getappdata(handles.output, 'phScatter');
th = getappdata(handles.output, 'th');
arrayfun( @(x,y)set(x,'xdata',y), ph, X', 'UniformOutput', false );
setLabelPosition(th,1,X);

% --- Executes during object creation, after setting all properties.
function xpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ypop.
function ypop_Callback(hObject, eventdata, handles)
% hObject    handle to ypop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ypop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ypop
setYData(handles);
setYLabel(handles);
axes(handles.axes1);
ylabel(getYLabel(handles));
setLimits(handles, 'y');
setAxisLimits(handles, 'y');
updateYData(handles);
updateLines(handles);


function updateYData(handles)
Y = getYData(handles);
ph = getappdata(handles.output, 'phScatter');
th = getappdata(handles.output, 'th');
arrayfun( @(x,y)set(x,'ydata',y), ph, Y', 'UniformOutput', false );
setLabelPosition(th,2,Y);


% --- Executes during object creation, after setting all properties.
function ypop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ypop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in zpop.
function zpop_Callback(hObject, eventdata, handles)
% hObject    handle to zpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns zpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from zpop
setZData(handles);
setZLabel(handles);
axes(handles.axes1);
zlabel(getZLabel(handles));
setLimits(handles, 'z');
setAxisLimits(handles, 'z');
updateZData(handles);
updateLines(handles);

function updateZData(handles)
Z = getZData(handles);
ph = getappdata(handles.output, 'phScatter');
th = getappdata(handles.output, 'th');
arrayfun( @(x,y)set(x,'zdata',y), ph, Z', 'UniformOutput', false );
setLabelPosition(th,3,Z);


% --- Executes during object creation, after setting all properties.
function zpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in cpop.
function cpop_Callback(hObject, eventdata, handles)
% hObject    handle to cpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns cpop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from cpop
setCData(handles);
setCLabel(handles);
axes(handles.axes2);
ylabel(getCLabel(handles));
setLimits(handles, 'c');
setAxisLimits(handles, 'c');
setColors(handles);
updateCData(handles);


function updateCData(handles)
updateColors(handles);
plotColorScale(handles, handles.axes2);


% --- Executes during object creation, after setting all properties.
function cpop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cpop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in labelscheck.
function labelscheck_Callback(hObject, eventdata, handles)
% hObject    handle to labelscheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of labelscheck
setLabelVisibility(handles);
session = getappdata(handles.output, 'session');
session.labelsCheck = get(handles.labelscheck, 'value');
setappdata(handles.output, 'session', session);

% --- Executes on selection change in colormap.
function colormap_Callback(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from colormap
setColors(handles);
updateColors(handles);
session = getappdata(handles.output, 'session');
session.mappop = get(handles.colormap, 'value');
colormap(getColormap(handles));
setappdata(handles.output, 'session', session);


% --- Executes during object creation, after setting all properties.
function colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
session = getappdata(handles.output, 'session');
session.AZEL = get(handles.axes1,'view');
fileName = getappdata(handles.output, 'pathName');
[pathName, Name] = fileparts(fileName);
[fileName, pathName] = uiputfile(sprintf('%s.mat', Name), 'Save session as');
sessionName = fullfile(pathName, fileName);
save(sessionName, 'session');

% --- Executes on button press in xy.
function xy_Callback(hObject, eventdata, handles)
% hObject    handle to xy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view(handles.axes1, 0, 90);

% --- Executes on button press in xz.
function xz_Callback(hObject, eventdata, handles)
% hObject    handle to xz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view(handles.axes1, 0, 0);

% --- Executes on button press in yz.
function yz_Callback(hObject, eventdata, handles)
% hObject    handle to yz (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view(handles.axes1, 90, 0);


% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
firstSessionLoad = getappdata(handles.output, 'firstLoad');
if firstSessionLoad
    updateLines(handles);
end


% --- Executes on selection change in datapop.
function datapop_Callback(hObject, eventdata, handles)
% hObject    handle to datapop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns datapop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from datapop
setSelection(handles);
setLabelVisibility(handles);
setLineVisibility(handles);
updateSelection(handles);

% --- Executes during object creation, after setting all properties.
function datapop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datapop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmin_Callback(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmin as text
%        str2double(get(hObject,'String')) returns contents of xmin as a double
session = getappdata(handles.output, 'session');
session.limits(session.xpop,1) = str2num(get(handles.xmin,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'x');
updateLines(handles);

% --- Executes during object creation, after setting all properties.
function xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double
session = getappdata(handles.output, 'session');
session.limits(session.xpop,2) = str2num(get(handles.xmax,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'x');
updateLines(handles);

% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymin_Callback(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymin as text
%        str2double(get(hObject,'String')) returns contents of ymin as a double
session = getappdata(handles.output, 'session');
session.limits(session.ypop,1) = str2num(get(handles.ymin,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'y');
updateLines(handles);

% --- Executes during object creation, after setting all properties.
function ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ymax_Callback(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ymax as text
%        str2double(get(hObject,'String')) returns contents of ymax as a double
session = getappdata(handles.output, 'session');
session.limits(session.ypop,2) = str2num(get(handles.ymax,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'y');
updateLines(handles);

% --- Executes during object creation, after setting all properties.
function ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function zmin_Callback(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmin as text
%        str2double(get(hObject,'String')) returns contents of zmin as a double
session = getappdata(handles.output, 'session');
session.limits(session.zpop,1) = str2num(get(handles.zmin,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'z');
updateLines(handles);

% --- Executes during object creation, after setting all properties.
function zmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function zmax_Callback(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zmax as text
%        str2double(get(hObject,'String')) returns contents of zmax as a double
session = getappdata(handles.output, 'session');
session.limits(session.zpop,2) = str2num(get(handles.zmax,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'z');
updateLines(handles);

% --- Executes during object creation, after setting all properties.
function zmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cmin_Callback(hObject, eventdata, handles)
% hObject    handle to cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmin as text
%        str2double(get(hObject,'String')) returns contents of cmin as a double
session = getappdata(handles.output, 'session');
session.limits(session.cpop,1) = str2num(get(handles.cmin,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'c');
setColors(handles);

% --- Executes during object creation, after setting all properties.
function cmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cmax_Callback(hObject, eventdata, handles)
% hObject    handle to cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmax as text
%        str2double(get(hObject,'String')) returns contents of cmax as a double
session = getappdata(handles.output, 'session');
session.limits(session.cpop,2) = str2num(get(handles.cmax,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 'c');
setColors(handles);


% --- Executes during object creation, after setting all properties.
function cmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in export.
function export_Callback(hObject, eventdata, handles)
% hObject    handle to export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
exportFancy(handles,[],[]);

function exportFancy(handles, AZEL, sessionName)

fh = open('scatterPlotFig.fig');
set(fh, 'paperpositionmode','auto','color','w');
xh1 = findobj(fh,'tag','scatterAxes');
xh2 = findobj(fh,'tag','colorBar');

set(xh1,'NextPlot', 'add');

session = getappdata(handles.output, 'session');

axes(xh1);
if isempty(AZEL)
    session.AZEL = get(handles.axes1,'view');
else
    session.AZEL = AZEL;
end
AZEL = session.AZEL;

X = getXData(handles);
Y = getYData(handles);
Z = getZData(handles);
cols = getColors(handles);
sel = getSelection(handles);

N = length(X);

sz = 0.0125;
xLim  = [str2num(get(handles.xmin,'string')) str2num(get(handles.xmax,'string'))];
yLim  = [str2num(get(handles.ymin,'string')) str2num(get(handles.ymax,'string'))];
zLim  = [str2num(get(handles.zmin,'string')) str2num(get(handles.zmax,'string'))];
R = [diff(xLim) diff(yLim) diff(zLim)];

XP = getPlanePosition(handles, AZEL, 'x');
YP = getPlanePosition(handles, AZEL, 'y');
ZP = getPlanePosition(handles, AZEL, 'z');

ph1 = plotPlane(handles, 'x', XP(1)-0.001*R(1), [0.9 0.9 0.9]);
ph2 = plotPlane(handles, 'y', YP(1)+0.001*R(2), [0.8 0.8 0.8]);
ph3 = plotPlane(handles, 'z', ZP(1)-0.001*R(3), [0.9 0.9 0.9]);

if get(handles.linescheck, 'value') == 1
    N = length(X);
    lh = [];
    for n=1:N
        if strcmp(isSelected(sel, n),'on') && strcmp(session.linesVisible{n},'on')
            chk = 'on';
        else
            chk ='off';
        end;
        lh(n,1) = plot3([X(n) XP(1)  ], [Y(n) Y(n)], [Z(n) Z(n)], 'linewidth',0.5, 'color',[0.5 0.5 0.5], 'visible', chk);
        lh(n,2) = plot3([X(n) X(n)], [Y(n) YP(1)  ], [Z(n) Z(n)], 'linewidth',0.5, 'color',[0.5 0.5 0.5], 'visible', chk);
        lh(n,3) = plot3([X(n) X(n)], [Y(n) Y(n)], [Z(n) ZP(1)  ], 'linewidth',0.5, 'color',[0.5 0.5 0.5], 'visible', chk);
    end;
end;

set(xh1,'view', session.AZEL, 'linewidth', 1);

if get(handles.checkProjection, 'value') == 1
    phx = plotScatterProjection(handles, 'x', XP(1)+0.001*R(1), [0.7 0.7 1]*0.8);
    phy = plotScatterProjection(handles, 'y', YP(1)-0.001*R(2), [1 0.8 0.6]*0.8);
    phz = plotScatterProjection(handles, 'z', ZP(1)+0.001*R(3), [0.7 1  0.7]*0.75);
end

% projection perspective or orthographic
set(xh1, 'projection', 'orthographic','linewidth',1,'fontweight','bold');
set(xh1, 'xlim', xLim);
set(xh1, 'ylim', yLim);
set(xh1, 'zlim', zLim);

axes(xh1);
daspect([diff(xLim) diff(yLim) diff(zLim)]);
shapes = getShapes(handles);

phScatter = make3DMarker(X(1), Y(1), Z(1), cols(1,:), sz, getMarkerSymbol(session.markers(1)), [R(1) R(2) R(3)*shapes(1)]);
set(phScatter, 'visible', isSelected(sel, 1));
for n=2:N
    phScatter(n) = make3DMarker(X(n), Y(n), Z(n), cols(n,:), sz, getMarkerSymbol(session.markers(n)), [R(1) R(2) R(3)*shapes(n)]);
    set(phScatter(n), 'visible', isSelected(sel, n));
end
box on;
xh1.BoxStyle = 'full';
camlight right;

cstr = get(handles.colormap,'string');
cval = get(handles.colormap,'value');
if strcmp(cstr{cval}, 'flat') == 0
    cLim = [str2num(get(handles.cmin,'string')) str2num(get(handles.cmax,'string'))];
    axes(xh2);
    C = getCData(handles);
    map = cLim(1) + diff(cLim)*(0:255)/255;
    imagesc([0 1],map(:),[map(:) map(:)]);
    set(xh2,'ylim', cLim, 'xtick',[]);
    set(xh2,'yaxislocation', 'right','xticklabel',[],'ydir','normal','linewidth',1,'fontweight','bold','box','on');
    ylabel(xh2,getCLabel(handles));
    colormap(getColormap(handles));
else 
    set(xh2,'visible','off');
end

axes(xh1);
labels = cellfun(@(x) sprintf('  %s',x), session.labels,'uniformoutput',false);
th = text(session.X, session.Y, session.Z, labels, 'visible', 'on');
set(th,'fontsize',10,'fontweight','bold');
if get(handles.labelscheck,'value')
    for n=1:length(th)
        if strcmp(isSelected(sel, n), 'on') == 1
            set(th(n), 'visible', session.labelVisible{n});
        else
            set(th(n), 'visible', 'off');
        end
    end
else 
    set(th, 'visible', 'off');
end
plotGrid(handles, xh1, [XP(1)+0.003*R(1) YP(1)-0.003*R(2) ZP(1)+0.003*R(3)]);

xlabel(getXLabel(handles));
ylabel(getYLabel(handles));
zlabel(getZLabel(handles));

if isempty(sessionName)
    [fileName, pathName] = uiputfile('*.*', 'Save figure');
    [~,fileName]=fileparts(fileName);
    sessionName = fullfile(pathName, fileName);
end
savePNG(fh,sprintf('%s.png',sessionName),4,150);
saveFigure(fh, sessionName, {'eps'});
close(fh);

function plotGrid(handles, xh, pos)

xLim  = [str2num(get(handles.xmin,'string')) str2num(get(handles.xmax,'string'))];
yLim  = [str2num(get(handles.ymin,'string')) str2num(get(handles.ymax,'string'))];
zLim  = [str2num(get(handles.zmin,'string')) str2num(get(handles.zmax,'string'))];

xTick = get(gca,'XTick');
yTick = get(gca,'YTick');
zTick = get(gca,'ZTick');
hold on;
for n = 1:length(xTick)
    plot3([xTick(n) xTick(n)],yLim, [pos(3) pos(3)], 'color','black','linestyle',':','linewidth',0.5);
    plot3([xTick(n) xTick(n)], [pos(2) pos(2)],zLim, 'color','black','linestyle',':','linewidth',0.5);
end

for n = 1:length(yTick)
    plot3(xLim, [yTick(n) yTick(n)], [pos(3) pos(3)], 'color','black','linestyle',':','linewidth',0.5);
    plot3([pos(1) pos(1)], [yTick(n) yTick(n)],zLim, 'color','black','linestyle',':','linewidth',0.5);
end

for n = 1:length(zTick)
    plot3(xLim, [pos(2) pos(2)], [zTick(n) zTick(n)], 'color','black','linestyle',':','linewidth',0.5);
    plot3([pos(1) pos(1)], yLim, [zTick(n) zTick(n)], 'color','black','linestyle',':','linewidth',0.5);
end


function ph = plotPlane(handles, plane, pos, col)

xLim  = [str2num(get(handles.xmin,'string')) str2num(get(handles.xmax,'string'))];
yLim  = [str2num(get(handles.ymin,'string')) str2num(get(handles.ymax,'string'))];
zLim  = [str2num(get(handles.zmin,'string')) str2num(get(handles.zmax,'string'))];

switch plane
    case 'z'
        x = [xLim(1) xLim(2) xLim(2) xLim(1)];
        y = [yLim(1) yLim(1) yLim(2) yLim(2)];
        z = [pos pos pos pos];
    case 'y'
        x = [xLim(1) xLim(2) xLim(2) xLim(1)];
        y = [pos pos pos pos];
        z = [zLim(1) zLim(1) zLim(2) zLim(2)];
    case 'x'
        x = [pos pos pos pos];
        y = [yLim(1) yLim(2) yLim(2) yLim(1)];
        z = [zLim(1) zLim(1) zLim(2) zLim(2)];
end;
v = [x(:) y(:) z(:)];
f = [1 2 3 4];
ph = patch('faces',f,'vertices',v,'FaceLighting','none','AmbientStrength',1,'facecolor','black','edgecolor','none','facealpha',0.1);


function ph = plotScatterProjection(handles, plane, pos, col)

session = getappdata(handles.output, 'session');
X = getXData(handles);
Y = getYData(handles);
Z = getZData(handles);

switch plane
    case 'z'
        Z(:) = pos;
    case 'y'
        Y(:) = pos;
    case 'x'
        X(:) = pos;
end
sel = getSelection(handles);

N = length(X);
ph = scatter3(X(1), Y(1), Z(1), 10, col, 'filled');
hold on;
set(ph, 'Marker', getMarkerSymbol(session.markers(1)), 'visible', isSelected(sel, 1));
for n=2:N
    ph(n) = scatter3(X(n), Y(n), Z(n), 15, col,'filled');
    set(ph(n), 'Marker', getMarkerSymbol(session.markers(n)), 'visible', isSelected(sel, n));
end

% --- Executes on button press in XYZ.
function XYZ_Callback(hObject, eventdata, handles)
% hObject    handle to XYZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
view(handles.axes1, 40, 15);


% --- Executes on button press in fancy.
function fancy_Callback(hObject, eventdata, handles)
% hObject    handle to fancy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fancy


% --- Executes on button press in linescheck.
function linescheck_Callback(hObject, eventdata, handles)
% hObject    handle to linescheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of linescheck
setLineVisibility(handles);
session = getappdata(handles.output, 'session');
session.linesCheck = get(handles.linescheck, 'value');
setappdata(handles.output, 'session', session);


% --- Executes on selection change in spop.
function spop_Callback(hObject, eventdata, handles)
% hObject    handle to spop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns spop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from spop
setSData(handles);
setSLabel(handles);
setLimits(handles, 's');
setShapes(handles);



% --- Executes during object creation, after setting all properties.
function spop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to spop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smin_Callback(hObject, eventdata, handles)
% hObject    handle to smin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smin as text
%        str2double(get(hObject,'String')) returns contents of smin as a double
session = getappdata(handles.output, 'session');
session.limits(session.spop,1) = str2num(get(handles.smin,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 's');
setShapes(handles);

% --- Executes during object creation, after setting all properties.
function smin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function smax_Callback(hObject, eventdata, handles)
% hObject    handle to smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smax as text
%        str2double(get(hObject,'String')) returns contents of smax as a double
session = getappdata(handles.output, 'session');
session.limits(session.spop,2) = str2num(get(handles.smax,'string'));
setappdata(handles.output, 'session', session);
setAxisLimits(handles, 's');
setShapes(handles);

% --- Executes during object creation, after setting all properties.
function smax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function saveFigure(fh, baseName, type, dpi)

renderer = get(fh,'renderer');
set(fh,'renderer','openGl');

if nargin == 2
    type = {'png','eps','fig'};
end

if nargin == 4
    dpistr = sprintf('-r%d', dpi);
else
    dpistr = '-r600';
end

if find(ismember(type,'png'))
    print(fh,dpistr, '-dpng', '-opengl', sprintf('%s.png', baseName));
end

if find(ismember(type,'fig'))
    saveas(fh, sprintf('%s.fig', baseName), 'fig');
end

if find(ismember(type,'eps'))    
    print(fh,dpistr, '-tiff', '-deps2c', sprintf('%s.eps', baseName));  
end

if find(ismember(type,'svg'))
    plot2svg(sprintf('%s.svg', baseName), fh);
end

set(fh,'renderer',renderer);

function savePNG(fh, fileName, aliasFactor, dpi)

if nargin < 3
    aliasFactor = 1;
end;

if nargin < 4
    dpi = getScreenResolution;
    dpistr = sprintf('-r%d', aliasFactor*dpi(1));
else
    dpi = dpi*aliasFactor;
    dpistr = sprintf('-r%d', dpi);
end;

print(fh,dpistr, '-dpng', '-opengl', fileName);
if aliasFactor>1
    I = imread(fileName);
    I = imresize(I,1/aliasFactor);
    imwrite(I, fileName, 'png');
end;


function dpi = getScreenResolution

set(0,'units','pixels');  
Pix_SS = get(0,'screensize');
set(0,'units','inches');
Inch_SS = get(0,'screensize');
dpi = Pix_SS(end-1:end)./Inch_SS(end-1:end);

set(0,'units','pixels'); 


function ph = make3DMarker(x, y, z, markerColor, markerSize, markerType, axesRatios)
% creates and plots 3D markers 
switch markerType
    case 'o'
        [v,f] = generateSphere;
    case 's'
        [v,f] = generateCube;
    case 'd'
        [v,f] = generateDiamond;
    case 'v'
        [v,f] = generateTetrahedron('down');
    case '^'
        [v,f] = generateTetrahedron('up');
end
v = v*diag(axesRatios)*markerSize;
v = v + repmat([x y z],size(v,1),1);

ph = patch('faces',f,'vertices',v,'FaceLighting','gouraud','facecolor',markerColor,'edgecolor',markerColor,'EdgeLighting','phong');


function [v,f] = generateTetrahedron(flag)
% create tetrahedron coordinates using triangles
d = sqrt(3);
v = [0 -1 1 0; d-1/d -1/d -1/d 0;0 0 0 2*sqrt(2/3)]';%/sqrt(1.5);
v(:,3) = v(:,3) - mean(v(:,3));

switch flag
    case 'up' 
        f = [3 2 1;1 2 4;2 3 4;3 1 4];
    case 'down' 
        f = [1 2 3;4 2 1;4 3 2;4 1 3];
        v(:,3) = -v(:,3);
end

function [v,f] = generateCube
% create cube coordinates using squares
v = [-1 1 1 -1 -1 1 1 -1;1 1 -1 -1 1 1 -1 -1;1 1 1 1 -1 -1 -1 -1]'/1.5;
f = [3 2 1;1 4 3 ; 7 6 2;2 3 7;8 7 3; 3 4 8;5 8 4; 4 1 5;6 5 1;1 2 6;5 6 7; 7 8 5];

function [v,f] = generateDiamond
% create diamond coordinates using triangles
v = [0 0 1 0 -1 0;0 1 0 -1 0 0; 1 0 0 0 0 -1]'*1.2;
f = [1 3 2;1 4 3;1 5 4;1 2 5;2 3 6; 3 4 6;4 5 6;5 2 6];

function [v,f] = generateSphere
% create sphere coordinates using trapezoids
N = 10;
da = pi/(N-1);
theta = 0:da:pi;
phi = 0:da:2*pi;
x = sin(theta)'*cos(phi);
y = sin(theta)'*sin(phi);
z = cos(theta)'*ones(1,2*N-1);

v = [x(:) y(:) z(:)];
f = [];
for m = 1:N-1
    for n = 1:2*N-2        
        f1 = I(N, m, n);
        f2 = I(N, m, n+1);
        f3 = I(N, m+1, n+1);
        f4 = I(N, m+1, n);
        f = cat(1,f,[f3 f2 f1]);
        f = cat(1,f,[f1 f4 f3]);
    end
end
[n,c] = faceNormals(v,f);
n = sum(n.^2,2);
indx = find(n>eps); % determine and remove zero area faces
f = f(indx,:);

function k = I(N, m, n)
% helper function for 3D marker
k = sub2ind([N 2*N-1], m, n);

function [n, c] = faceNormals(v,f)
% calculates face normals for surfaces
n = [];
c = [];
for k=1:size(f,1)
    r = [v(f(k,1),:); v(f(k,2),:);v(f(k,3),:)];
    c = cat(1,c, mean(r)); 
    n = cat(1, n, cross(r(2,:)-r(1,:),r(3,:)-r(1,:)));
end

function map = lut(fname, m)
% this funcitons loads a LUT (ImageJ style) from lut folder
lutFile = fullfile('luts',sprintf('%s.lut', fname)); 
if exist(lutFile)
    fid = fopen(lutFile, 'rb');
    map = fread(fid, inf, 'uint8');
    map = reshape(map, length(map)/3, 3);
    map = map/max(map(:));
    fclose(fid);    
    if nargin == 2
        [M,N] = size(map);
        x = (0:M-1)/(M-1);
        xi = (0:m-1)/(m-1);
        r = interp1(x(:),map(:,1),xi(:));
        g = interp1(x(:),map(:,2),xi(:));
        b = interp1(x(:),map(:,3),xi(:));
        map = [r g b];
    end
else
    disp(sprintf('could not find %s', lutFile));
    map = [];
end  


% --- Executes on button press in checkProjection.
function checkProjection_Callback(hObject, eventdata, handles)
% hObject    handle to checkProjection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkProjection
