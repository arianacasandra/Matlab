load("lab5_5.mat")

xId=id.InputData;
yId=id.OutputData;
xVal=val.InputData;
yVal=val.OutputData;

%zero mean or not

plot(tid,xId);
figure()
plot(tid,yId);
figure()

x=detrend(xId);
y=detrend(yId);

plot(tid,x);
figure()
plot(tid,y);
figure()

%T = cat e length(yId)
T=length(yId);

%covariation ru
suma = [];
for tau=0:length(yId)-1
  sum = 0;
    for k=1:T-tau
        sum = sum + x(k+tau)*x(k);
  end
  suma(tau + 1) = 1/T*sum;
end

%covariation ryu
suma_ryu=[];
for tau=1:length(yId)
 sum=0;
 for k=1:T-tau
    sum=sum+y(k+tau)*x(k);
 end
 suma_ryu(tau)=1/T*sum;
end


M = 40;
R = [];
for i=1:T
    for j=1:M
        R(i,j) = suma(abs(i-j)+1);
    end
end

H=R\suma_ryu';

yhat = conv(H,x);
mse = 0;
for i=1:2500
    mse = mse+(yhat(i) - y(i)).^2;
end
mse = 1/2500*mse

yhat_val = conv(H,xVal);
mse_val = 0
for i=1:250
    mse_val = mse_val+(yhat_val(i) - yVal(i)).^2;
end
mse_val = 1/2500*mse


plot(tid,y)
title("Out vs Aprox ID")
hold on
plot(tid,yhat(1:2500))
figure()

plot(tval,yVal)
title("Out vs Aprox VAL")
hold on
plot(tval,yhat_val(1:250))
