function y = soft_coring(x,gamma,tau,scaling)

y = x .* (1 - exp(-((abs(x)./tau).^gamma)));
y = scaling * y;