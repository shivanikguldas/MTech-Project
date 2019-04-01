function varargout = MainGUI_KNN(varargin)
% MAINGUI_KNN MATLAB code for MainGUI_KNN.fig
%      MAINGUI_KNN, by itself, creates a new MAINGUI_KNN or raises the existing
%      singleton*.
%
%      H = MAINGUI_KNN returns the handle to a new MAINGUI_KNN or the handle to
%      the existing singleton*.
%
%      MAINGUI_KNN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAINGUI_KNN.M with the given input arguments.
%
%      MAINGUI_KNN('Property','Value',...) creates a new MAINGUI_KNN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MainGUI_KNN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MainGUI_KNN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MainGUI_KNN

% Last Modified by GUIDE v2.5 10-Jul-2018 21:15:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MainGUI_KNN_OpeningFcn, ...
                   'gui_OutputFcn',  @MainGUI_KNN_OutputFcn, ...
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


% --- Executes just before MainGUI_KNN is made visible.
function MainGUI_KNN_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MainGUI_KNN (see VARARGIN)

% Choose default command line output for MainGUI_KNN
handles.output = hObject;
set(handles.figure1,'CloseRequestFcn',@closeGUI);
Constructdatabase
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes MainGUI_KNN wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = MainGUI_KNN_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Imageread.
function Imageread_Callback(hObject, eventdata, handles)
% hObject    handle to Imageread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global featuret
[file,path]=uigetfile('*.*','select the image for classifiction');
inputimpath=fullfile(path,file);
timage=imread(inputimpath);
axes(handles.axes1)
imshow(timage),title('Input Test Image')
Meant = mean2(timage);
Standard_Deviationt = std2(timage);
Entropyt = entropy(timage);
RMSt = mean2(rms(timage));
featuret=[Meant,Standard_Deviationt,Entropyt,RMSt];
set(handles.p1,'string',num2str(Meant))
set(handles.p2,'string',num2str(Standard_Deviationt))
set(handles.p3,'string',num2str(Entropyt))
set(handles.p4,'string',num2str(RMSt))

% --- Executes on button press in Classify.
function Classify_Callback(hObject, eventdata, handles)
% hObject    handle to Classify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global featuret
load trainfeat.mat
load trainlabels.mat
load newtrainfeat.mat
load newtrainlabels.mat
warning off
conf=questdlg('Which training you want to use','training question','Modified','Original','Original');
switch conf
    case 'Original'
        out1=knnclassify(featuret,trainfeat,trainlabels);
    case 'Modified'
        out1=knnclassify(featuret,newtrainfeat,newtrainlabels);
end
    if out1==1
        set(handles.p5,'string','Cat')
    else
    set(handles.p5,'string','Dog')
    end

% --- Executes on button press in performance.
function performance_Callback(hObject, eventdata, handles)
% hObject    handle to performance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load trainfeat.mat
load trainlabels.mat
load newtrainfeat.mat
load newtrainlabels.mat
warning off
categories={'cat','dog'};
conf=questdlg('Which training you want to Analyse','training question','Modified','Original','Original');
switch conf
    case 'Original'
        TestDirectory = 'test\';
        stTestFilesList = dir(TestDirectory);
        iNoOfFiles_Test = length(stTestFilesList);
        for iFileIndex = 3:iNoOfFiles_Test
            cFileName = stTestFilesList(iFileIndex).name;
            cFilePath = [TestDirectory cFileName];
            inpImage = imread(cFilePath); 
            Mean = mean2(inpImage);
            Standard_Deviation = std2(inpImage);
            Entropy = entropy(inpImage);
            RMS = mean2(rms(inpImage));
            TestFeatures(iFileIndex-2, 1) = Mean;
            TestFeatures(iFileIndex-2, 2) = Standard_Deviation;
            TestFeatures(iFileIndex-2, 3) = Entropy;
            TestFeatures(iFileIndex-2, 4) = RMS;
        end
        save TestFeatures.mat TestFeatures
        out1=knnclassify(TestFeatures,trainfeat,trainlabels);
        save out1.mat out1     
        
        idx=(out1()==1);
        p=length(out1(idx));
        n=length(out1(~idx));
        N=p+n;
        tp=sum(out1(idx)==trainlabels(idx));
        tn=sum(out1(~idx)==trainlabels(~idx));
        fp=n-tn;
        fn=p-tp;
        tp_rate=tp/p;
        tn_rate=tn/n;
        accuracy=(tp+tn)/N;
        Sensitivity=tp_rate;
        specificity=tn_rate;
        precision=tp/(tp+fp);
