r = 3;
k = 200;
l = 3;

network = Network(r, k, l);
points = network.getUsers();
scatter(points(:, 1), points(:, 2))

