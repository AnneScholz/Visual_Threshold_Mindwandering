function ONOFFbarplot( dt )

color                       = dt.color;
x                           = dt.x;

figure; hold on

b                           = barh( dt.M );
for k = 1:3;
    b( k ).FaceColor        = dt.color( k,: );
    b( k ).EdgeColor        = dt.color( k,: );
    yval( k,: )             = b( k ).XEndPoints;
end




errorbar( dt.M',yval,dt.E','horizontal','Color','k','CapSize',0,'LineWidth',2,'LineStyle','none' )


set( gca,'YTick',[1:3],'YTickLabel',{'detect','global','local'})
set( gcf,'color',[1 1 1])


pbaspect([1 .3 1])
xlabel('threshold')
ylabel('instruction')
ylim([-0 4])
xlim([min( dt.x ) max( dt.x )])


