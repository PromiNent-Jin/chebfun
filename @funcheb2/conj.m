function f = conj(f)
%CONJ	Complex conjugate of a FUNCHEB2.
%   CONJ(F) is the complex conjugate of F. For a complex F, CONJ(F) = REAL(F) -
%   1i*IMAG(F).
%
% See also REAL, IMAG.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org for Chebfun information.

% Conjugate the values:
f.values = conj(f.values);

% Conjugate the coefficients:
f.coeffs = conj(f.coeffs);

end