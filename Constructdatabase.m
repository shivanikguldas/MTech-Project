cICHDirectory = 'train\cat\';
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
cHealthyDirectory = 'train\dog\';
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
trainlabels=[ICHFeatures(:,1);HealthyFeatures(:,1)];
trainfeat=[ICHFeatures(:,2:5);HealthyFeatures(:,2:5)];
save trainlabels.mat trainlabels
save trainfeat.mat trainfeat
save ICHFeatures.mat ICHFeatures;
save HealthyFeatures.mat HealthyFeatures;

