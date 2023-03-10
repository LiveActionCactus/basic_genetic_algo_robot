function agent = run_session(gen, ses_itr, map, agent, num_moves)
%RUN_SESSION run one session on all agents. This is map dependent.
%
% Inputs:
% -gen                 : generation number
% -ses_itr             : session numer in generation
% -map                 : map of rewards and obstacles
% -agents              : agent structs with strategies
%
% Outputs:
% -agent              : return agent strategies with updated ave fitness
%

    for i = 1:length(agent)
        itr_map = map;
        pos = [1,1];        % agent starting position
        fitness = 0;
    
        for k = 1:num_moves
            state = gen_state(itr_map, pos);
            state_idx = base2dec(state,3)+1;          % +1 bc matlab base 1
            act_idx = agent(i).strat(gen, state_idx);
            [itr_map, pos, reward] = apply_action(itr_map, pos, act_idx);
            fitness = fitness + reward;               % single sim fitness  

        end % end for each move

        agent(i).ses_fitness = ( (fitness + (ses_itr-1)*agent(i).ses_fitness) / ses_itr);     % cumulative average fitness for generation

    end % end for each agent

end % end run_session()