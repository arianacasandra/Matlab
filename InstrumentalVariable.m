
load('/Users/arianaolaru/Documents/motor8.mat')
plot(U)
title("Input identification and validation")

figure()
plot(vel)
title("Output identification and validation")

uId = U(10:210);
yId = vel(10:210);

uVal = U(230:300);
yVal = vel(230:300);

val = iddata(yVal', uVal', 0.01);



theta_0 = [1;1];
THETA = [1;1];

F = theta_0(1);
B = theta_0(2);

L=0;
alpha = 0.03;
lmax = 500;
nk = 2;
delta = 1e-5;


error = zeros([1,length(uId)]);
error(1) = yId(1);
error(2) = yId(2);

derivative_error = zeros([2, length(uId)]);



while L<=lmax 
theta_0 = THETA;
F=theta_0(1);
B=theta_0(2);

for k = nk+1:length(uId)
    
        error(k) = yId(k) + F*yId(k-1) - B*uId(k-nk) - F*error(k-1);
    
   
end

%derivative_error = zeros([length(uId), 2]);

for k = nk+1:length(uId)
    derivative_error(1,k) = yId(k-1)-error(k-1)-F*derivative_error(1,k-1);
    derivative_error(2,k) = -uId(k-nk)-F*derivative_error(2,k-1);
  
end
    
%GRADIENT
G = zeros(2,1);

for k=nk+1:length(uId)
G = G + error(k)*derivative_error(:,k);

end
G = 2/(length(uId)-nk)*G;


 
 %HESIAN
H = zeros(2,2);
for k=nk+1:length(uId)
 H = H + derivative_error(:,k) .* derivative_error(:,k)';
end
 H = 2/(length(uId)-nk) * H;
 THETA = theta_0 -alpha*inv(H)*G;
 
 L=L+1;
end

ts =  10e-3;
model = idpoly(1,[zeros(1,nk) B],1,1,[1 F],0,ts);

figure()
compare(val, model)


