%% building the input signal
clear all;
N=200;
a=-0.7;
b=0.7;
m=3;
u=[zeros(10,1);input_generator(N,m,a,b);zeros(10,1);input_generator(N,10,a,b);zeros(10,1);0.4*ones(70,1)];
plot(u)
%% generate the outputs
utstart('6')
[vel, alpha, t] = run(u, '6', 1e-2);
plot(t, vel);
%% isolate the data
xid_1=u(10:210);
xid_2=u(220:420);
x_val=u(424:500); 

yid_1=u(10:210);
yid_2=u(220:420);
y_val=u(424:500); 
%% finding arx for m=3
ts = 0.01;
m=3;

Na=20;
Nb=20;
Nk=1;
%NN=struc(Na, Nb, Nk);
id1 = iddata(yid_1,xid_1, ts);
val = iddata(y_val, x_val,ts);
id2 = iddata(yid_2,xid_2,ts);
%%
%V=arx(id1, val,NN);
%fit = selstruc(V,0);
mdl1 = arx(id1,[Na,Nb,Nk]);


%figure()
P1 = 2^m-1;
PE1 = P1;

%finding arx for m=10
m=10;
mdl2 = arx(id2,[Na,Na,Nk]);
compare(mdl1,mdl2, val)
P2 = 2^m-1;
PE2 = P2;
 %%
function [PE,signal] = input_generator(N,m,a,b)
        
    mask=zeros(1,m);
    switch(m)
        case 3
            mask(1)=1;
            mask(3)=1;
        case 4
            mask(1)=1;
            mask(4)=1;
        case 5
            mask(2)=1;
            mask(5)=1;
        case 6
            mask(1)=1;
            mask(6)=1;
        case 7
            mask(1)=1;
            mask(7)=1;
        case 8
            mask(1)=1;
            mask(2)=1;
            mask(7)=1;
            mask(8)=1;
        case 9
            mask(9)=1;
            mask(4)=1;
        case 10
            mask(3)=1;
            mask(10)=1;
    end
            

    
     for i=1:m
         Matr(1,i)=mask(i);
     end


     for i=2:m
         for j=1:m
             if i==j+1
                 Matr(i,j)=1;
             else
                 Matr(i,j)=0;
             end
         end
     end

     z =  zeros(m,1);
     z(m) =  1;

     signal=zeros(N,1);


      for i=1:N
          copy = Matr*z;
          z1= mod(copy,2);
          signal(i)=z1(m);
          z=z1;
      end

      singal=a+(b-a)*signal;
end
