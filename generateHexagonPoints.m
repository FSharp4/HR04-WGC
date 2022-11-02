function points = generateHexagonPoints(a, p)
%GENERATEHEXAGONPOINTS Generates p points in a hexagon with radius a.
%   This is done procedurally using the method found in the paper by 
%   M. Hlynka and S. Loach.
n = 6;
angle = pi / 3;
k = a * sin(angle) * (log(tan((n + 2) * pi / (4 * n))) ...
    - log(tan(angle / 2)));
u1 = rand(1, p);
u2 = rand(1, p);
theta = - angle ...
    + 2 * atan(exp(k * u1 ./ (a * sin(angle)) ...
    + log(tan(angle / 2))));

R = a * sin(angle) ./ sin(theta + angle);
r = R .* sqrt(u2);
u3 = rand(1, p);
theta = theta + floor(u3 * n) * angle;
[x, y] = pol2cart(theta, r);
points = [x; y]';


end

