function out = poly(f, n)
%POLY	 Polynomial coefficients of a CHEBFUN.
%   POLY(F) returns the polynomial coefficients of the first FUN of F.
%
%   POLY(F, N) returns the polynomial coefficients of the Nth FUN of F. 
%
%   For numerical work, the Chebyshev polynomial coefficients returned by
%   CHEBPOLY() are more useful.
%
% See also CHEBPOLY.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% TODO: Should this attempt to return Taylor coefficients of the global Chebfun
% if f is not smooth? (i.e., in the same way as LEGPOLY does).

% Deal qith quasimatrices:
if ( numel(f) > 1 )
    try 
        % Attempt to convert to an array-valed CHEBFUN:
        f = quasi2cheb(f);
    catch ME
        error('CHEBFUN:poly:quasi', ...
            'POLY does not support quasimatrices.')
    end
end

% Deal with multiple FUNS case:
nfuns = numel(f.funs);
if ( nargin == 1 )
    if ( nfuns > 1 )
        warning('CHEBFUN:poly', ['F has more than one FUN. ', ...
         'Only the polynomial coefficients of the first FUN are returned.']);
    end
    n = 1;
end

% Catch some errors:
if ( n > nfuns )
    error('CHEBFUN:poly:nfuns', 'Chebfun only has %s FUNS', num2str(nfuns))
elseif ( ~isscalar(n) || n < 0 || round(n) ~= n )
    error('CHEBFUN:poly:input2', 'N should be a positive scalar integer.');
end

% Call @FUN/POLY.m
out = poly(f.funs{n});
    
end

