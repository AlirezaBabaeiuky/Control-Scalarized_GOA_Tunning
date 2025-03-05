% clc;
% clear;
% close all;

%% Problem Definition

global NFE;
NFE = 0;

% it sohuld be (, ess) instead of J 
% Sphere contains the cost function 
% CostFunction = @(x, y, J) Sphere2(x);     % Cost Function % Sphere2(x);
CostFunction = @(x, y, J) Sphere2(x);     % Cost Function % Sphere2(x);
% syntax above is: defining a function handle within main code in workspace
% at which itelf is using another fuction which is defined in a separate .m
% function. so CostFucntion is anonymous function defiend in the main code
% script in workspace, and Sphere is not anonymous and defines the main
% function in a separate .m file. 
% CostFunction is anonymous function with inputs: x, y, z; that uses
% another definitive/named (non-anonymous) function to calculate the vlaues w.r.t
% x only. 

nVar = 3%3;             % Number of Decision Variables / same as design parameters 

VarSize = [1, nVar];   % Decision Variables Matrix Size

% Choosing proper values for the ctrl gains is critical othrwise will give
% NaN 
VarMin1 = 97%500;         % Lower Bound of Variables
VarMax1 = 103%1500;         % Upper Bound of Variables
VarMin2 = 0%00;         % Lower Bound of Variables
VarMax2 = 2%250;         % Upper Bound of Variables
VarMin3 = 0%00;         % Lower Bound of Variables
VarMax3 = 1%50;         % Upper Bound of Variables

%% GA Parameters

MaxIt = 50%200;      % Maximum Number of Iterations - GA is recursive and iterative process  

nPop = 10%50;        % Population Size 

% Crossover in GA is: the process of combining genetic material from two
% parent solutions to create new offsrping. it mimics biological
% reproduction and helps explore the search space. 
pc = 0.8;                 % Crossover Percentage
nc = 2*round(pc*nPop/2);  % Number of Offsprings (Parnets)

% Mutants: in GA are the offsprings produced by applying random mutations
% to individuals in the population. This helps maintain diversity and
% prevents premature convergance. 
pm = 0.3;                 % Mutation Percentage
nm = round(pm*nPop);      % Number of Mutants: actual count of individuals undergoing mutatoin in each generation. 

gamma = 0.05; % parameter to conrol the crossover variation. It adjusts how far offspring genes deviate from parent genes during crossover.       

mu = 0.02;         % Mutation Rate: probablity of mutating each gene within an individual.  

ANSWER = questdlg('Choose selection method:', 'Genetic Algorith', ...
    'Roulette Wheel', 'Tournament', 'Random', 'Roulette Wheel');

UseRouletteWheelSelection = strcmp(ANSWER, 'Roulette Wheel'); % if user picked Roulette wheel this will be 1 stored in Use...
UseTournamentSelection = strcmp(ANSWER, 'Tournament');
UseRandomSelection = strcmp(ANSWER, 'Random');

beta = 8; % is selection pressure for Roulette Whel selection. A higher beta increases the probability of selecting fitter indivduals,
% making the algorithm mor exploitative.
% fitter individuals: solutions with lower cost (better performance) in the
% optimization problem. high beta means reducing diversity and making the
% search more conservative (exploitative) rather tahn exploratory. 
if UseRouletteWheelSelection
    beta = 8;         % Selection Pressure
end

if UseTournamentSelection
    TournamentSize = 3;   % Tournamnet Size
end

pause(0.1); % pauses the execution of the code untill the user presses any key

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];

pop = repmat(empty_individual, nPop, 1); % initialization of the population (parents in this step)

for i = 1 : nPop
   
    % Initialize Position - the below is how it starts with random numbers
    % for variable designs 
    pop(i).Position(1,1) = (rand(1)*(VarMax1- VarMin1)) + VarMin1; % rand(1) yields one single number btwn 0 and 1
    % between 0 and 1. % decimal or floating-point number is like: 2.56 
    pop(i).Position(1,2) = (rand(1)*(VarMax2- VarMin2)) + VarMin2;
    pop(i).Position(1,3) = (rand(1)*(VarMax3- VarMin3)) + VarMin3;
    
    % Evaluation
    pop(i).Cost = CostFunction(pop(i).Position); % storing in structure type when using '.'  
    
end

% Sort Population
Costs = [pop.Cost];
[Costs, SortOrder] = sort(Costs); % matlab by default sort in ascending format 
pop = pop(SortOrder);

% Store Best Solution
BestSol = pop(1); % yeilds the minimum/smallest value of cost function 

% Array to Hold Best Cost Values 
BestCost = zeros(MaxIt,1);

% Store Cost
WorstCost = pop(end).Cost;

% Array to Hold Number of Function Evaluations
nfe = zeros(MaxIt,1);

%% Main Loop

for it = 1 : MaxIt
    
    % Calculate Selection Probabilities
    P = exp(-beta*Costs/WorstCost); % recap: beta is a probability parameter  
    P = P/sum(P); % normalizing 
    
    % Crossover
    popc = repmat(empty_individual, nc/2, 2);
    for k = 1 : nc/2
        
        % Select Parents Indices
        if UseRouletteWheelSelection
            i1 = RouletteWheelSelection(P);
            i2 = RouletteWheelSelection(P);
        end
        if UseTournamentSelection
            i1 = TournamentSelection(pop, TournamentSize);
            i2 = TournamentSelection(pop, TournamentSize);
        end
        if UseRandomSelection
            i1 = randi([1 nPop]);
            i2 = randi([1 nPop]);
        end

        % Select Parents
        p1 = pop(i1);
        p2 = pop(i2); % picking only 2 parents 
        
        % Apply Crossover
        [popc(k,1).Position, popc(k,2).Position] = ...
            Crossover(p1.Position, p2.Position, gamma, VarMin1, VarMax1, ...
            VarMin2, VarMax2, VarMin3, VarMax3);
        
        % Evaluate Offsprings
        popc(k,1).Cost = CostFunction(popc(k,1).Position);
        popc(k,2).Cost = CostFunction(popc(k,2).Position);
        
    end
    popc = popc(:);
    
    % Mutation 
    popm = repmat(empty_individual, nm, 1);
    for k = 1 : nm
        
        % Select Parent
        i = randi([1 nPop]); % randi yields random integer numbers 
        p = pop(i);
        
        % Apply Mutation
        popm(k).Position = Mutate(p.Position, mu, VarMin1, VarMax1, VarMin2, VarMax2 ...
            ,VarMin3, VarMax3);
        
        % Evaluate Mutant
        popm(k).Cost = CostFunction(popm(k).Position);
        
    end
    
    % Create Merged Population / consolidate all populations:
    % main/original, crossover, mutation 
    pop = [pop
         popc
         popm];
     
    % Sort Population
    Costs = [pop.Cost];
    [Costs, SortOrder] = sort(Costs);
    pop = pop(SortOrder);
    
    % Update Worst Cost
    WorstCost = max(WorstCost, pop(end).Cost);
    
    % Truncation 
    pop = pop(1 : nPop);
    Costs = Costs(1 : nPop);
    
    % Store Best Solution Ever Found
    BestSol = pop(1);
    
    % Store Best Cost Ever Found
    BestCost(it) = BestSol.Cost;
    
    % Store NFE
    nfe(it) = NFE;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': NFE = ' num2str(nfe(it)) ', Best Cost = ' num2str(BestCost(it))]);
    
end

%% Results

figure;
plot(nfe, BestCost, 'LineWidth', 2);
xlabel('NFE', 'FontSize', 18);
ylabel('Cost', 'FontSize', 18);
grid on 
