function map = generate_map(m_dim, per_reward, per_obs)
%GENERATE_MAP generate square map for agents to move around on
%
% Inputs:
% - m_dim       : map dimension (assume square) 
% - per_reward  : percent of tiles w/ rewards
% - per_obs     : percent of tiles w/ obstacles
%
% Outputs:
% - map         : m_dim x m_dim matrix w/ rewards and obstacles
%

    rand_m = rand([m_dim, m_dim]);        % generate baseline probabilities
    
    m_obs = rand_m;
    m_obs(m_obs <= per_obs) = inf;        % apply obstacles
    m_obs(m_obs < inf) = 1;               % prepare mask
    
    m_rew = rand_m;
    m_rew(m_rew <= per_reward) = 1;       % apply rewards
    
    map = m_rew .* m_obs;                 
    map((map < 1)&(map > 0)) = 0;         % clean  up map

end % end generate_map