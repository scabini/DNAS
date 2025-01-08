/*
 *Return: 2 matrizes: grau=nr*nt X maxConections str=nr*nt X w*h*z
*/

#include "mex.h"
#include <math.h>
#include <vector>
#define L 255
using std::vector;

double imagem[2100][2100][32];

//double lclust[134217730];
double edgeWeight(double a[], double b[], int z, double d, double r);
double absolutePixelValue(double a[], int z);


void mexFunction(
	int nlhs,
	mxArray *plhs[],
	int nrhs,
	const mxArray *prhs[]
	)
{	
	if (nrhs != 2) {
		mexErrMsgTxt("Input arguments: image (3d matrix wXhXn) and radius.");
	}
	else if (nlhs != 1) {
		mexErrMsgTxt("outputs 1 numeric matrices 4x(w*h): measures (kin, strin, kou, strou) for FULL network (N) connections");
	}
int w, h, z, dimensions, n, np, radius;	  
    double *im, t;
    
	h = mxGetM(prhs[0]);    /* nro linhas da imagem */
	w = mxGetN(prhs[0]);    /* nro colunas da imagem *///Porem, retorna w*n, onde n é a qtde de bandas
	dimensions = mxGetNumberOfDimensions(prhs[0]); //Qtde de dimensoes da img, deve ser 3.    
    im = mxGetPr(prhs[0]);
    radius = mxGetScalar(prhs[1]);
               
    
    z = (int)w/h; 
    w = (int)w/z; 
    np = (w-radius*2)*(h-radius*2);
    //printf("%d x %d x %d\n", w, h, z);
   
    for(int i=0; i<w; i++){
        for(int j=0; j<h; j++){
            for(int k=0; k<z; k++){
                //printf("(i,j,k) = (%d,%d,%d) = %f\n", i, j, k, *(im + w*h*k + j*w + i));
                imagem[i][j][k]= *(im + w*h*k + j*w + i);               
            }
        }
    }
//     printf("%d x %d x %d = %d\n", w, h, z, np);
//     return;
	plhs[0] = mxCreateDoubleMatrix(4, np, mxREAL);//ALL    
// 	plhs[1] = mxCreateDoubleMatrix(4, np, mxREAL);//WITHIN	    
// 	plhs[2] = mxCreateDoubleMatrix(4, np, mxREAL);//BETWEEN	
     
    
	double *saida1= mxGetPr(plhs[0]);
// 	double *saida2= mxGetPr(plhs[1]);
// 	double *saida3= mxGetPr(plhs[2]);     
   
    for (int row = 0; row < 4; row++) {
		for (int col = 0; col < np; col++) {
			saida1[4 * col + row] = 0;
//             saida2[4 * col + row] = 0;
//             saida3[4 * col + row] = 0;
		}
	}
    
    double r = radius*radius;
		for (int x = radius; x < w-radius; x++) {
			for (int y = radius; y < h-radius; y++){
                    double valuex= absolutePixelValue(imagem[x][y], z);
					for (int i = (int)(x - radius); i <= (int)(x + radius); i++) {
						for (int j = (int)(y - radius); j <= (int)(y + radius); j++) {                           
                            if (i >= 0 && i < w && j >= 0 && j < h && ((i != x || j != y))) {
                                double d = ((x - i)*(x - i) + (y - j)*(y - j));                                       
                                
                                
                                double valuey= absolutePixelValue(imagem[i][j], z);
                                
                                double diff= valuex-valuey;
                                
                                double edge = edgeWeight(imagem[x][y], imagem[i][j], z, d, r);                               

//                              double edge = ((difference +1)*(r-d+1) -1)/((L+1) * (r+1) -1); //EQ FODA OF THE FIRST FLAME
                                
                                if(d <= r){ //parametro para das arestas: REDE REGULAR, DIRECIONADA
                                   if(diff >= 0){
                                       
                                        saida1[4*(((y-radius)*(w-radius*2)) + (x-radius)) + 0] ++;
                                        saida1[4*(((y-radius)*(w-radius*2)) + (x-radius)) + 2] +=edge;                                       
                                   }else{
                                        saida1[4*(((y-radius)*(w-radius*2)) + (x-radius)) + 1] ++;
                                        saida1[4*(((y-radius)*(w-radius*2)) + (x-radius)) + 3] +=edge; 
                                    }
                                }
                            }
						}                        
                    }                   
				                               
                }            
            }

        

}

double edgeWeight(double a[], double b[], int z, double d, double r){
    //calcula o peso da aresta usando a similaridade do cosseno
    double numerador=0;
    double denominador1=0;
    double denominador2=0;
    for(int i=0;i<z;i++){
        //printf("a=%f  b=%f\n", a[i], b[i]);
        numerador+= (a[i]+1)*(b[i]+1);
        denominador1+= (a[i]+1)*(a[i]+1);
        denominador2+= (b[i]+1)*(b[i]+1);
    }
    return (((numerador/((sqrt(denominador1)*sqrt(denominador2))))) * (d/r));     
}

double absolutePixelValue(double a[], int z){
    //calcula valor absoluto de um pixel, i.e. sua soma em todos os canais
    double value=0;
    for(int i=0;i<z;i++){
        //printf("a=%f  b=%f\n", a[i], b[i]);
        value+=a[i];
    }
    return value;    
}

