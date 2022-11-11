%% Illustrative Test

r = 3;
k = 200;
l = 3;

network = Network(r, k, l);
points = network.getUsers();
scatter(points(:, 1), points(:, 2))

%% Realistic Test

r = 3;
k = 4;
l = 7;

network = Network(r, k, l);
points = network.getUsers();
scatter(points(:, 1), points(:, 2))

