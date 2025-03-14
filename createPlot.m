function createPlot(X1, YMatrix1)
%CREATEFIGURE(X1, YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 02-Mar-2017 14:26:29

% Create figure

figuresize(30, 20, 'centimeters');
figure1 = figure(1);


% Create axes
axes1 = axes('Parent',figure1,'YGrid','on','XGrid','on','FontSize',14,...
    'Position',[0.116078886310905 0.13567760342368 0.774999999999999 0.815]);
box(axes1,'on');
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',2,'Parent',axes1);
set(plot1(1),'DisplayName','Figure 1');
set(plot1(2),'DisplayName','Figure 2','LineStyle','--');
set(plot1(3),'DisplayName','Figure 3');

% Create xlabel
xlabel('t','FontWeight','bold','FontSize',20);

% Create ylabel
ylabel('<c>','FontWeight','bold','FontSize',20);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.704369685276246 0.539229674830758 0.165893268453826 0.116500234567037],...
    'FontSize',16);

