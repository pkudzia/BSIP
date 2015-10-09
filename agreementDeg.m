function [diff_mean,diff_SD,rho_mean_diff,rho_x_y,poly_diff_mean,poly_corr_x_y]=agreementDeg(x,y,PLOT,Xlabel,Ylabel,Norm_unit)
%%
% this function calculates the agreement degree between two input vectors.
% it do Bland-Altman analysis of differences and correlation plot 
% Input  arguments :
%                   x        : 1st vector 
%                   y        : 2nd vector
%                   PLOT     : plot option, it can be 'yes' or 'no' default value is yes
%                   Norm_unit: plot scaling unit (optional input)
%                   Xlabel   : horizontal axis title (correlation plot)
%                   Ylabel   : vertical   axis title (correlation plot)
% note that x and y must have the same length and must be a row vector!

% Output arguments :
%                   diff_mean     : Mean difference between the two input vectors -- mean(x-y)
%                   diff_SD       : SD of the difference between the two input vectors -- std(x-y)
%                   rho_mean_diff : Correlation coef of the Mean vector and the differences vector
%                   rho_x_y       : Correlation coef of the two input vectors x&y
%                   poly_diff_mean: linear polynomical fitted curve of the Bland-Altman plot 
%                   poly_corr_x_y : linear polynomical fitted curve of the correlation plot
% example:
%         x=rand(1,20);
%         y=rand(1,20);
%         agreementDeg(x,y,'yes','Xlabel','Ylabel',5);

if nargin==5
    Norm_unit=1;
end
if nargin==3
    Xlabel='Xlabel';
    Ylabel='Ylabel';
end
if nargin==2
    PLOT='yes';
end

Diff=x-y;
Mean=(x+y)/2;
diff_mean=mean(Diff);
diff_SD=std(Diff);
rhoM=corrcoef(Mean,Diff);
rho_mean_diff=rhoM(1,2);

if strcmp(PLOT,'yes')
    %% diff analysis
    figure (1);
    plot(Norm_unit*Mean,Norm_unit*Diff,'o');
    hold on;
    t=linspace(min(Norm_unit*Mean),max(Norm_unit*Mean),length(Mean));
    diff_mean_vec=zeros(size(t));
    diff_mean_vec(:)=Norm_unit*diff_mean;
    diff_SD_vec=zeros(size(t));
    diff_SD_vec(:)=Norm_unit*diff_SD;
    plot(t,diff_mean_vec,'--g');
    plot(t,diff_mean_vec+2*diff_SD_vec,'--c');
    plot(t,diff_mean_vec-2*diff_SD_vec,'--c');
    
    legend('Difference','Mean','95% Limit','95% Limit');hold on
    poly_diff_mean=fit(Norm_unit*Mean',Norm_unit*Diff','poly1');
   % plot(poly_diff_mean,'r');
    title('Limits of Agreement - Kinect Vs Jensen');
    xlabel('Mean Volume ( Kinect + Jensen (m3))');
    ylabel('Difference in Volume ( Kinect - Jensen)');
set(gca, 'XTickLabel', num2str(get(gca,'XTick')','%f'))  %#'
% set(gca, 'YTickLabel', num2str(get(gca,'XTick')','%f')) 

    %% correlation analysis
    clear rhoM;
    figure;
    rhoM=corrcoef(x,y);
    rho_x_y=rhoM(1,2);
    plot(Norm_unit*x,Norm_unit*y,'o');grid on;hold on;
    poly_corr_x_y=fit(Norm_unit*x',Norm_unit*y','poly1');
    plot(poly_corr_x_y,'r');
    plot(Norm_unit*x,Norm_unit*x,'g');
    title('Correlation Plot');
    xlabel(Xlabel);ylabel(Ylabel);
    legend('x data Vs. y data','Linear Fitted Curve','y=x line');
    set(gca, 'XTickLabel', num2str(get(gca,'XTick')','%f')) 
    set(gca, 'YTickLabel', num2str(get(gca,'XTick')','%f')) 
end
