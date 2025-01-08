

#include "mex.h"
#include <math.h>
#include <vector>
#include<stdio.h>
#include<stdlib.h>

using std::vector;


double histogram[66000];
double imagem[2100][2100][32];

double edgeWeight(double a[], double b[], int z, double d, double r);
    
void mexFunction(
	int nlhs,              
	mxArray *plhs[],       
	int nrhs,              
	const mxArray *prhs[]  
)
{
    int w, h, z, nr, nt, np, dimensions;
	double *im;
    double radius;
    double edges=0;
    /* check number of parameters */
    if (nrhs != 2) {
        mexErrMsgTxt("Input arguments: image, and radius");
    } else if (nlhs != 1) {
        mexErrMsgTxt("Returns a numeric array");
    }
    
    h = mxGetM(prhs[0]);    /* nro linhas da imagem */
	w = mxGetN(prhs[0]);    /* nro colunas da imagem *///Porem, retorna w*n, onde n é a qtde de bandas
	dimensions = mxGetNumberOfDimensions(prhs[0]); //Qtde de dimensoes da img, deve ser 3.    
    im = mxGetPr(prhs[0]);
    radius = mxGetScalar(prhs[1]);   
    
    z = (int)w/h; //VERIFICAR SE W, H E Z ESTAO SENDO PEGOS E CALCULADOS CERTO
    w = (int)w/z; 
    np = w*h;
    
    //printf("%d x %d x %d\n", w, h, z);
    
    for(int i=0; i<w; i++){
        for(int j=0; j<h; j++){
            for(int k=0; k<z; k++){
                //printf("(i,j,k) = (%d,%d,%d) = %f\n", i, j, k, *(im + w*h*k + j*w + i));
                imagem[i][j][k]= *(im + w*h*k + j*w + i);               
            }
        }
    }
    
	for (int i = 0; i<=65536; i++)
		histogram[i]=0;
    
    for(int x = 0; x < w; x++) {
        for(int y = 0; y < h; y++) { 

            for(int i = (int)(x-radius); i <= (int)(x+radius); i ++) {
                for(int j = (int)(y-radius); j <= (int)(y+radius); j ++) {

                    if(i >= 0 && i < w && j >= 0 && j < h && ((i != x || j != y))) {

                        double d = sqrt((x - i)*(x - i) + (y - j)*(y - j));

                        double edg = edgeWeight(imagem[x][y], imagem[i][j], z, d, radius);
                        //printf("x=%d  y=%d       i=%d  j=%d\n", x, y,i,j);
                        int edge = round(edg * 65536); //volta o peso das arestas para 0~~2^16 p/ histograma

                        if (d <= radius){ //parametro para cria��o das arestas
                            //printf("%d\n", edge);
                            histogram[edge]++;						
                            //printf("%f->%f= %d\n", imR[x][y], imR[i][j], weightVertex);
                            edges++;                            
                        }
                    }
                }
            }
            }
        }
	  
    
    
	//calcular media e desvio padr�o (isso sera feito na main)
	
	
	plhs[0] = mxCreateDoubleMatrix(1, 65538, mxREAL);

	double *saida = (double *) mxGetPr(plhs[0]);

	saida[0] = edges;
	for (int i = 1; i <= 65537; i++)
		saida[i] = histogram[i-1];
	

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


