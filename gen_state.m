function state = gen_state(map, pos)
%GEN_STATE generate current agent state for mapping to action. this is done
%left->right: north, south, east, west, current
%
% Inputs:
% - map        : map agent is moving around in
% - pos        : current position
%
% Outputs:
% - state      : current state
%

    [m,n] = size(map);      % m is vertical size, n is horizontal size
    
    state = "";
    
    % assign up
    if (pos(1)-1) <= 0
        state = state + string(2);
    else
        state = state + string( map( (pos(1)-1), pos(2) ) );
    end

    % assign down
    if (pos(1)+1) > m
        state = state + string(2);
    else
        state = state + string( map( (pos(1)+1), pos(2) ) );
    end
    
    % assign right
    if (pos(2)+1) > n
        state = state + string(2);
    else
        state = state + string( map( pos(1), (pos(2)+1) ) );
    end
    
    % assign left
    if (pos(2)-1) <= 0
        state = state + string(2);
    else
        state = state + string( map( pos(1), (pos(2)-1) ) );
    end
    
    % assign current
    state = state + string( map( pos(1), pos(2) ) );

end % end gen_state()