% generation - formed by reproduction of best fitness agents from prev gen
% fitness - total reward/cost of agent as a result of strategy; average
% multiple sessions
% genome - encodes a strategy for the agent to follow
% gene - action to take in a specific state; subset of genome
% session - single run of agent where a fitness is calculated at the end
% population - number of agents (strategies)


% TODO
% - [DONE] generate map; boarders; trash to pickup; obstacles
% - [DONE] generate random initial strategies
% - [DONE] run session
% - [DONE] calculate fitness of session for each agent in population
% - [DONE] calculate average fitness for each strategy/genome in generation
% - [DONE] apply evolution
% - [DONE] plot results
%
% pop size - 200                    % number of strategies to maintain and
%                                   reproduce from.
%
% num generations - 1000            % number of times to generate offspring
%                                   via parent reproduction and fitness
%                                   scores.
%
% genome size - 243 (state-space)   % completely determined by agent
%                                   visibility and map complexity.
%
% ave fitness - 100 itrs            % higher iterations to average over
%                                   give more stable training.
% 
% map size - 10 x 10              % self-explanatory
%
% elite agents - 10                 % currently hard-coded into
%                                   "generation_evolution.m"
%

%
% Recommendations:
% - run a smaller map as a ratio of number of moves and percent rewards.
% - either lower the mutation rate or sunset it as a fcn of generation.
% - bump up the ave fitness, this has a big impact on stability of the
% strategies over the generations.
%
% TODO: track strategies over generations and plot via imagesc to see
% action evolution

clear all
close all

%% sim properties
map_dim = 10;           % length of one side of square map
reward_prob = 0.5;      % probability of square containing reward
obstacle_prob = 0.0;    % probability of square containing obstacle
generations = 1000;     % number of generations to run
num_moves = 200;        % number of moves each agent can make in single session
num_fit_ave = 100;      % number of sessions to run to get ave fitness (different maps each time)
num_agents = 200;       % population size
len_genome = 243;       % complete state-space (3^5)
num_actions = 7;        % move up, move down, left, right, rand, stay, pick up

%%
% seed optimizer
map = generate_map(map_dim, reward_prob, obstacle_prob);                        % map side len, prob reward, prob obstacle
agents = initialize_agents(generations, num_agents, num_actions, len_genome);   % assign random strategy and ave fitness vector

% run genetic optimizer
for i = 1:generations

    % run sessions in single generation to find ave fitness of each genome 
    for j = 1:num_fit_ave
        agents = run_session(i, j, map, agents, num_moves);                        % update agent fitness scores based of map-dependent performance
        map = generate_map(map_dim, reward_prob, obstacle_prob);                % generate new random map

    end % end single generation sessions
    
    % assign generational fitness for logging purposes
    max_fitness = -inf;                                     % for sanity check and trouble shooting
    for k = 1:num_agents
        agents(k).gen_fitness(1,i) = agents(k).ses_fitness;
        
        if agents(k).ses_fitness > max_fitness              % for sanity check and trouble shooting
            max_fitness = agents(k).ses_fitness;
        end
    end

    % apply evolution; create children for next generation
    agents = generation_evolution(agents, num_agents, i);

    fprintf('Generation: %i complete; Max fitness: %d \n', i, max_fitness);

end % end generational optimizer


%% Save information
save('itr_run.mat', 'agents', 'genfitness_prog', 'generations', 'len_genome', 'map_dim', 'num_actions', 'num_actions', 'num_agents', 'num_fit_ave', 'num_moves', 'obstacle_prob', 'reward_prob');

%% Post-processing

% put agents' generational fitness arrays into matrix
genfitness = zeros(num_agents, generations);
for i = 1:num_agents
    genfitness(i,:) = agents(i).gen_fitness;            % compile generational fitness scores into single matrix
end

genfitness_prog = max(genfitness);      % find best agent fitness for each generation
last_val = find((genfitness_prog > -inf), 1, 'last');
[max_vals, max_itrs] = maxk(genfitness(:,last_val), 10);     % TODO: hardcoded last trained generation (280)

%% Plotting max value vs iterations

figure()
plot(genfitness_prog)
title("Best agent fitness over generations")
xlabel("Generation")
ylabel("Fitness")
%axis([0 1000 -1000 1000])

%% Plot top 10 values vs iterations
figure()
hold on
for i = 1:10
    plot(genfitness(max_itrs(i), 1:last_val))                % TODO: hardcoded last trained generation (280)
end
title("Top 10 agent fitness over generations")
xlabel("Generation")
ylabel("Fitness")

%% Run top strategy 10000 times; find ave fitness

best_ave_fitness = 0;                                                   % keep track of average fitness during evaluation
a = max_itrs(1);                                                        % best agent # via average fitness %TODO: programmatically assign this
for i = 1:10000                                                         % number of forward sims to run on optimal strategy
    itr_map = generate_map(map_dim, reward_prob, obstacle_prob);        % side length, probability reward, probability obstacle
    pos = [1,1];                                                        % agent starting position
    fitness = 0;

    for k = 1:num_moves
        state = gen_state(itr_map, pos);
        state_idx = base2dec(state,3)+1;          % +1 bc matlab base 1
        act_idx = agents(a).strat(last_val, state_idx);
        [itr_map, pos, reward] = apply_action(itr_map, pos, act_idx);
        fitness = fitness + reward;               % single sim fitness
    end % end for each move

    best_ave_fitness = ( (fitness + (i-1)*best_ave_fitness) / i);     % cumulative average fitness for generation
end

%% Generate real-time and time-lapse plots for media purposes

best_ave_fitness = 0;                                                   % keep track of average fitness during evaluation
a = max_itrs(1);                                                        % best agent # via average fitness %TODO: programmatically assign this
                                                   % number of forward sims to run on optimal strategy
itr_map = generate_map(map_dim, reward_prob, obstacle_prob);        % side length, probability reward, probability obstacle
pos = [1,1];                                                        % agent starting position
fitness = 0;

% plot map of agent picking up rewards
orig_map = uint8(itr_map)*6;     % original map for update
timelapse_map = uint8(itr_map)*6;     % time-lapse map
plot_map = uint8(itr_map)*6;     % plotting map + agent motion
figure()
m = image(plot_map);
colormap(jet(12));      % 0 - dark blue; 6 - light green (reward) ; 10 - red (agent)
m.CData(pos(1),pos(2)) = 10;
title("Agent w/ genetic opt control law")

for k = 1:num_moves
    pause
    state = gen_state(itr_map, pos);
    state_idx = base2dec(state,3)+1;          % +1 bc matlab base 1
    act_idx = agents(a).strat(last_val, state_idx);
    
    if isequal(act_idx,7)                     % if picking up reward, make square look picked up
        orig_map(pos(1),pos(2)) = 0;
    else
        m.CData(pos(1),pos(2)) = orig_map(pos(1),pos(2));
    end
    
    [itr_map, pos, reward] = apply_action(itr_map, pos, act_idx);
    fitness = fitness + reward;               % single sim fitness

    timelapse_map(pos(1),pos(2)) = 10;
    m.CData(pos(1),pos(2)) = 10;                    % plot new agent position;
end % end for each move

%%
figure()
tl = image(timelapse_map);
colormap(jet(12));
title("Overlay of agent path")
