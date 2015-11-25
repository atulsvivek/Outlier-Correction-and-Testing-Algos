function z = polyval2(p,x,y)


x=x(:);
y=y(:);
lx=length(x);
ly=length(y);
lp=length(p);
pts=lx*ly;

y=y*ones(1,lx);
x=ones(ly,1)*x';
x = x(:);
y = y(:);

n=(sqrt(1+8*length(p))-3)/2;

% Construct weighted Vandermonde matrix.
V=zeros(pts,lp);
V(:,1) = ones(pts,1);
ordercolumn=1;
for order = 1:n
    for ordercolumn=ordercolumn+(1:order)
        V(:,ordercolumn) = x.*V(:,ordercolumn-order);
    end
    ordercolumn=ordercolumn+1;
    V(:,ordercolumn) = y.*V(:,ordercolumn-order-1);
end

z=V*p';
z=reshape(z,ly,lx);