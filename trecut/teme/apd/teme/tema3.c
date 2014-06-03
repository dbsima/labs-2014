#include <mpi.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

/*function that applies a certain type of function: Mandelbrot/Julia*/
int *computeSet(double array[11])
{
    int set_type = (int) array[0];
    double x_min = array[1];
    double x_max = array[2];
    double y_min = array[3];
    double y_max = array[4];
    double resol = array[5];
    int steps    = (int)array[6];
    int start    = (int)array[7];
    int stahp    = (int)array[8];
    double param1= array[9];
    double param2= array[10];

    /*compute the dimensions of the resulting matrix   */
    int width  = (x_max - x_min)/resol; 
    int height = (y_max - y_min)/resol;

    double Cx, Cy;          //world's coordinates = parameter plane
    double Zx, Zy;          //a complex number's parameters
    double Zx2, Zy2;        //a complex number's length (Zx2 + Zy2)
    double EscapeRadius = 2;//bail-out value, radius of circle
    double ER2 = EscapeRadius * EscapeRadius;   

    /*declare and alloc memory for the future matrix with computed pixels*/
    int *R = malloc(width * (stahp+1 - start) * sizeof(int));
    int count = 0;
  
    double Zx0, Zy0;    

    /*execute the set's algorithm for the master process*/
    int i, j;
    for(j = stahp; j >= start; j--)    
    {
        if (set_type == 1) Zy0 = y_min + (double)j * resol;
        else                Cy = y_min + (double)j * resol;
        for (i = 0; i < width; i++)
        {         
            if (set_type == 1)
            {
                Zx0 = x_min + (double)i * resol;
                Cx = param1;
                Cy = param2;
                Zx = Zx0;
                Zy = Zy0;
            }            
            else
            {
                Cx = x_min + (double)i * resol;
                Zx = 0.0;
                Zy = 0.0;
            }            
            
            Zx2 = Zx * Zx;
            Zy2 = Zy * Zy;

            int step = 0;
            while (step < steps && ((Zx2 + Zy2) < ER2))
            {
                Zy = 2 * Zx * Zy + Cy;
                Zx = Zx2 - Zy2 + Cx;
                Zx2 = Zx * Zx;
                Zy2 = Zy * Zy;
                step ++;
            };
            /*write in the matrix the computed color*/
            R[count++] = step % 256;            
        }
    }
    return R;
}

