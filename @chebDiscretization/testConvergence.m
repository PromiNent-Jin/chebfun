function [isDone, epsLevel] = testConvergence(disc, values)
%TESTCONVERGENCE Happiness check.
%   Given a discretization, and a cell array of discretized functions,
%   check the equivalent Chebyshev polynomial representation for sufficient
%   convergence.

% We will test on an arbitrary linear combination of the individual
% functions.
s = 1 ./ (3*(1:numel(values))).';
newvalues = cell2mat(values(:).')*s;

% Convert to a piecewise chebfun.
u = toFunction(disc, newvalues);

% Test convergence on each piece. Start by obtaining the Chebyshev coefficients
% of all pieces, which we can then pass down to the testPiece method
coeffs = get(u, 'coeffs');
numInt = numel(disc.domain) - 1;
isDone = true(1, numInt);
epsLevel = 0;
for i = 1:numInt
    [isDone(i), t2] = testPiece(coeffs{i}.');
    epsLevel = max(epsLevel, t2);
end
   
end


function [isDone, epsLevel] = testPiece(coeffs)
% Test convergence on a single subinterval.

% FIXME: This is the v4 test. It still has an ad hoc nature. 

isDone = false;
epsLevel = eps;
thresh = 1e-6;  % demand at least this much accuracy

% Flip the coeffs to get zero degree first
c = coeffs(end:-1:1);

n = length(c);
if n < 17, return, end

% Magnitude and rescale.
ac = abs(c);
ac = ac/min(max(ac), 1);

% Smooth using a windowed max to dampen symmetry oscillations.
maxac = ac;
for k = 1:8
    maxac = max(maxac(1:end - 1), ac(k + 1:end));
end

% If too little accuracy has been achieved, do nothing.
t = find(maxac < thresh, 1);
if ( isempty(t) || n - t < 16 )
    return
end

% Find where improvement in the windowed max seems to stop, by looking at
% the derivative of a smoother form of the curve.
dmax = diff( conv( [1 1 1 1]/4, log(maxac(t:end)) ) );
mindmax = dmax;
for k = 1:2
    mindmax = min(mindmax(1:end - 1), dmax(k + 1:end));
end

% Find the place to chop the series. 
cutHere = find(mindmax > 0.01*min(mindmax), 3);
if ( isempty(cutHere) )
    cutHere = 1;
else
    cutHere = cutHere(end) + t + k + 3;
end

% If the cut location is within the given coefficients, we're done. 
if ( cutHere < n )
    isDone = true;
    % Use the information from cut to deduce an epsLevel
    epsLevel = max( abs(c(cutHere + 1)) );
end

end