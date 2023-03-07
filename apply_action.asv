function [itr_map, new_pos, reward] = apply_action(itr_map, pos, act_idx)
%APPLY_ACTION apply the agent's learned state->action mapping and determine
%reward
%
% Inputs:
% - map         : map with rewards and walls
% - pos         : current position of agent
% - 
%
% Outputs:
% - new_pos     : new position of the agent
% - reward      : reward as a result of the action take
%

% == 7 actions ==
% 1: move up
% 2: move down
% 3: move right
% 4: move left
% 5: random movement
% 6: stay
% 7: pick up reward

    [m,n] = size(itr_map);      % m is vertical size, n is horizontal size

    % if random movement, change act_idx to 1-4 
    if isequal(act_idx, 5)
        act_idx = randi([1,4]);
    end
    
    if isequal(act_idx, 1)      % move up
        if (pos(1)-1) <= 0      % crash into wall
            new_pos = pos;
            reward = -5;        
        else
            new_pos = [pos(1)-1, pos(2)];
            reward = 0;
        end
    elseif isequal(act_idx, 2)  % move down
        if (pos(1)+1) > m       % crash into wall
            new_pos = pos;
            reward = -5;        
        else
            new_pos = [pos(1)+1, pos(2)];
            reward = 0;
        end
    elseif isequal(act_idx, 3)  % move right
        if (pos(2)+1) > n       % crash into wall
            new_pos = pos;
            reward = -5;        
        else
            new_pos = [pos(1), pos(2)+1];
            reward = 0;
        end
    elseif isequal(act_idx, 4)  % move left
        if (pos(2)-1) <= 0      % crash into wall
            new_pos = pos;
            reward = -5;        
        else
            new_pos = [pos(1), pos(2)-1];
            reward = 0;
        end
    elseif isequal(act_idx, 6)  % stay
        new_pos = pos;
        reward = 0;
    elseif isequal(act_idx, 7)  % pick up reward
        new_pos = pos;
        if isequal( itr_map(pos(1), pos(2)), 1 )    % reward at position
            reward = 10;
            itr_map(pos(1), pos(2)) = 0;            % delete reward off map if successfully picked up
        else
            reward = -1;
        end
    
    end % end check outcome of each action

end % end apply_action()