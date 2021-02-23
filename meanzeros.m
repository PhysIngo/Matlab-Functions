function [mz, varargout] = meanzeros(data,dim,varargin)
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