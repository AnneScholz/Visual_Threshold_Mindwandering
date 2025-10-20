clear all
close all hidden
clc

%% 
CE      = [ 1 .4 .698; .6 .2 1; .4 1 .4; .2 .6 1 ]; % colors for experiments 
CI      = [ .9 .9 .9; .7 .7 .7; .5 .5 .5; .2 .6 1 ]; % colors for instructions

%% load data for Figures 1C-D
load( 'data/individualShiftParameters.mat')

%% FIGURE 1C - MW Distribution per Paradigm
for exp = 1:4 
    % summarizing the results
    Mexp( exp,: )           = mean( DT( find( EXPER==exp ),: ));
    Sexp( exp ).dt          = P( find( EXPER==exp),2 );

    figure( 1 ); hold on
    plot( xi,Mexp( exp,: ),'Color',CE( exp,: ));
    plot( [1:5],mean( MM( find( EXPER==exp ),: )),'o','MarkerEdgeColor','w', ...
        'MarkerFaceColor',CE( exp,: ));
end
xlabel('rating')
ylabel('likelihood')
xlim([0 6])
ylim([-.0 .4])
% legend('grating','curvature','color','faces')
set( gca,'xtick',[1 5],'xticklabel',{'OFF','ON'})
saveas( gcf,'figures/quadraticfit_exp','pdf' )

% plotting shift parameter for experiments
figure; hold on
yexp                        = [4:-1:1];
for exp = 1:4
    Y                       = Sexp( exp ).dt;
    Xi                      = GetOffset4OverlappingDataPoints( Y,8,yexp( exp ),200 );
    plot( Y,Xi,'o','MarkerEdgeColor','w', ...
        'MarkerFaceColor',CE( exp,: ));
end
xlabel('distribution shift')
ylabel('experiment')
set( gca,'ytick',[1:4],'yTickLabel',{'gratings','curvature','color','faces'})
pbaspect([1 .5 1])
xlim([-3 3])
ylim([0 5])
set( gcf,'color',[1 1 1])
saveas( gcf,'figures/mwdist_shift_experiment','pdf' )

%% FIGURE 1D - MW Distribution per Instruction
figure; hold on
xof                         = [-.15:.1:.15];
for instr = 1:3 
    % summarizing the results
    Minstr( instr,: )       = mean( DT( find( INSTR==instr ),: ));
    Sinstr( instr ).dt      = P( find( INSTR==instr),2 );

    plot( [1:5]+xof( exp ),mean( MM( find( INSTR==instr ),: )),'o','MarkerEdgeColor','w', ...
        'MarkerFaceColor',CI( instr,: ));
    plot( xi,Minstr( instr,: ),'Color',CI( instr,: ));
end
xlabel('rating')
ylabel('likelihood')
xlim([0 6])
ylim([-.0 .4])
% legend('grating','curvature','color','faces')
set( gca,'xtick',[1 5],'xticklabel',{'OFF','ON'})
saveas( gcf,'figures/quadraticfit_instr','pdf' )

% plotting shift parameter for instructions
figure; hold on
yins                        = [3:-1:1];
for instr = 1:3
    Y                       = Sinstr( instr ).dt;
    Xi                      = GetOffset4OverlappingDataPoints( Y,8,yins( instr ),200 );
    plot( Y,Xi,'o','MarkerEdgeColor','w', ...
        'MarkerFaceColor',CI( instr,: ));
end
xlabel('distribution shift')
ylabel('instruction')
set( gca,'ytick',[1:3],'yTickLabel',{'detection','global','local'})
pbaspect([1 .5 1])
xlim([-3 3])
ylim([0 4])
set( gcf,'color',[1 1 1])
saveas( gcf,'figures/mwdist_shift_Instruction','pdf' )

%% FIGURE 1E - RT per Trial Type & Paradigm with F-values
load( 'data/individualReactionTimes.mat')

for exp = 1:4
    tidx = 1;
    for tt = [1:3]
        XX( exp,tidx ).dt   = DT( EXPER==exp&TRTYP==tt );
        % M( exp,tidx )       = mean( XX( exp,tidx ).dt);
        % y                   = DT( EXPER==exp&TRTYP==tt );
        % E( exp,tidx )       = std( y )./sqrt( length( y ));
        % SD( exp,tidx )      = std( y );
        tidx                = tidx + 1;
    end
    g1                      = [ones( length( XX( exp,1 ).dt ),1 ),...
        ones( length( XX( exp,2 ).dt ),1 ).*2,...
        ones( length( XX( exp,3 ).dt ),1 ).*3];
    dt                      = cat( 1,XX( exp,1 ).dt,XX( exp,2 ).dt,XX( exp,3 ).dt );
    [p,table]               = anovan( dt(:),{g1(:)},'display','off');
    Res( exp,: )            = [cell2mat( table( 2,6:7 )) cell2mat( table( 3,3 ))];
end

