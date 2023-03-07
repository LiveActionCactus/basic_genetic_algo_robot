function [newstrat1, newstrat2] = reproduce(strat1, strat2)
%REPRODUCE mix two genomes plus some random mutations to create new genome
%
% Inputs:
% -strat1           : parent1 genome
% -strat2           : parent2 genome
%
% Outputs:
% -newstrat1        : new child #1 genome, mix of parents and random mutation
% -newstart2        : new child #2 genome
%
    mutation_prob = 0.05;                                %TODO: ASSUMES 5% CODON MUTATION RATE (tried 0.01 and 0.025 but got stuck)
    strat_len = length(strat1);
    slice = floor(strat_len * rand);                     %TODO: ASSUMES UNIFORM DIST FOR SPLICING OF PARENT GENOMES
    
    % Child 1
    newstrat1 = [strat1(1:slice), strat2((slice+1):end)];
    
    rand_mutations = randi([1,7], 1, strat_len);         %TODO: ASSUMES 7 ACTIONS
    rand_mask = (rand(1,strat_len) <  mutation_prob);
    
    newstrat1 = newstrat1 .* (~rand_mask);               % zero out idxs w/ mutation
    rand_mutations = rand_mutations .* rand_mask;        % zero out all idxs without mutation
    
    newstrat1 = newstrat1 + rand_mutations;              % apply random mutations

    % Child 2
    newstrat2 = [strat2(1:slice), strat1((slice+1):end)];
    
    rand_mutations = randi([1,7], 1, strat_len);         %TODO: ASSUMES 7 ACTIONS
    rand_mask = (rand(1,strat_len) <  mutation_prob);
    
    newstrat2 = newstrat2 .* (~rand_mask);               % zero out idxs w/ mutation
    rand_mutations = rand_mutations .* rand_mask;        % zero out all idxs without mutation
    
    newstrat2 = newstrat2 + rand_mutations;              % apply random mutations

end % reproduce()