%
%   This program computes 
%    1) the 4 summary statistics
%    2) the geometric meanskew

%    3) some functions of interest
%    4) a test of normality  
%    5) maximum drawdown, etc

load SP500.dat             %  load the data: monthly returns from January 1934 to December 2011, 78*12=936 rows
                           %  downloded from WRDS CRSP

T=936;
Dates=SP500(1:T,1);       % column vector of the dates
Return=SP500(1:T,2);      % column vector of the returns
 
    %%%%%%%   Compute the mean return (we can use function mean(Return), but here
    %%%%%%%              to illustrate the programming, we do it from scratch
    
mu=0;                 % initialize it be zero
for i=1:T,
    mu=mu + Return(i);         % sums the returns successively
end;
mu=mu/T;              % take the average


    %%%%%%%   Compute the variance (we can use function var(Return,1), but here
    %%%%%%%              to illustrate the programming, we do it from scratch
    
sig2=0;                 % initialize it be zero
for i=1:T,
    sig2=sig2 + (Return(i)-mu)*(Return(i)-mu);         % sums the terms successively
end;
sig2=sig2/T;              % take the average, then we get the variance.
                     % some stats books recommend devided by (T-1), that is to get 
                     % anunbiased estimator. By T here for simpliciy, and theoretically, 
                     % it is the moment estimator and make little difference numerically. 

sigma=sqrt(sig2);       %  the standard deviation or volatility

SharpeRatio=mu / sqrt(sig2);      % if the riskfree rate is zero.

          % What is the true Sharpe Ratio based on the riskfree rates from July 1926  % to Dec 2010 ?
 
load Riskfree.dat;                  % downloaded from Ken French's website. 
Rates=Riskfree(1:T,5);
ExReturn=Return - Rates/100;   % the rates are in percenatges, so they have to be divided by 100 to get the decimal form.
mu1=mean(ExReturn);
sig21=var(ExReturn);
SharpeRatio1=mu1 / sqrt(sig21);  % Excess return/std( Excess return),  the Sharpe ratio based on data from July 1926  % to Dec 2010

    %%%%%%%   Compute the skewness and kurtosis (we can use functions  skewness(Return) and kurtosis(Return), but here
    %%%%%%%              to illustrate the programming, we do it from scratch
    
skew=0;                 % initialize it be zero
kurt=0;
for i=1:T,
    skew=skew + (Return(i)-mu)^3;         % sums the terms successively
    kurt=kurt + (Return(i)-mu)^4;
end;
skew=( skew/ sigma^3 ) / T;              % take the average
kurt=( kurt/ sigma^4 ) / T;  

    %%%%%%%   Compute the autocorrelation
    
sum=0;                 % initialize it be zero
for i=2:T,
    sum=sum + (Return(i)-mu)*(Return(i-1)-mu); 
end;
sum=sum/(T-1);

rho=sum/sig2;

%%%%%%%   Compute the wealth

Wealth=1;
for i=1:T,
    Wealth=Wealth*(1+Return(i));
end;
    
Wealth1=1;
for i=1:T,
    Wealth1=Wealth1*(1+Rates(i)/100);
end;

    
    %%%%%%%   Compute the geometric mean
 
gmu=1;                 % initialize it be 1
for i=1:T,
    gmu=gmu*(1+Return(i));         % multiply the gross returns successively
end;
wealth=gmu;
gmu=gmu^(1/T) - 1 ;              % take the root, etc

           %%  The average return of SP500 is much greater than the
           %%  riskfree rates, how does a portfolio of them help perform in terms of return, risk, the
           %%  Sharp ratio? The accumulative return/value ?
 
 A1=mean(Return);
 A2=mean(Rates)/100;          
     
         %%%%%%%   Compute the 95% confidence for the skewness and kurtosis
    %  Note first the 95% interval of the normal is [-1.96, 1.96],
    %  which can be computed by:   x=norminv([0.025 0.975],0,1)
    
 skewA=-1.96*sqrt(6/T);
 skewB=1.96*sqrt(6/T);
 
 kurtA=-1.96*sqrt(24/T)+3;
 kurtB=1.96*sqrt(24/T)+3;

      % Q1:    Percentage of up days:
     
 Up=0;
 for i=1:T,
    if Return(i)>0, 
        Up=Up+1;
    end
end

 Udays=Up/T;

           % Q2:    What is the accumulative returns/Value of investing 
          %$1 if we miss 5% of the best return month ?
               %  assuming earning the average riskfree rate of 4%/12
               % in those missing month                        
                        
ReturnS=sort(Return);   % sort the returns in increasing order
T1=0.05*T;
T1=round(T1);     % round the number to an integer

Value1=1;
for i=1:(T-T1),
    Value1=Value1*(1+ReturnS(i));
end;

for i=(T-T1+1):T,
    Value1=Value1*(1+0.04/12);
end;

           % Q3:    What is the max drawdown, the largest % drop from a previous peak  
           
           % Since the program requires prices as input, we translate the
           % returns into prices first (the starting price can be set as 100)
 
P=100*ones(T,1);
MDD=0;
Worst=0;
             % using the algorithm in the file
    max=-99;
    Worst=min(Return); 
    for j=1:T,
    P(j+1)=P(j)*(1+Return(j));  % convert to prices;
    if P(j+1)>max,
        max=P(j+1);
    end;
    DD=100*(max-P(j+1)) / max;
    if DD>MDD,
        MDD=DD;
    end;
    end;
 
 fprintf('*************  skewness, its Std, x times deviations aways from mean, and the 95 percent confidence interval   **************** \n');

 fprintf(' %6.4f,     %6.4f,     %6.4f            [%6.4f,    %6.4f] \n',  skew, sqrt(6/T), skew/sqrt(6/T), skewA, skewB  );
 
 fprintf('*************  kurtosis,  its Std, x times deviations aways from mean,and the 95 percent confidence interval   **************** \n');

 fprintf(' %6.4f,     %6.4f,     %6.4f              [%6.4f,    %6.4f] \n',  kurt, sqrt(24/T),  ( kurt-3)/ sqrt(24/T), kurtA, kurtB  );
 
 
 %%%%%%%%%%%%   Simulate T normal random varables with mean mu and varance sig2
 
RN=zeros(T,1);
sig=sqrt(sig2);
for i=1:T,
     RN(i)=mu + sig*randn(1) ;          
end;

%  a comparison of plot of the returns and random normal data matching the mean and std

figure;
plot(Return);
figure;
plot(RN);
 
%  a comparison of plot of the histograms of returns and random normal data matching the mean and std

figure
hist(Return);
figure
hist(RN);
 
%   Skewness and Kurtosis for normal data

skew2=skewness(RN);
kurt2=kurtosis(RN);