int main (int argc, char *argv[])
{
    /*open input file*/
    FILE *in  = fopen(argv[ 1 ], "r");

    /*open output file*/
    FILE *pgm = fopen(argv[ 2 ], "wb");

    /*read set type*/
	int set_type;
	fscanf (in, "%d", &set_type);
    
    /*read the numbers which define the subspace from the complex plan for which
     *the computatation in done*/
	double x_min;
	fscanf (in, "%lf", &x_min);
	double x_max;
	fscanf (in, "%lf", &x_max);
	double y_min;
	fscanf (in, "%lf", &y_min);
	double y_max;
	fscanf (in, "%lf", &y_max);

    /*the the resolution for the chosen subspace*/
	double resol;
	fscanf (in, "%lf", &resol);

    /*read the maximum number of iterations for the generation of the set*/
	int steps;
	fscanf (in, "%d", &steps);

    /*for the julia set, read two extra numbers which define the complex parame-
     *ter of the function*/
    double param1, param2;	
    if (set_type == 1)
	{
		fscanf (in, "%lf", &param1);
		fscanf (in, "%lf", &param2);		
	}
    else
    {
        param1 = -1;
        param2 = -1;
    }
    
    /*compute the dimensions of the resulting matrix   */
    int width  = (x_max - x_min)/resol; 
    int height = (y_max - y_min)/resol;
	
    /*create a PGM plain image with the dimensions computed and the maximum grey
     *value*/
    fprintf(pgm, "P2\n %d\n %d\n %d\n", width, height, 255);

    int size;       //the number of processes
    int rank;       //the rank of a process
    int tag = 1;    //the tag of an process

    MPI_Status Stat;                        //the status variable
	MPI_Init(&argc, &argv);                 //init the world of processes
	MPI_Comm_size(MPI_COMM_WORLD, &size);   //find the number of processes
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);   //find the rank of current process

    int i;
    
    /*alloc memory for the matrix that will contain the computed pixels*/
    int *final = (int*) malloc(width * height*sizeof(int)); 
    int count = 0;

    /*the master process (rank == 0) will send to each process in the world
     *a number maximum height/size rows from the future final matrix to compute,
     *indicated by the start and final row */
    if (rank == 0)
	{
        int lines = height/size;        //number of rows for a process
        int start = 0;                  //starting row for a process
        int stahp = start + lines - 1;   //final row for a process

        /*the package to sent to a process will contain the subspace's limits,
         *the resolution of it, the maximum number of iterations and the start-
         *stop pair*/
        double array[11];
        array[0] = (double)set_type;
        array[1] = x_min;
        array[2] = x_max;
        array[3] = y_min;
        array[4] = y_max;
        array[5] = resol;
        array[6] = steps;
        array[7] = start;
        array[8] = stahp;
        array[9] = param1;
        array[10] = param2;
        
        /*create the matrix with the computed pixels*/
        int *S = computeSet(array);

        /*write the computed matrix in the final one at the right position*/
        for (i = 0 ; i < width * (stahp + 1 - start); i++) 
            final[width * height - ((stahp + 1) * width) + i] = S[i];                  
    
        /*compute the next pair start-stop row for the next process*/
        start = stahp + 1;
        stahp = start + lines - 1;

		for (i = 1; i < size; i++)
        {
            /*the last process will compute untill the last row of the matrix
             *no matter if the work isn't equal between the processes*/
            if ((i + 1) == size)
                stahp = height - 1;

            array[7] = start;
            array[8] = stahp;
			
            /*sent the package to a process*/
            MPI_Send(&array, 11, MPI_DOUBLE, i, tag, MPI_COMM_WORLD);
            
            /*compute the next pair start-stop row for the next process*/
            start = stahp + 1;
            stahp = start + lines - 1;
        }
    }
    else
    /*the other processes (rank != 0) will receive the package, compute the ne-
     *cessary data for the future computation, calculate the pixels, memorize 
     *them in a matrix and send the matrix to the master*/
    {
        /*read the package*/
        double recv_array[11];
        MPI_Recv(recv_array, 11, MPI_DOUBLE, 0, tag, MPI_COMM_WORLD, &Stat);
      
        int recv_set_type = (int) recv_array[0]; 
        double recv_x_min = recv_array[1];
        double recv_x_max = recv_array[2];
        double recv_y_min = recv_array[3];
        double recv_y_max = recv_array[4];
        double recv_resol = recv_array[5];
        int recv_steps    = (int)recv_array[6];
        int recv_start    = (int)recv_array[7];
        int recv_stahp    = (int)recv_array[8];

        /*compute the width and the height of the final matrix*/
        int recv_width  = (recv_x_max - recv_x_min)/recv_resol; 
        int recv_height = (recv_y_max - recv_y_min)/recv_resol;

        /*create the matrix with the computed pixels*/
        int *R = computeSet(recv_array);         
       
        /*send to the master the start-stop pair and the computed matrix*/
        MPI_Send(&recv_stahp, 1, MPI_INT, 0, tag, MPI_COMM_WORLD);
        MPI_Send(&recv_start, 1, MPI_INT, 0, tag, MPI_COMM_WORLD);
        MPI_Send(R, (recv_stahp + 1 - recv_start) * recv_width, MPI_INT, 0, tag, MPI_COMM_WORLD); 
    }

    /*the master will receive the computed parts of the final matrix and it will
     *copy them in it in the correct place*/
    if (rank == 0)
    {
        /*from each process gather the information and write it in the matrix*/
        for (i = 1; i < size; i++)
        {
            int recv_2_stahp;
            int recv_2_start;

            MPI_Recv(&recv_2_stahp, 1, MPI_INT, MPI_ANY_SOURCE, tag, MPI_COMM_WORLD, &Stat); 
            MPI_Recv(&recv_2_start, 1, MPI_INT, MPI_ANY_SOURCE, tag, MPI_COMM_WORLD, &Stat);

            MPI_Recv(final + (width * height - (recv_2_stahp + 1) * width), (recv_2_stahp + 1 - recv_2_start) * width, MPI_INT, MPI_ANY_SOURCE, tag, MPI_COMM_WORLD, &Stat);
                            
        }
        for (i = 0; i < width*height; i++)
            fprintf(pgm, "%d\n", final[i]);
    }
    
    /*close the world of processes*/
	MPI_Finalize();
	return 0;	
} 
