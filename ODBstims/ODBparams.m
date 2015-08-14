function par = ODBparams(kind)
% Change these parameters if you want other stimuli
% The program creates a 2D space with Ndim^2 stimuli

% w=frequencies
% A=amplitudes
% P=phases
% step=dimensionalsteps

if nargin==0
    kind='balls';
end

% BALLS
params.balls.w=		[0.55	1.11	4.94	3.39	1.54	3.18	0.57];
params.balls.A=		[20.34	2.00	18.83	24.90	2.00	15.38	21.15];
params.balls.P=		[3.20	3.64	2.79	3.86	3.51	0.34	1.08];
params.balls.step=	[0		6.00	0		0		6.00	0		0];

% FETUS
params.fetus.w=		[1.79	2.65	2.82	4.66	1.67	1.13	2.65];
params.fetus.A=		[5.97	2.00	1.30	10.60	2.00	11.60	16.00];
params.fetus.P=		[1.88	1.79	6.21	3.24	2.72	4.78	1.31];
params.fetus.step=	[0		5.17	0		0		6.00	0		0];

% STAR NOSED MOLE
params.snm.w=		[1.92	1.73	4.82	7.33	2.57	2.11	2.77];
params.snm.A=		[22.50	2.00	1.68	15.00	2.00	19.20	7.30];
params.snm.P=		[4.65	3.99	5.94	1.59	4.60	0.45	5.39];
params.snm.step=	[0		6.00	0		0		3.44	0		0];

% CATERPILL
params.cater.w=		[1.29	3.48	0.82	5.34	2.11	1.96	1.83];
params.cater.A=		[29.00	2.00	16.40	18.40	2.00	16.30	11.30];
params.cater.P=		[4.18	0.06	2.70	4.32	5.38	2.90	2.59];
params.cater.step=	[0		6.00	0		0		5.18	0		0];

% PEANUT
params.peanut.w=		[0.00	1.70	0.00	0.00	2.11	0.00	0.00];
params.peanut.A=		[0.00	10.00	0.00	0.00	10.00	0.00	0.00];
params.peanut.P=		[0.00	3.00	0.00	0.00	5.38	0.00	0.00];
params.peanut.step=   	[0		6.00	0		0		4.97	0		0];

% TEST
params.test.w=		[0.00	1.70	0.00	0.00	2.11	0.00	5.00];
params.test.A=		[0.00	5.00	0.00	0.00	10.00	0.00	11.00];
params.test.P=		[0.00	3.00	0.00	0.00	5.38	0.00	3.00];
params.test.step=  	[0		7.00	0		0		8.97	0		0];

par = params.(kind);
