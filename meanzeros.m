function [mz, varargout] = meanzeros(data,dim,varargin)
% meanzeros by Ingo Hermann 2021-05-18
% This functions calculates the mean and standard deviation of the input
% along a dimension without considering zeros
% --------------------------------
% This script needs the user functions:
% - none -
%
% Exp.: [mz] = meanzeros(data,2)
%
% --- arguments ---
% [mz,...] = meanzeros(data,dim,...)
% data ... input data which can be a multi dimensional array
% dim ... dimension along which the mean should be calculated
% mz ... the mean value without considering zeros in the input data
%
% --- optional input arguments ---
% [...] = meanzeros(...,varargin)
% 'Cut',cut ... specifies the threshold, at which the data should be set to
% zero
% 'All' ... takes all dimensions and calculates the mean and std
% 
% --- optional output arguments ---
% [...,varargout] = openMaps(...):
% varargout ... specifies the std as output additionally to the mean
% 



if exist('dim')==0
    dim = 1;
end
if max(strcmp(varargin,'Cut'))
    idx = 1 + find(strcmp(varargin,'Cut'));
    data(data>varargin{idx}) = 0;
end
    
    
data(data==0) = nan;
if max(strcmp(varargin,'All'))
    mz = mean(data(:),2,'omitnan');
    sz = std(data(:),0,2,'omitnan');
else
    mz = mean(data,dim,'omitnan');
    sz = std(data,0,dim,'omitnan');
end

mz(isnan(mz)) = 0;
sz(isnan(sz)) = 0;

varargout{1} = sz;

end