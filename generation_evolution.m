function new_agents = generation_evolution(agents, num_agents)
%GENERATION_EVOLUTION create child generation from parents based on the
%parents average fitness in the previous sessions
%
% Inputs: 
% - agents      : parents with ave fitness from previous sessions
%
% Outputs:
% - new_agents  : children of the agents 
%

% put fitness scores into an array
fscores = zeros(1,num_agents);
for i = 1:num_agents
    fscores(i) = agents(i).ses_fitness;
end

[elite_val, elite_idx] = maxk(fscores, 10);
fscores = fscores + abs(min(fscores));  % make all values positive
fscores = fscores.^2;                   %TODO: trying to use square to exaggerate high fitness results
fscores = fscores ./ sum(fscores);      % normalize wrt average; maps all fitnesses -> [0,1]

cumfscores = cumsum(fscores);           % cumulative sum of fscore probabilities
new_agents = agents;                    % new_agents will be updated with new genomes
i = 1;
while i <= num_agents                          
    idx1 = find(rand<cumfscores, 1, 'first');           % chose agent genome probabilistically based on fitness scores
    idx2 = find(rand<cumfscores, 1, 'first');

    [new_agents(i).strat, new_agents(i+1).strat] = reproduce(agents(idx1).strat, agents(idx2).strat);
    i = i + 2;                                          % TODO: assumes even number of agents
end

% keep top 10 "elite" perfomers regardless
% TODO: no mutation here
for i = 1:10
    k = elite_idx(i);
    new_agents(k).strat = agents(k).strat;
end

end % end generation_evolution()