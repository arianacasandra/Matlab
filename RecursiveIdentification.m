clear all;clc;
utstart('8')
u = [zeros(50, 1);0.7 + (-0.8-0.8).*rand(300,1);zeros(50,1); 0.3*ones(70,1)];

[vel, t, alpha] = run(u, '8');
%%
load('/Users/arianaolaru/Downloads/L9_OlaruAriana_DataSet.mat')



plot(u)
title("Input id and val")

figure()
plot(vel)
title("Output id and val")

uId = u(10:310)';
uVal = u(329:400)';

yId = vel(10:310)';
yVal = vel(329:400)'; 

ts = 0.01;
id = iddata(yId, uId, ts);
val = iddata(yVal, uVal, ts);

na = 6;
nb=na;
nk = 1;
model = arx(id,[na nb nk]);
figure()
compare(model,id)
yhat = compare(model,id);
yhat1 = yhat.OutputData;



A = model.A;
B = model.B;


theta = zeros(length(A)-1, 2);
theta(:,1) = A(2:end)';
theta(:,2)= B(2:end)';

%Z
Z = [];
for i = 1 : length(uId)
   for j=1:na+nb
     if j<=na && i-j>0
         Z(i,j)= -yhat1(i-j);
     elseif j<=na && i-j<=0
         Z(i,j)= 0;
     elseif j>na && i-j+na>0
         Z(i,j) = uId(i-j+na);
     elseif j>na && i-j+na<=0
         Z(i,j) = 0;
     end
   
     
   end
end

%phy
phy = [];
for i = 1 : length(uId)
   for j=1:na+nb
     if j<=na && i-j>0
         
         phy(i,j)= -yId(i-j);
     elseif j<=na && i-j<=0
         
         phy(i,j)= 0;
     elseif j>na && i-j+na>0
         
         phy(i,j) = uId(i-j+na);
     elseif j>na && i-j+na<=0
         
         phy(i,j) = 0;
     end
   
     
   end
end


    y_caciula = [];
for i = 1:(na+nb)
    x=0;
    for k = 1: 300
    x = x+Z(k,i)*yId(k);
    end
    y_caciula(i) = 1/300 * x;
end

    phy_caciula = [];
for i = 1:na+nb
    for j=1:na+nb
        x = 0;
        for k = 1: 300
        x = x+Z(k,i)*phy(k,j)';
        end
         phy_caciula(i,j) = 1/300 * x;
    end
   
    end
    theta3 = phy_caciula\y_caciula(1:na+nb)';

   
    A2 = theta3(1:na)';
    B2 = theta3(na+1:na+na)';

    for i=na+1:-1:2
        A2(i)=A2(i-1);
    end
   A2(1)=1;

    for i=na+1:-1:2
        B2(i)=B2(i-1);
    end
   B2(1)=0;
    
    
    



modeliv = idpoly(A2,[zeros(1,nk) B2],1,1,1,0, ts)
figure()
compare(modeliv, val)

