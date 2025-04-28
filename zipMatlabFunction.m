function varargout = zipMatlabFunction(name,varargin)
% zipMatlabFunction by Ingo Hermann 2021-07-16
% This functions zips a function together with all dependecies
% --------------------------------
% This script needs the user functions:
% -- none --
%
% Exp.: dependencies = zipMatlabFunction('openMaps.m');
%
% --- arguments ---
% zipMatlabFunction(name)
% name ... name of the function
%
% --- optional input arguments ---
% zipMatlabFunction(...,varargin):
% 'iterative' ... defines that it goes iteratively through the functions
% 'nozip' ... skips the zip process
% 
% --- optional output arguments ---
% [...,varargout] = zipMatlabFunction(...):
% varargout ... the file names of the dependecies
%

if isempty(varargin)
    varargin{1} = '';
end

path = which(name);
try
    text = fileread(path);
catch
    error('filename does not exist or is not in path!');
end
idx = strfind(text,'% This script needs the user functions:');
subtext = text(idx+39:end);
newStr = splitlines( subtext );
addFiles = [];
addFiles{1,1} = path;cc = 2;
for i=2:1:size(newStr,1)
    tmp = newStr{i,1};
    if tmp == '%'
        break;
    end
    if contains(tmp,'- none -')
        break;
    end
    idx = strfind(tmp,'.m');
    file = [tmp(3:idx-1),'.m'];
    tmp = which(file);
    try
        text = fileread(path);
    catch
        continue;
    end
    addFiles{cc} = which(file);
    if max(strcmp(varargin,'iterative'))
        addFiles = [addFiles zipMatlabFunction(addFiles{cc},'nozip')];
        cc = size(addFiles,1);
    end
    cc = cc+1;
end

% dont zip if its iterative
if ~max(strcmp(varargin,'nozip'))
    try 
        zip(path(1:end-2),addFiles);
    catch
        warning('Some dependecies are not correctly implemented in the functions!\n no zip is written.');
    end
end

varargout{1} = addFiles;

end