%         [c_matrix,Result,RefereceResult]= confusiongenarate.getMatrix(trainlabels,out1);
%         accuracy=Result.Accuracy;        
%         Sensitivity=Result.Sensitivity;
%         specificity=Result.Specificity;
%         precision=Result.Precision;
        set(handles.p6,'string',strcat(round(num2str(accuracy*100)),'%'))
        set(handles.p7,'string',strcat(round(num2str(precision*100)),'%'))
        set(handles.p8,'string',strcat(round(num2str(Sensitivity*100)),'%'))
        set(handles.p9,'string',strcat(round(num2str(specificity*100)),'%'))
    case 'Modified'
        TestDirectory = 'newtest\';
        stTestFilesList = dir(TestDirectory);
        iNoOfFiles_Test = length(stTestFilesList);
        for iFileIndex = 3:iNoOfFiles_Test
            cFileName = stTestFilesList(iFileIndex).name;
            cFilePath = [TestDirectory cFileName];
            inpImage = imread(cFilePath); 
            Mean = mean2(inpImage);
            Standard_Deviation = std2(inpImage);
            Entropy = entropy(inpImage);
            RMS = mean2(rms(inpImage));
            TestFeaturesmod(iFileIndex-2, 1) = Mean;
            TestFeaturesmod(iFileIndex-2, 2) = Standard_Deviation;
            TestFeaturesmod(iFileIndex-2, 3) = Entropy;
            TestFeaturesmod(iFileIndex-2, 4) = RMS;
        end
        save TestFeaturesmod.mat TestFeaturesmod
        out2=knnclassify(TestFeaturesmod,newtrainfeat,newtrainlabels);
        save out2.mat out2
        % figure(),plotconfusion(trainlabels,out1)
        % figure(),plotroc(trainlabels,out1),legend('off')
        idx=(out2()==1);
        p=length(out2(idx));
        n=length(out2(~idx));
        N=p+n;
        tp=sum(out2(idx)==newtrainlabels(idx));
        tn=sum(out2(~idx)==newtrainlabels(~idx));
        fp=n-tn;
        fn=p-tp;
        tp_rate=tp/p;
        tn_rate=tn/n;
        accuracy=(tp+tn)/N;
        Sensitivity=tp_rate;
        specificity=tn_rate;
        precision=tp/(tp+fp);
%         [c_matrix,Result,RefereceResult]= confusiongenarate.getMatrix(newtrainlabels,out2);
%         accuracy=Result.Accuracy;        
%         Sensitivity=Result.Sensitivity;
%         specificity=Result.Specificity;
%         precision=Result.Precision;
        set(handles.p6,'string',strcat(round(num2str(accuracy*100)),'%'))
        set(handles.p7,'string',strcat(round(num2str(precision*100)),'%'))
        set(handles.p8,'string',strcat(round(num2str(Sensitivity*100)),'%'))
        set(handles.p9,'string',strcat(round(num2str(specificity*100)),'%'))
end


