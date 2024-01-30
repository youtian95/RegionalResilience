
# RegionalResilience
You T, Wang W, Tesfamariam S. Effects of self-centering structural systems on regional seismic resilience. Engineering Structures, 2023, 274: 115125.

## Dependancy
* python lib
pandas, tqdm, numpy, openseespy, eqsig, matplotlib
 
## Tutorial

* Step 1. Set global parameters.
run ./assessment/Main_Parameters.m

* Step 2. Plot city.
run ./assessment/Main_plotCity.m

* Step 3. Perform IDA for each building.
run ./assessment/IDA.m
Results are saved in IDA_results.

* Step 4. Monte-Carlo simulations of intensity fields and Regional seismic losses.
run ./Main_RegionalAssessment_PSPA.m

* Step 5. Post-earthquake Recovery.
run ./Main_Recovery.m