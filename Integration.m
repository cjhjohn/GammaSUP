function sol = Integration( h , fv , Dim )

if( strcmp(Dim,'1D') ), mesh = h ;         end
if( strcmp(Dim,'2D') ), mesh = h * h ;     end
if( strcmp(Dim,'3D') ), mesh = h * h * h ; end


sol = mesh * sum( fv ); 