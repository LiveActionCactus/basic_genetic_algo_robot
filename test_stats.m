% test sampling from list of probabilities

clear all
close all

X = [1, 2, 5, 9];
P = [0.1, 0.3, 0.4, 0.2];

itrs = 10000;

results = zeros(1,itrs);
for i = 1:itrs
    results(i) = find(rand<cumsum(P),1,'first');
end

histogram(results,itrs)