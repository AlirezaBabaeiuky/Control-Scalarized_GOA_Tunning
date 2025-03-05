# Control-Scalarized_GOA_Tunning
In this repository, Multi-objective Genetic Algorithm based optimization is adopted to tune a controller. 
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