figure; hold on
colororder({'k','k'})

for exp = 1:4
    bar( exp,Res( exp,1 ),'EdgeColor',CE( exp,: ),'FaceColor',CE( exp,: ),'BarWidth',.6);
end
xlabel('experiment')
ylabel('F value')
siglevel                    = {'***','**','*','n.s.'};
for k = 1:4
    text( k,25,siglevel{ k },'FontName','times','FontSize',15);
end
ylim([0 5])
yyaxis right
hold on
bw                          = .05;
os                          = [-.2 0 .2];
for exp = 1:4
    tidx = 1;
    for tt = 1:3
        xd                  = exp+os(tt );
        dt                  = DT( EXPER==exp&TRTYP==tt );
        dt( find( abs( zscore( dt ))>=2 )) = [];
        prct                = prctile( dt,[10 25 75 90]);
        x                   = [xd-bw xd+bw xd+bw xd-bw xd-bw];
        y                   = [prct( 2 ) prct( 2 ) prct( 3 ) prct( 3 ) prct( 2 )];
        v                   = [x' y']; 
        line([xd xd],[prct( 1 ) prct( 4 )],'Color','k' )
        patch( 'Faces',[1:5],'Vertices',v,'FaceColor',CI( tt,: ))
        line(x( 1:2 ),[median( dt) median( dt )],'Color','r','LineWidth',2 )
    end
end
text( )
set( gca,'XTick',[1:4],'XTickLabel',{'grating','curvature','color','faces'})
xlabel('experiment')
ylabel('reaction time [sec]')
% ylim([.7 1.1])
set( gca,'ytick',[.2 .4 .6])
saveas( gcf,'figures/reaction_time_change','pdf' )

%% FIGURE 2B - Thresholds per Paradigm, Instruction & Trial Type
load( 'data/dt_grating.mat')
ONOFFbarplot( dt )
saveas( gcf,'figures/grating','pdf' )

load( 'data/dt_curvature.mat')
ONOFFbarplot( dt )
saveas( gcf,'figures/curvature','pdf' )

load( 'data/dt_color.mat')
ONOFFbarplot( dt )
saveas( gcf,'figures/color','pdf' )

load( 'data/dt_faces.mat')
ONOFFbarplot( dt )
saveas( gcf,'figures/faces','pdf' )

%% load data for Figure 2C&D
load( 'data/DT_anova_Treshold.mat')

for exp = 1:4
        trialset            = find( EXPER==exp );
        DT( trialset)       = DT( trialset )-mean( mean( DT( trialset )))+.5;
end

%% FIGURE 2 C - Thresholds per Trial Type
clear Y
figure; hold on
for tt = 1:3
    Y( tt ).dt              = mean( reshape( DT( TRTYP==tt ),[],3 ),2 );
    Xi                      = GetOffset4OverlappingDataPoints( Y( tt ).dt,8,tt,200 );
    plot( Xi,Y( tt ).dt,'o','MarkerEdgeColor','w', ...
        'MarkerFaceColor',CI( tt,: ));
end
xlabel('experiment')
ylabel('Threshold')
set( gca,'xtick',[1:3],'XTickLabel',{'ON','unlabeled','OFF'})
ylim([0 1])
xlim([-1 5])
set( gcf,'color',[1 1 1])
saveas( gcf,'figures/PERF_trialtype','pdf' )

%% FIGURE 2 D - Thresholds per Trial Type & Paradigm with F-values
for exp = 1:4
    tidx = 1;
    for tt = [1:3];
        XX( exp,tidx ).dt   = DT( EXPER==exp&TRTYP==tt );
        % M( exp,tidx )       = mean( XX( exp,tidx ).dt);
        % y                   = DT( EXPER==exp&TRTYP==tt );
        % E( exp,tidx )       = std( y )./sqrt( length( y ));
        % SD( exp,tidx )      = std( y );
        tidx                = tidx + 1;
    end
    g1                      = [ones( length( XX( exp,1 ).dt ),1 ),...
        ones( length( XX( exp,2 ).dt ),1 ).*2,...
        ones( length( XX( exp,3 ).dt ),1 ).*3];
    dt                      = cat( 1,XX( exp,1 ).dt,XX( exp,2 ).dt,XX( exp,3 ).dt );
    [p,table]               = anovan( dt(:),{g1(:)},'display','off');
    Res( exp,: )            = [cell2mat( table( 2,6:7 )) cell2mat( table( 3,3 ))];
end

figure; hold on
colororder({'k','k'})
for exp = 1:4
    bar( exp,Res( exp,1 ),'EdgeColor',CE( exp,: ),'FaceColor',CE( exp,: ),'BarWidth',.6);
end
xlabel('experiment')
ylabel('F value')
for k = 1:4
    text( k-.25,2,num2str( round(Res( k,2 ),3 )),'FontName','times','FontSize',15);
end

