function out = circconv(f,g)
%CIRCCONV   Circular convolution of a BNDFUN on its interval [a,b].
%   S = CIRCCONV(F,G) is the circular convolution from a to b of F and G.
%   
%   NOTE: Only works when f and g consist of fourtech objects.
%
% See also CONV.

% Copyright 2014 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org for Chebfun information.

if ~isa(f.onefun,'fourtech') && ~isa(g.onefun,'fourtech')
    error('CHEBFUN:BNDFUN:NotAvailable','Circular convolutions only possible for Fourier-based chebfuns.');
end

% Rescaling factor, (b - a)/2:
rescaleFactor = 0.5*diff(f.domain);

% Assign the output to be the sum of the onefun of the input, rescaled.
out = conv(f.onefun,g.onefun)*rescaleFactor;

end
