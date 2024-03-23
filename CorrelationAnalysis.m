load('lab4_order1_3.mat')

x = data.InputData;
y = data.OutputData;


plot(data)
figure()
plot(t(1:100),x(1:100))
title('Input of 1st Order')
figure() 
plot(t(1:100),y(1:100))
title('Output of 1st Order')


uss =1.5;
yss  =7.55;
y0 = yss;
k=yss/uss;
ymax = 9.08;
yt1 = yss+0.368*(ymax-y0);
t1 = 7.44;
t2 = 10.03 ;
T = t2- t1;


A = -1/T;
B = k/T;
C = 1;
D = 0;

%init condition
x0 = y0;
%space state
H  = ss(A,B,C,D);

%linear simulation with init condition
yhat = lsim(H, x, t, x0);

%error
mse = 1/length(x)*sum((yhat - y).^2)


figure()
plot(t(100:300),y(100:300))
hold on
plot(t(100:300),yhat(100:300))
title("Init data vs Aprox data of 1st Order")
%%
load('lab4_order2_3.mat')

x = data.InputData;
y = data.OutputData;


plot(data)
figure()
plot(t(1:100),x(1:100))
title('Input 2nd Order')
figure() 
plot(t(1:100),y(1:100))
title('Output 2nd Order')


uss = 0.5;
yss = 0.1;
y0 = yss;

%gain
k=yss/uss;

t1= 5.2;
t2 = 9.6;
t3 = 12.8;

T = t3-t1;

%sample time
ts = 0.13;

t00 = 3.86;
t01 = 7.97;
t02 =11.1;
k00 = t00/ts;
k01 = t01/ts;
k02 = t02/ts;

index_k00 = 29;
index_k01 = 61;
index_k02 = 85;

A_plus = 0;

for i = index_k00:index_k01
 A_plus = A_plus+y(i)-yss 
end

A_minus = 0;

for i = index_k01:index_k02
 A_minus = A_minus+ yss - y(i)
end


M= A_minus / A_plus;
tita = log(1/M)/sqrt(pi^2+log(M)^2)
wn = 2*pi/(T*sqrt(1-tita^2))


A = [0 1; -wn^2 -2*tita*wn];
B = [0; k*wn^2];
C = [ 1 0 ];
D = [0];

%space state
H = ss(A,B,C,D);

%linear simulation with init cond
yhat = lsim(H,x,t,[y0 0])

%error
mse = 1/length(x)*sum((yhat - y).^2)


figure()
plot(t(100:300),y(100:300))
hold on
plot(t(100:300),yhat(100:300))
title("Init data vs Aprox data of 2nd Order")