yyaxis right
hold on
bw                          = .05;
os                          = [-.2 0 .2];
for exp = 1:4
    tidx = 1;
    for tt = [1:3]
        xd                  = exp+os(tt );
        dt                  = DT( EXPER==exp&TRTYP==tt );
        dt( find( abs( zscore( dt ))>=2 )) = [];
        prct                = prctile( dt,[10 25 75 90]);
        x                   = [xd-bw xd+bw xd+bw xd-bw xd-bw];
        y                   = [prct( 2 ) prct( 2 ) prct( 3 ) prct( 3 ) prct( 2 )];
        v                   = [x' y']; 
        line([xd xd],[prct( 1 ) prct( 4 )],'Color','k' )
        patch( 'Faces',[1:5],'Vertices',v,'FaceColor',CI( tt,: ))
        line(x( 1:2 ),[median( dt) median( dt )],'Color','r','LineWidth',2 )
    end
end
set( gca,'XTick',[1:4],'XTickLabel',{'grating','curvature','color','faces'})
ylim([0 1])
xlim([0 5])
xlabel('experiment')
ylabel('threshold')
set( gcf,'color','w')
set( gca,'YTick',[0 .5 1])
saveas( gcf,'figures/threshold_change','pdf' )

%% load data for Figure 2E&F
load( 'data/DT_anova_Performance.mat')

%% FIGURE 2E - Suprathreshold Performance per Trial Type
clear Y
figure; hold on
for tt = 1:3
    Y( tt ).dt              = mean( reshape( DT( TRTYP==tt ),[],3 ),2 );
    Xi                      = GetOffset4OverlappingDataPoints( Y( tt ).dt,8,tt,200 );
    plot( Xi,Y( tt ).dt,'o','MarkerEdgeColor','w', ...
        'MarkerFaceColor',CI( tt,: ));
end
xlabel('experiment')
ylabel('performance')
set( gca,'xtick',[1:3],'XTickLabel',{'ON','unlabeled','OFF'})
ylim([0 1.2])
xlim([-1 5])
set( gcf,'color',[1 1 1])
saveas( gcf,'figures/supratreshold_trialtype','pdf' )

%% FIGURE 2F - Suprathreshold Performance per Trial Type & Paradigm with F-values
for exp = 1:4
    tidx = 1;
    for tt = [1:3]
        XX( exp,tidx ).dt   = DT( EXPER==exp&TRTYP==tt );
        % M( exp,tidx )       = mean( XX( exp,tidx ).dt);
        % SD( exp,tidx )      = std( XX( exp,tidx ).dt );
        % y                   = DT( EXPER==exp&TRTYP==tt );
        % E( exp,tidx )       = std( y )./sqrt( length( y ));
        tidx                = tidx + 1;
    end
    g1                      = [ones( length( XX( exp,1 ).dt ),1 ),...
        ones( length( XX( exp,2 ).dt ),1 ).*2,...
        ones( length( XX( exp,3 ).dt ),1 ).*3];
    dt                      = cat( 1,XX( exp,1 ).dt,XX( exp,2 ).dt,XX( exp,3 ).dt );
    [p,table]               = anovan( dt(:),{g1(:)},'display','off');
    Res( exp,: )            = [cell2mat( table( 2,6:7 )) cell2mat( table( 3,3 ))];
end

figure; hold on
colororder({'k','k'})
for exp = 1:4
    bar( exp,Res( exp,1 ),'EdgeColor',CE( exp,: ),'FaceColor',CE( exp,: ),'BarWidth',.6);
end
xlabel('experiment')
ylabel('F value')
siglevel                    = {'***','**','*','n.s.'};
for k = 1:4
    text( k,25,siglevel{ k },'FontName','times','FontSize',15);
end
ylim([0 30])

yyaxis right
hold on
bw                          = .05;
os                          = [-.2 0 .2];
for exp = 1:4
    tidx = 1;
    for tt = [1:3]
        xd                  = exp+os(tt );
        dt                  = DT( EXPER==exp&TRTYP==tt );
        dt( find( abs( zscore( dt ))>=2 )) = [];
        prct                = prctile( dt,[10 25 75 90]);
        x                   = [xd-bw xd+bw xd+bw xd-bw xd-bw];
        y                   = [prct( 2 ) prct( 2 ) prct( 3 ) prct( 3 ) prct( 2 )];
        v                   = [x' y']; 
        line([xd xd],[prct( 1 ) prct( 4 )],'Color','k' )
        patch( 'Faces',[1:5],'Vertices',v,'FaceColor',CI( tt,: ))
        line(x( 1:2 ),[median( dt) median( dt )],'Color','r','LineWidth',2 )
    end
end
text( )
set( gca,'XTick',[1:4],'XTickLabel',{'grating','curvature','color','faces'})
xlabel('experiment')
ylabel('suprathreshold performance')
ylim([.7 1.1])
set( gca,'ytick',[.7 .8 .9 1])
saveas( gcf,'figures/supratreshold_change','png' )
