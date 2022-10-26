function points = generateHexagonPoints(a, p)
%GENERATEHEXAGONPOINTS Summary of this function goes here
%   Detailed explanation goes here
n = 6;
angle = pi / 3;
k = a * sin(angle) * (log(tan((n + 2) * pi / (4 * n))) ...
    - log(tan(angle / 2)));
u1 = rand(1, p);
u2 = rand(1, p);

% Adjusted
% theta = softRescale(- angle ...
%     + 2 * atan(exp(k * u1 ./ (a * sin(angle)) ...
%     + log(tan(angle / 2)))), 0, 2 * pi / n);
theta = - angle ...
    + 2 * atan(exp(k * u1 ./ (a * sin(angle)) ...
    + log(tan(angle / 2))));

R = a * sin(angle) ./ sin(theta + angle);
r = R .* sqrt(u2);
% t = randi([0, n-1], 1, p);
% theta = theta + angle * t;
% [x, y] = pol2cart(theta, r);
u3 = rand(1, p);
% u3 = zeros(1, p);
theta = theta + floor(u3 * n) * angle;
[x, y] = pol2cart(theta, r);
points = [x; y]';


end

