# This program computes  mean and variance for returns on IBM, etc, 
# for the illustration of using R

rm(list = ls()); # clean up the environment
IBM = read.table("IBM.dat", quote="\"", comment.char="")
# load the data into data.frame format     
# monthly data from January 1934 to December 2011, 78*12=936 rows
#   Important Notes:   
# 1)  the data are downloaded from WRDS CRSP data base, with outpt IBM.txt format
# 2)  data files must be written in *.dat for Matlab ro load:  you simply rename IBM.txt as IBM.dat
#  the easiest way is to open it in Matlab and save *.txt as *.dat
# 3)  the data file and R script file, L1_IBM.R are in the same folder (current working directory),
# the path can be suppressed, otherwise it is necessary

class(IBM);
dim(IBM);
Return = IBM[1:936,4]; # the 4th column vector of the returns, 936 rows in total
mu = mean(Return);     # mean is the built-in function of R for computing the mean of a vector or matrix

        # Tedious way

sum=0;  # compute the sum of the first three returns
sum=sum+Return[1];
sum=sum+Return[2];
sum=sum+Return[3];
sum;
# A simple do loop
sum1=0;
for (i in 1:3){
    sum1=sum1+Return[i];
}
sum1;

# Now compute the sample mean without using the function    mean
# initiliaze the value be zero
mu1 = 0;    
for (i in 1:936){
    mu1 = mu1+Return[i];
}                                    
T = 936;
mu1 = mu1/T;
mu1
mu2 = mean(Return); 
mu2
# using R mean function, you will get the same value

sig = var(Return);   # Variance of the returns; var is the built-in function of R
Std = sqrt(sig);     # standard deviation

# Q1: How many returns greater than 2*Std+mu?
LB=mu+2*Std;                       
A1=0;
for (i in 1:T){
    if (Return[i]>LB){
        A1 = A1 + 1;   
    }
}

# Q2: How many returns greater than 10%?
LB2=.10;                       
A2=0;
for (i in 1:T){
    if (Return[i]>LB2){
        A2 = A2 + 1;   
    }
}

# Q3: What is the accumulative returns/Value of investing $1?
Value=1;
for (i in 1:T){
    Value=Value*(1+Return[i]);
}

# Q4: What is the accumulative returns/Value of investing 
# $1 if we miss 5% of the best return month ?
# assuming earning the average riskfree rate of 4%/12
# in those missing month                        
ReturnS=sort(Return);  #sort the returns in increasing order
T1=0.05*T;
T1=round(T1);     # round the number to an integer
Value1=1;
for (i in 1:(T-T1)){
    Value1=Value1*(1+ReturnS[i]);
}

for (i in (T-T1+1):T){
    Value1=Value1*(1+0.04/12);
}

# Q5: What is the accumulative returns/Value of investing $1 if 
# we avoid 5% of the worse return month ?
# assuming earning the average risk free rate of 4%/12
# in those missing month                        
ReturnS=sort(Return);  # sort the returns in increasing order
T1=0.05*T;
T1=round(T1);     # round the number to an integer
Value2=1;
for (i in 1:T1){
    Value2=Value2*(1+0.04/12);
}
for (i in (T1+1):T){
    Value2=Value2*(1+ReturnS[i]);
}

# Q6: Percentage of up days:
Up=0;
for (i in 1:T){
    if (Return[i]>0){
        Up=Up+1;
    }   
}
Udays=Up/T;

# To print out the numerical values of any variables you computed in R, there are severals:
# One way, as we did in class, is to type the variable name in the command window.  
# But this can be tedious if there are many variables.

# The simplest way is to write the variable name in the R script
# then, when the file is run, the program automatically print out the variable at the commoand window.  
# For example,  adding a line of mu here
mu;
# Then the program, when runs, will print out mu. To help remember, you can write some comments such
# as 'this is the IBM mean' by adding:
print("this is the IBM mean ");
mu;
# To have certain formats of the output, see the code below
sprintf("(Monthly) Mean, Std of the Returns");
sprintf("%6.4f %6.4f", mu, Std );
  
sprintf("Q1: How many returns greater than 2*Std?");
sprintf("%6.0f",A1);
sprintf("Q2: How many returns greater than 10 percent?");
sprintf("%6.0f",A2);
sprintf("Q3: What is the accumulative returns/Value of investing $1?");
sprintf("%10.2f",Value);
sprintf("Q4: What is the accumulative returns/Value of investing $1 if we miss 5percent of the best ?");
sprintf("%10.2f",Value1);
sprintf("Q5: What is the accumulative returns/Value of investing $1 if we avoid 5percent of the worst ?");
sprintf("%10.2f",Value2);
plot(Return) # plot the returns data to get a picture view
