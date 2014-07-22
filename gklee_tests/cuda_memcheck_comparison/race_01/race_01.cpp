#include <stdio.h>

#define SIZE 64
#define BLOCKS 1

__global__ void device_global(unsigned int *array_a, unsigned int *array_b, int num_elements) {
  int my_index = blockIdx.x * blockDim.x + threadIdx.x;

  __shared__ unsigned int my_shared[SIZE];
  my_shared[my_index] = my_index;
  __syncthreads();

  if (array_a[my_index] == array_b[my_index]) {
    if (array_b[my_index] == my_shared[my_index]) {
      array_a[0] = my_index;
    }
  } 
}

int main(int argc, char* argv[]) {
   
  unsigned int *host_array = (unsigned int*) malloc(SIZE*sizeof(unsigned int));
  unsigned int *device_array_a = 0;
  cudaMalloc((void **) &device_array_a, SIZE*sizeof(unsigned int));
  unsigned int *device_array_b = 0;
  cudaMalloc((void **) &device_array_b, SIZE*sizeof(unsigned int));

   
  if (host_array == 0) { return 1;}
  if (device_array_a == 0) { return 2;}
  if (device_array_b == 0) { return 3;}

   
  for (int i=0; i<SIZE; i++) {
    if (i%2 == 0) {
      host_array[i] = i;
    } else {
      host_array[i] = 0;
    }
  }
  cudaMemcpy(device_array_a, host_array, SIZE, cudaMemcpyHostToDevice);

   
   
  for (int i=0; i<SIZE; i++) {
    if (i%2 == 0 && i%3 == 0) {
      host_array[i] = i;
    } else {
      host_array[i] = 0;
    }
  }
  cudaMemcpy(device_array_b, host_array, SIZE, cudaMemcpyHostToDevice);
{ __set_CUDAConfig(BLOCKS, (SIZE/BLOCKS)); 
          
 device_global(device_array_a, device_array_b, SIZE);}
          
  cudaMemcpy(host_array, device_array_a, SIZE, cudaMemcpyDeviceToHost);

   
  for (int i=0; i<SIZE; i += SIZE/BLOCKS) {
    for (int j=0; j<SIZE/BLOCKS; j++){
      printf("%d, ", host_array[i+j]);
    }
    printf("\n");
  }
  
   
  free(host_array);
  cudaFree(device_array_a);
  cudaFree(device_array_b);
}