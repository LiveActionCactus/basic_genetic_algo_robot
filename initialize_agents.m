function agents = initialize_agents(gens, num_agents, num_actions, strat_len)
%INITIALIZE_STRATEGIES initialize the strategies for the agents
%
% Inputs:
% - num_agents      : number of agents
% - num_actions     : number of actions
% - strat_len       : length of strategies / how many moves in total
%
% Outputs:
% - strats          : dictionary of random initial strategies for agents
%

    agents = struct;
    
    for i= 1:num_agents
        agents(i).strat = zeros(gens, strat_len);
        strategy = randi([1, num_actions], 1, strat_len);
        agents(i).strat(1,:) = strategy;

        fitness = ones(1,gens) .* -inf;   % lower values are worse
        agents(i).gen_fitness = fitness;  % ave fitness for each generation
        agents(i).ses_fitness = 0;        % ave fitness over sessions in single generation
    end
    
end % end initialize_strategies()