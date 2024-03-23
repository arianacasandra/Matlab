%load data
load("lab2_01.mat")
%extract data from struct


%plot the identification 

plot(id.X,id.Y)
title("id.X and id.Y")
%error vector
MSE = [];

%multiplying values to get theta which is a polynomial
 for n = 1:20
     id_phy = [];
 for i=1 : length(id.X)
     for j=1 : n
         id_phy(i,j) = id.X(i)^(j-1); %regressor matrix
     end
 end

 theta= id_phy \ id.Y'; %parameters matrix
 yhat=id_phy*theta;

 %plot(id.X,yhat, '-r')
 

 val_phy = [];
 %for validation data to determin the error to aproximate

for i=1 : length(val.X)
     for j=1:n
         val_phy(i,j) = val.X(i)^(j-1);
     end
 end
 %theta = id_phy \ id.Y';
 val_yhat = val_phy*theta;
 
 mse = 0;
 for i=1:length(val.Y)
    mse = mse + (val.Y(i) - val_yhat(i)).^2;
 end
 MSE(n) = (1/length(val.X))*mse;
 end
 
 figure()
 plot(MSE)
 title("MSE val")
 %minerror=min(MSE)

 % search for n that is equal to minerror

[minError,indexError] =  min(MSE)
 n=indexError
 id_phy = [];
 for i=1 : length(id.X)
     for j=1 : n
         id_phy(i,j) = id.X(i)^(j-1);
     end
 end

 theta= id_phy \ id.Y';
 yhat=id_phy*theta;

 %plot(id.X,yhat, '-r')
 

 val_phy = [];
 %for validation data to determin the error to aproximate

for i=1 : length(val.X)
     for j=1:n
         val_phy(i,j) = val.X(i)^(j-1);
     end
 end

 figure()
 val_yhat = val_phy*theta;
 plot(val.X,val.Y)
 hold on
 plot(val.X,val_yhat)
 title("val.Y vs val_yhat")









 

 


 



