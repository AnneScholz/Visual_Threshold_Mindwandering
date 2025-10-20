function Xi = GetOffset4OverlappingDataPoints( matrix,Nbins,X,offsetwidth )



[x1 x2] = size( matrix );
for k = 1:x2;
    bounds      = [floor( min( matrix( :,k ))) ceil( max( matrix( :,k )))];
    binlim      = round( linspace( bounds( 1 ),bounds( 2 ),Nbins ).*10 )./10 ;
    for kk = 1:Nbins-1;
        nv      = find( matrix( :,k )>=binlim( kk )&matrix( :,k )<=binlim( kk+1 ));
        if length( nv )>1
            of      = length( nv )/offsetwidth;
            xx      = linspace( -of,of,length( nv ))+X( k );
            if ismember( 0,xx )
                return
            end
            Xi( nv,k ) = xx;
        else
            Xi( nv,k ) = X( k );
        end
    end
end