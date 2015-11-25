function p = QuadraticFit2D(x,y,z,w)

% Function to fit a quadratic surface to the given velocity data, subjected
% to the weights specified in w.
% This is an optimized form of polyfitweighted2.m availabe online

x = x(:);
y = y(:);
z = z(:);
w = w(:);

pts=length(z);

% Construct weighted Vandermonde matrix.
V=zeros(pts,6);
V(:,1) = w;

ordercolumn=1;
for order = 1:2
    for ordercolumn=ordercolumn+(1:order)
        V(:,ordercolumn) = x.*V(:,ordercolumn-order);
    end
    ordercolumn=ordercolumn+1;
    V(:,ordercolumn) = y.*V(:,ordercolumn-order-1);
end

% Solve least squares problem.
[Q,R] = qr(V,0);
ws = warning('off','all'); 
p = R\(Q'*(w.*z));  
p = p.';          