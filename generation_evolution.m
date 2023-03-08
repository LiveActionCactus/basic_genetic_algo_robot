function new_agents = generation_evolution(agents, num_agents, gen)
%GENERATION_EVOLUTION create child generation from parents based on the
%parents average fitness in the previous sessions
%
% Inputs: 
% -agents      : parents with ave fitness from previous sessions
% -num_agents  : number of agents (strategies) in total
% -gen         : generation
%
% Outputs:
% - new_agents  : children of the agents 
%

% put fitness scores into an array
fscores = zeros(1,num_agents);
for i = 1:num_agents
    fscores(i) = agents(i).ses_fitness;
end

[elite_val, elite_idx] = maxk(fscores, 10);     % find 10 best agents & indexs
fscores = fscores + abs(min(fscores));          % make all values positive
fscores = fscores.^2;                           %TODO: trying to use square to exaggerate high fitness results
fscores = fscores ./ sum(fscores);              % normalize wrt average; maps all fitnesses -> [0,1]

cumfscores = cumsum(fscores);           % cumulative sum of fscore probabilities
new_agents = agents;                    % new_agents will be updated with new genomes
i = 1;
while i <= num_agents                          
    idx1 = find(rand<cumfscores, 1, 'first');           % chose agent genome probabilistically based on fitness scores
    idx2 = find(rand<cumfscores, 1, 'first');

    [new_agents(i).strat(gen+1,:), new_agents(i+1).strat(gen+1,:)] = reproduce(gen, agents(idx1).strat(gen,:), agents(idx2).strat(gen,:));
    i = i + 2;                                          % TODO: assumes even number of agents
end

% keep top 10 "elite" perfomers regardless
% TODO: no mutation here
for i = 1:10
    k = elite_idx(i);
    new_agents(k).strat(gen+1,:) = agents(k).strat(gen,:);
end

end % end generation_evolution()