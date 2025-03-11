# Control-Scalarized_GOA_Tunning
In this repository, Multi-objective Genetic Algorithm based optimization is adopted to tune a controller. 
---
Optimization techniques like Genetic-based algorithms derive the Genetic operations to yield the optimal result in a given optinmzation problem. 
In the realm  of controller tunning, finding the most optimal / optimum gains is of main concern. While, trial-error can be used here, it is tried to establish a standard way-of-working in this field to tune the controller gains. 
For a controller from performance perspective, there are usually the following items ti be considered:
1- rise time (time it takes for the controller to reach its 95%-98% of its final value and stay in this region) for the first time. 
2- peak time (time it takes for the controller to reach the peak value fter a suddent change in the input) in the response.
3- setling time (time it takes for the controller to reach to the steady-state and stay within either 95% or 98% of the input value) - more used in performance specification / requirement deifnitions 
4- Maximum peak overshoot (maximum value the controller reaches to, due to a change in the input). usually systems with internal dynamics triggered (excited natural freuquencies) show a Mp as Transient response. 
5- ess (steady-state error or offset) - which is the difference between the input and the response. - this is a good metrics for hte precision of the controller in reference tracking 
6- controller effort - is important in terms of: used/required energy/electricity, large control effort can lead to saturation in actuators or nonlinear control signals 
7- stability margins - phase and gain in Bode criteria and disk margin in Nyquist - complementary layer to stability is robustness 0 e.g., a maximum peak overshoot shows NON_Robust behavior (due to an intenral or external distrubance sys can easily become unstable).
8- Sensitivity -> S+T=1; meaning how sensitive is the system to noise, to plant disturbances ...; S = 1/ (1+C*P);  -> high sensitivity means Aggreeeive controller and less Robust. 
9- BandWidth (BW) -> is a measure of how fast the system is in tracking any changes in the input. high BW usually is desired meaning up to which frequency the contrller can track the input well enough. 
BW is the crossover frequency at which the magnitude crossses 0 dB or -3 dB. Here is a bit of cnfusion between BW versus stability (Bode criteria); positive gain is a bit dangerous for stability (if the cprresponding phase is below -180 we are UNSTABLE!). 
But as long as the phase is bigger than the -180 degrees, even positive magnitude is safe. and phase shift usually happens at higher frequnecies. so having high gain at LF secures good BW while not encountering stability risks. at BW cross freq. the ratio of the signal over thesecond one is almost half meaning 70% in dB.  
Sensitivity, BW, stability are more of frequency response analysis; while the rest is of more of time-domain response analysis. 
Using Geneti calgorithm (scripted the entire Genetic Optimization Algorithm in MATLAB without using any built-in functions), SMC and PID control gains are tuned to minimze the steady-state error. 
Multi-objective optimization problems are essentially opimization problems where there are multiple objectives to meet and usually such objectives are conflicting goals. In such a case trade-off methods are adopted. 
In the discipline of optimization, Pareto solutions and Scalarized methods are common. I have scripted a Fractional-Order Quadratic Objective function to be optimized by Genetic algorithms: (check the Sphere2.m) 
Scalarized Quadratic optimization is a type of multi-objective problem at which the importance of each objective function is prioritized with respect to the given weights. I prioritized the ess (offset) more than the MP (overshoot); so W_ess = 2 and W_Mp = 1; 
Also one important note is that since the ess is alsways a number between 0 and 1 (with 0 the ideal case), fractional-order quadratic is adopted instead of regular quadratic optimization. If regular quadratic is used, the performance index (objective function) will
ignore/underestimate the importance of the ess or Mp. (0.5^2=0.25 but 0.5^1/2=0.707107).  
Maxiumum iteration of the GA is set to 50 (bigger numbers lead to computational costs), and population size of the GA is set to 20. Mutation ratio is 0.2 (meaning a conservative search) and Crossover ratio us set to 0.8 meaning to roughly reduce the 
generated offsprings less than the regular size of the parents population. 
Sphere2.m which holds the Named separate matlab function contains the simulink file that runs the simulations to evaluate the response of the system. Basically, the Genetic Optimization sub-functions and main function are all connected to the simulink file. 
![image](https://github.com/user-attachments/assets/402e1a98-dceb-4980-b3ac-108d58255f02)
above figure shows the Genetic Optimization Algorithm's search pattern and how it has evolved through over 550 evaluations to find the mnimum scalarized multi-objective function. 
Crossover percentage = 0.8; Crossover in GA is the process of combining Genetic material from 2 parents to create new offspring. It mimics biological reproduction and helps in exploring the search space. 
Original population size = 50, and with Crossover percentage of: 0.8; it will yield 40 foe next population sizes. 
Mutation percentage is = 0.3; Mutants are the offsprings produced by applying random mutations to individuals in the population. This helps in maintaining diversity and prevents premature convergence.
Gamma = 0.05; this is crossover rate; is the parameter to control the crossover variation. It adjusts how far offspring genes deviate from parent genes during crossover.   
Mu = 0.02; this is mutation rate; it adjusts the probability of mutating each gene within an individual. 
Maximum iteration considered for this Scalarized-Genetic_/algorithm-Optimization is: 100
Obviously larger numbers lead to more computational costs. Best approach is to do several trial-errors to find the best achievable PID control gains, then feed 30% below and above such numbers as Variable limits to the Genetic optimization algorithm to find the best in between. 
Among different selections of Genetic algorithms, I have adopted Tournament type. GA selection approach is to select the TWO parents to start off with.   





