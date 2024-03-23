load('date_.mat')
plot(vel)
title("Output")


figure()
plot(u)
title("Input")
x = u(50:250);
y = vel(50:250);


na = 5;
nb = 5;
N = length(y);
phy = [];
for i = 1 : N
   for j=1:na+nb
     if j<=na && i-j>0
         phy(i,j)= -y(i-j);
     elseif j<=na && i-j<=0
         phy(i,j)= 0;
     elseif j>na && i-j+na>0
         phy(i,j) = x(i-j+na);
     elseif j>na && i-j+na<=0
         phy(i,j) = 0;
     end
   
     
   end
end

theta = phy \ y';
yhat = phy*theta;

mse_id = 0;
for i=1:length(y)
    mse_id = mse_id + (yhat(i)-y(i))^2;
end
mse_id = 1/length(y)*mse_id;

figure()
plot((1:200),yhat(1:200))
hold on
plot((1:200),y(1:200))
title("Prediction on Identification")


%validation
x_v = u(350:550);
y_v = vel(350:550);
phy_val =[];
N = length(y_v);
for i=1:N
    for j=1:na+nb
          if j<=na && i-j>0
         phy_val(i,j)= -y_v(i-j);
     elseif j<=na && i-j<=0
         phy_val(i,j)= 0;
     elseif j>na && i-j+na>0
         phy_val(i,j) = x_v(i-j+na);
     elseif j>na && i-j+na<=0
         phy_val(i,j) = 0;
     end
    end
end
yhat_v = phy_val*theta;

%mse ptr val
mse_val = 0;
for i=1:length(y_v)
    mse_val = mse_val + (yhat_v(i)-y_v(i))^2;

end
mse_val = 1/length(y_v)*mse_val;

figure()
plot((1:200),yhat_v(1:200))
hold on
plot((1:200),y_v(1:200))
title("Prediction on Validation")


%simulation
y_caciuloaica = [];
for i =1:N
    sum = 0;
    for j=1:na+nb
        if i-j > 0 && j<=na
            sum = sum - theta(j)*y_caciuloaica(i-j);
        end
        if i-j+na > 0 && j>na
            sum = sum +theta(j)*x_v(i+na-j);
       
        end
    end
    y_caciuloaica(i)= sum;
    
end



figure()
plot((1:200),y_caciuloaica(1:200))
hold on
plot((1:200), y_v(1:200))
title("Simulation on validation")