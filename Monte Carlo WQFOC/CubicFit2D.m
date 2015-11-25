function p = CubicFit2D(x,y,z,w)


x = x(:);
y = y(:);
z = z(:);
w = w(:);

pts=length(z);

% Construct weighted Vandermonde matrix.
V=zeros(pts,10);
V(:,1) = w;

ordercolumn=1;
for order = 1:3
    for ordercolumn=ordercolumn+(1:order)
        V(:,ordercolumn) = x.*V(:,ordercolumn-order);
    end
    ordercolumn=ordercolumn+1;
    V(:,ordercolumn) = y.*V(:,ordercolumn-order-1);
end

% Solve least squares problem.
[Q,R] = qr(V,0);
ws = warning('off','all'); 
p = R\(Q'*(w.*z));    % Same as p = V\(w.*z);
warning(ws);
p = p.';          % Polynomial coefficients are row vectors by convention.
