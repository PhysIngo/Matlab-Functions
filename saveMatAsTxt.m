function varargout = saveMatAsTxt(matrix,fileName,varargin)
% saveMatAsTxt by Ingo Hermann, 2021-05-18
% This functions saves a 2D matrix into a txt file
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp.: saveMatAsTxt(matrix,"Lut.txt",'precission',1);
%
% --- arguments ---
% saveMatAsTxt(matrix,fileName,...):
% matrix ... is the input matrix which is converted and saved
% fileName ... is the filename of the output txt file
%
% --- optional input arguments ---
% saveMatAsTxt(...,varargin):
% 'load' ... loads the txt file as a matrix into varargout
% 'precission',prec ... precission of the values
%
% --- optional output arguments ---
% varargout = saveMatAsTxt(...):
% matrix ... if option 'load' is chosen, everything is written here
%

[logic, index] = max(strcmp(varargin,'precission'));
if logic
    prec = varargin{index+1};
else
    prec = 4;		% ms.
end
    
if isempty(varargin)
    varargin = {''};
end

if max(strcmp(varargin,'load')) || isempty(matrix)
    % loads the txt to matrix
    fileID = fopen(fileName,'r');
    varargout{1}=dlmread(fileName);
else
    % saves the matrix in txt
    fileID = fopen(fileName,'wt');
    for i = 1:size(matrix,1)
        for ii = 1:size(matrix,2)
            fprintf(fileID, ['%0.',num2str(prec),'f '], matrix(i,ii));
        end
        fprintf(fileID, '\r');
    end
end
fclose(fileID);