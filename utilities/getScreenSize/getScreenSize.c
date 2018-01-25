#include "mex.h"
#include <windows.h>

void mexFunction( int nlhs, mxArray *plhs[], 
		  int nrhs, const mxArray*prhs[] )
     
{ 
    double sz[4];

    /* initialize size array */
    sz[0] = 1;
    sz[1] = 1;
    
    /* get width and height of the screen */
    sz[2] = GetSystemMetrics( SM_CXSCREEN );
    sz[3] = GetSystemMetrics( SM_CYSCREEN );
    
   /* initialise return mxArray */
   plhs[0] = mxCreateDoubleMatrix( 1, 4, mxREAL );

   /* copy data into it */
   memcpy( mxGetPr( plhs[0] ), sz, 4*sizeof( double ) );
   
}


