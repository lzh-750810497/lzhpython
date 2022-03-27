%
%   This program computes  mean and variance for returns on IBM, etc, for
%   the illustration of using Matlab

load IBM.dat;   %  load the data, monthly data from January 1934 to December 2011, 78*12=936 rows
                %  Important Notes:   1)  the data are downloaded from WRDS CRSP data base, with outpt IBM.txt format
                %         2)  data files must be written in *.dat for Matlab ro load:  you simply rename IBM.txt as IBM.dat
                                          % the easiest way is to open it in Matlab and save *.txt as *.dat
                  % 3)  the data file and command file, IBM.m here, must be in the same folder here. 
                    %     In general, the data file can be anywhere in the computer, then the directory name
                       %     must be provided for the program to find the data. The easest way is to
                         %     put them all in the same directory/folder, as we did here.
                                  
Return=IBM(1:936,4);      %  the 4th column vector of the returns, 936 rows in total

mu=mean(Return);        % mean is the built-in function of Matlab for computing the mean of a vector or matrix

                     % Tedious way
                 
sum=0;                  % compute the sum of the first three returns
sum=sum+Return(2);
sum=sum+Return(3);
                  % A simple do loop
sum1=0;
for i=1:3,
     sum1=sum1+Return(i);
end;

                  % Now compute the sample mean without using the function    mean
                  
mu1=0;     % initiliaze the value be zero
for i=1:936,                                    
     mu1=mu1+Return(i);
end;
T=936;
mu1=mu1/T;

mu2=mean(Return);        % using Matlab mean function, you will get the same value

sig=var(Return);             % Variance of the returns; var is the built-in function of Matlab

Std=sqrt(sig);              % standard deviation

                       % Q1:   How many returns greater than 2*Std+mu ?
LB=mu+2*Std;                       
A1=0;
for i=1:T,
     if Return(i)>LB,
         A1=A1 + 1;
     end
end;

                      % Q2:   How many returns greater than 10%  ?
LB2=.10;                       
A2=0;
for i=1:T,
     if Return(i)>LB2,
         A2=A2 + 1;
     end
end;

                    % Q3:    What is the accumulative returns/Value of investing $1  ?
Value=1;
for i=1:T,
    Value=Value*(1+Return(i));
end;

          % Q4:    What is the accumulative returns/Value of investing 
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


     % Q5:    What is the accumulative returns/Value of investing $1 if 
     % we avoid 5% of the worse return month ?
         %  assuming earning the average riskfree rate of 4%/12
         % in those missing month                        
                        
ReturnS=sort(Return);   % sort the returns in increasing order
T1=0.05*T;
T1=round(T1);     % round the number to an integer

Value2=1;
for i=1:T1,
    Value2=Value2*(1+0.04/12);
end

for i=(T1+1):T,
    Value2=Value2*(1+ReturnS(i));
end

     % Q6:    Percentage of up days:
     
 Up=0;
 for i=1:T,
    if Return(i)>0, 
        Up=Up+1;
    end
end

 Udays=Up/T;

                      %  To print out the numerical values of any variables you computed in Matlab, there are severals:
                              % One way, as we did in class,  is to type the variable name in the command window.  
                                      % But this can be tedious if there are many variables.

                             % The simplest way is to write the variable name in the m-file (Matlab file) without the semicolon
                            %   `;', then, when the file is run, the program automatically print out the variable at the commoand window.  
                                % For example,  adding a line of mu here
 mu;
                            %  Then the program, when runs, will print out mu.  To help remember, you  can write some comments such
                                     %  as 'this is the IBM mean' by adding:
                                     
 fprintf('   this is the IBM mean     \n' );
 
 mu;

                               % To have certain formats of the output, see the code below

fprintf('  (Monthly)  Mean, Std  of the   Returns        \n');

fprintf('              %6.4f        %6.4f          \n',   mu, Std );
  

fprintf('  Q1:   How many returns greater than 2*Std ?  \n');


fprintf('              %6.0f               \n',   A1 );
   


fprintf('  Q2:   How many returns greater than  10 percent  ?  \n');


fprintf('              %6.0f               \n',   A2 );
   

fprintf('  Q3:   What is the accumulative returns/Value of investing $1  ?  \n');


fprintf('              %10.2f               \n',   Value);
 

fprintf('  Q4:   What is the accumulative returns/Value of investing $1 if we miss 5percent of the best ?  \n');


fprintf('              %10.2f               \n',   Value1);



fprintf('  Q5:   What is the accumulative returns/Value of investing $1 if we avoid 5percent of the worst ?  \n');


fprintf('              %10.2f               \n',   Value2);

                         
plot(Return);               % plot the returns data to get a picture view

diary off
