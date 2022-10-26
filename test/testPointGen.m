a = 5;
p = 10000;
points = generateHexagonPoints(a, p);


x = ones(1, 7) * a;
y = zeros(1, 7);
[~, r] = cart2pol(x, y);
theta = [0:5, 0] * pi / 3;
[x, y] = pol2cart(theta, r);




scatter(points(:, 1), points(:, 2));
hold on
plot(x, y)
hold off
xlim([-a * 1.05, a * 1.05])
ylim([-a * 1.05, a * 1.05])
pbaspect([1 1 1])
