load("lab3_order1_4.mat")

%plot(data)

x   =  data.InputData;
y   =  data.OutputData;

plot(data)
figure()
plot(t(1:100),x(1:100))
title("InputData")

figure()
plot(t(1:100),y(1:100))
title("OutputData")

%steady state
yss  =  0.3;
uss  =  3;

%initial conditions
uo   =  0;
yo   =  0;
t0   =  0;

%gain
k    =  (yss-yo)/(uss-uo)
yt1   = 0.632*(yss-yo)

t1   =  2.5 %where is t1=x when y=1.89
T    =  t1- t0
H1   =  tf(k, [T 1]);

%linear simulation; compara intrarea cu iesirea(afisate)
yhat = lsim(H1, x, t);


%error for 1st order
mse = 1/length(data.InputData)*sum((yhat - y).^2)

figure()
plot(t(200:500),y(200:500))
hold on
plot(t(200:500),yhat(200:500))
title("Init data vs Aprox data")


%%

load("lab3_order2_4.mat")

%plot(data)

x  =  data.InputData;
y  =  data.OutputData;

plot(data)
figure()
plot(t(1:100),x(1:100))
title("InputData")

figure()
plot(t(1:200),y(1:200))
title("OutputData")


yss  =  1.264;
uss  =  0.5;
uo   =  0;
yo   = 0;
t0   = 0;
k    =  yss/uss
%t1  =  0.632*(yss-yo)


t1  = 3.5 %where is t1=x when y=1.89
t2  = 5.95
t3  = 9.45
yt1 = 2.01
yt2 = 0.90;

%overshoot
M    = (yss - yt2)/(yt1 - yss)
tita =  log( 1 / M ) / ( sqrt(pi^2  + (log(M))^2 )  )
T0   =  t3- t1
wn   = 2 * pi / ( T0 * sqrt( 1 - tita^2 ) )

H1   = tf(k*wn^2, [1 2*wn*tita wn^2]);

%aproximation
yhat = lsim(H1, x, t);

%error for 2nd order
mse = 1/length(data.InputData)*sum((yhat - y).^2)

figure()
plot(t(200:500),y(200:500))
hold on
plot(t(200:500),yhat(200:500))
title("Init data vs Aprox data")