% --- Executes on button press in change.
function change_Callback(hObject, eventdata, handles)
% hObject    handle to change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
r1=get(handles.r1,'value');
r2=get(handles.r2,'value');
r3=get(handles.r3,'value');
r4=get(handles.r4,'value');
r5=get(handles.r5,'value');
r6=get(handles.r6,'value');
r7=get(handles.r7,'value');
r8=get(handles.r8,'value');
[file,path]=uigetfile('*.*','select the image for modification');
impath=fullfile(path,file);
inpImage=imread(impath);
c=size(inpImage,3);
if r1==1     %median filter based enhancement  
     for i=1:3
     K(:,:,i) = medfilt2(inpImage(:,:,i));
     end
     [filename, pathname] = uiputfile( ...
    {'*.jpg','Image Files (*.jpg)'},...
       'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
elseif r2==1   %Imrotation based enhancement
     K = imrotate(inpImage,-10,'bilinear','crop');     
     [filename, pathname] = uiputfile( ...
    {'*.jpg','Image Files (*.jpg)'},...
       'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
elseif r3==1    %histogram equalisation based enhancement
    for i=1:3
     K(:,:,i) = histeq(inpImage(:,:,i));
     end
     [filename, pathname] = uiputfile( ...
    {'*.jpg','Image Files (*.jpg)'},...
       'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
elseif r4==1      %contrast strecth based enhancement 
    for i=1:3
     K(:,:,i) = imadjust(inpImage(:,:,i),stretchlim(inpImage(:,:,i)),[]);
    end
     [filename, pathname] = uiputfile( ...
    {'*.jpg','Image Files (*.jpg)'},...
       'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
elseif r5==1    %contrast enhancement 
        srgb2lab = makecform('srgb2lab');
        lab2srgb = makecform('lab2srgb');
        shadow_lab = applycform(inpImage, srgb2lab); % convert to L*a*b*
        max_luminosity = 50;
        L = shadow_lab(:,:,1)/max_luminosity;
        shadow_imadjust = shadow_lab;
        shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
        K = applycform(shadow_imadjust, lab2srgb);
        figure(1),imshow(K),title('Contrast Enhancement Image')
        [filename, pathname] = uiputfile( ...
        {'*.jpg','Image Files (*.jpg)'},...
        'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
elseif r6==1    %CLAHE enhancement
        warning off
        LAB = rgb2lab(inpImage);
        L = LAB(:,:,1)/100;
        L = adapthisteq(L,'NumTiles',[8 8],'ClipLimit',0.005);
        LAB(:,:,1) = L*100;
        K = lab2rgb(LAB);
        figure(1),imshow(K),title('CLAHE Enhancement Image')
        [filename, pathname] = uiputfile( ...
        {'*.jpg','Image Files (*.jpg)'},...
        'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
elseif r7==1    %DPBHE enhancement
    warning off
    labInputImage = applycform(inpImage,makecform('srgb2lab'));
    Lbpdfhe = fcnBPDFHE(labInputImage(:,:,1));
    labOutputImage = cat(3,Lbpdfhe,labInputImage(:,:,2),labInputImage(:,:,3));
    K = applycform(labOutputImage,makecform('lab2srgb'));
    figure(1),imshow(K),title('DPBHE Enhancement Image')
        [filename, pathname] = uiputfile( ...
        {'*.jpg','Image Files (*.jpg)'},...
        'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
else             %adaptive histogram equalisation based enhancement 
     for i=1:3
     K(:,:,i) = adapthisteq(inpImage(:,:,i));
     end
     figure(1),imshow(K),title('Apative Histogram EQ Image')
     [filename, pathname] = uiputfile( ...
    {'*.jpg','Image Files (*.jpg)'},...
       'Pick a file');
     if ~isequal(filename,0)                     
         imwrite(K,fullfile(pathname, filename));
     end
    
end
% elseif r1==1&&r2==1
%     for i=1:3
%      K(:,:,i) = medfilt2(inpImage(:,:,i));
%     end
%      K = imrotate(K,-10,'bilinear','crop');     
%      [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
% elseif r1==1&&r3==1
%     for i=1:3
%      K(:,:,i) = medfilt2(inpImage(:,:,i));
%     end
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
%     
%      [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
% elseif r1==1&&r4==1
%     for i=1:3
%      K(:,:,i) = medfilt2(inpImage(:,:,i));
%     end
%     for i=1:c
%      K(:,:,i) = imadjust(K(:,:,i),stretchlim(inpImage(:,:,i)),[]);
%     end
%     
%      [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
% elseif r2==1&&r3==1
%      K = imrotate(K,-10,'bilinear','crop');
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
%     
% elseif r2==1&&r4==1
%     K = imrotate(K,-10,'bilinear','crop');
%     for i=1:3
%      K(:,:,i) = imadjust(inpImage(:,:,i),stretchlim(inpImage(:,:,i)),[]);
%     end
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
%     
% elseif r3==1&&r4==1
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
% 
%     for i=1:3
%      K(:,:,i) = imadjust(inpImage(:,:,i),stretchlim(inpImage(:,:,i)),[]);
%     end
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
%     
% elseif r1==1&&r2==1&&r3==1
%     for i=1:3
%      K(:,:,i) = medfilt2(inpImage(:,:,i));
%     end
%     
%       K = imrotate(K,-10,'bilinear','crop');
% 
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
% elseif r1==1&&r3==1&&r4==1
%     for i=1:3
%      K(:,:,i) = medfilt2(inpImage(:,:,i));
%     end
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
% 
%     for i=1:3
%      K(:,:,i) = imadjust(inpImage(:,:,i),stretchlim(inpImage(:,:,i)),[]);
%     end
%     
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
%     
% elseif r2==1&&r3==1&&r4==1
%     K = imrotate(K,-10,'bilinear','crop');
% 
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
% 
%     for i=1:3
%      K(:,:,i) = imadjust(inpImage(:,:,i),stretchlim(inpImage(:,:,i)),[]);
%     end
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
%     
%     
% elseif r1==1&&r2==1&&r3==1&&r4==1
% 
%     for i=1:3
%      K(:,:,i) = medfilt2(inpImage(:,:,i));
%     end
%     
%     K = imrotate(K,-10,'bilinear','crop');
% 
%     for i=1:c
%      K(:,:,i) = histeq(K(:,:,i));
%     end
% 
%     for i=1:3
%      K(:,:,i) = imadjust(inpImage(:,:,i),stretchlim(inpImage(:,:,i)),[]);
%     end
%     [filename, pathname] = uiputfile( ...
%     {'*.jpg','Image Files (*.jpg)'},...
%        'Pick a file');
%      if ~isequal(filename,0)                     
%          imwrite(K,fullfile(pathname, filename));
%      end
% end

% --- Executes on button press in train.
function train_Callback(hObject, eventdata, handles)
% hObject    handle to train (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cICHDirectory = 'newtrain\cat\';
cResultDirectroy = '';
stICHFilesList = dir(cICHDirectory);
iNoOfFiles_ICH = length(stICHFilesList);
ICHFeatures=zeros(iNoOfFiles_ICH-2);
for iFileIndex = 3:iNoOfFiles_ICH
    cFileName = stICHFilesList(iFileIndex).name;
    cFilePath = [cICHDirectory cFileName];
    inpImage = imread(cFilePath); 
    Mean = mean2(inpImage);
    Standard_Deviation = std2(inpImage);
    Entropy = entropy(inpImage);
    RMS = mean2(rms(inpImage));
   % Column 1 is number of objects. Column 2 is area
   % Row is the sample
    ICHFeatures(iFileIndex-2, 1) = 1;
    ICHFeatures(iFileIndex-2, 2) = Mean;
    ICHFeatures(iFileIndex-2, 3) = Standard_Deviation;
    ICHFeatures(iFileIndex-2, 4) = Entropy;
    ICHFeatures(iFileIndex-2, 5) = RMS;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% HEALTHY BRAIN IMAGES DATABASE GENERATION    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cHealthyDirectory = 'newtrain\dog\';
stHealthyFilesList = dir(cHealthyDirectory);
iNoOfFiles_Healthy = length(stHealthyFilesList);
HealthyFeatures=zeros(iNoOfFiles_Healthy-2);
for iFileIndex = 3:iNoOfFiles_Healthy
    cFileName = stHealthyFilesList(iFileIndex).name;
    cFilePath = [cHealthyDirectory cFileName];
    inpImage = imread(cFilePath);
    Mean = mean2(inpImage);
    Standard_Deviation = std2(inpImage);
    Entropy = entropy(inpImage);
    RMS = mean2(rms(inpImage));    
    HealthyFeatures(iFileIndex-2, 1) = 2;
    HealthyFeatures(iFileIndex-2, 2) = Mean;
    HealthyFeatures(iFileIndex-2, 3) = Standard_Deviation;
    HealthyFeatures(iFileIndex-2, 4) = Entropy ;
    HealthyFeatures(iFileIndex-2, 5) = RMS;
end
newtrainlabels=[ICHFeatures(:,1);HealthyFeatures(:,1)];
newtrainfeat=[ICHFeatures(:,2:5);HealthyFeatures(:,2:5)];
save newtrainlabels.mat newtrainlabels
save newtrainfeat.mat newtrainfeat
msgbox('Training Done')

% --- Executes on button press in r1.
function r1_Callback(hObject, eventdata, handles)
% hObject    handle to r1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',1)
set(handles.r2,'value',0)
set(handles.r3,'value',0)
set(handles.r4,'value',0)
set(handles.r5,'value',0)
set(handles.r6,'value',0)
set(handles.r7,'value',0)
set(handles.r8,'value',0)
% --- Executes on button press in r2.
function r2_Callback(hObject, eventdata, handles)
% hObject    handle to r2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',1)
set(handles.r3,'value',0)
set(handles.r4,'value',0)
set(handles.r5,'value',0)
set(handles.r6,'value',0)
set(handles.r7,'value',0)
set(handles.r8,'value',0)
% --- Executes on button press in r3.
function r3_Callback(hObject, eventdata, handles)
% hObject    handle to r3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',0)
set(handles.r3,'value',1)
set(handles.r4,'value',0)
set(handles.r5,'value',0)
set(handles.r6,'value',0)
set(handles.r7,'value',0)
set(handles.r8,'value',0)

% --- Executes on button press in r4.
function r4_Callback(hObject, eventdata, handles)
% hObject    handle to r4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',0)
set(handles.r3,'value',0)
set(handles.r4,'value',1)
set(handles.r5,'value',0)
set(handles.r6,'value',0)
set(handles.r7,'value',0)
set(handles.r8,'value',0)
% --- Executes on button press in r5.
function r5_Callback(hObject, eventdata, handles)
% hObject    handle to r5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',0)
set(handles.r3,'value',0)
set(handles.r4,'value',0)
set(handles.r5,'value',1)
set(handles.r6,'value',0)
set(handles.r7,'value',0)
set(handles.r8,'value',0)
% Hint: get(hObject,'Value') returns toggle state of r5


% --- Executes on button press in r6.
function r6_Callback(hObject, eventdata, handles)
% hObject    handle to r6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',0)
set(handles.r3,'value',0)
set(handles.r4,'value',0)
set(handles.r5,'value',0)
set(handles.r6,'value',1)
set(handles.r7,'value',0)
set(handles.r8,'value',0)
% Hint: get(hObject,'Value') returns toggle state of r6


% --- Executes on button press in r7.
function r7_Callback(hObject, eventdata, handles)
% hObject    handle to r7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',0)
set(handles.r3,'value',0)
set(handles.r4,'value',0)
set(handles.r5,'value',0)
set(handles.r6,'value',0)
set(handles.r7,'value',1)
set(handles.r8,'value',0)
% Hint: get(hObject,'Value') returns toggle state of r7


% --- Executes on button press in r8.
function r8_Callback(hObject, eventdata, handles)
% hObject    handle to r8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.r1,'value',0)
set(handles.r2,'value',0)
set(handles.r3,'value',0)
set(handles.r4,'value',0)
set(handles.r5,'value',0)
set(handles.r6,'value',0)
set(handles.r7,'value',0)
set(handles.r8,'value',1)
% Hint: get(hObject,'Value') returns toggle state of r8

function closeGUI(src,evnt)
%src is the handle of the object generating the callback (the source of the event)
%evnt is the The event data structure (can be empty for some callbacks)
selection = questdlg('Do you want to close Classification System',...
                     'Close Request Function',...
                     'Yes','No','Cancel','Yes');
switch selection
   case 'Yes'
    delete(gcf)
   case 'No'
     return
   case 'Cancel'
     msgbox('User Selected Cancel')
     return
end



