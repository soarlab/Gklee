#include <stdio.h>
#define SIZE 64
#define BLOCKS 4

__global__ void device_global(unsigned int *array_a, int num_elements) {
  int my_index = blockIdx.x * blockDim.x + threadIdx.x;

  array_a[my_index] = my_index % (num_elements/2); // write overlaping indicies
  __syncthreads();

  int next_index = array_a[my_index]; // use written index 
  array_a[next_index] = my_index; // cause a write write race
}

int main(void) {
  // malloc arrays
  unsigned int *host_array = (unsigned int*) malloc(SIZE*sizeof(unsigned int));
  unsigned int *device_array_a = 0;
  cudaMalloc((void **) &device_array_a, SIZE*sizeof(unsigned int));

  // check mallocs
  if (host_array == 0) { return 1;}
  if (device_array_a == 0) { return 2;}

  // init host array to 0
  for (int i=0; i<SIZE; i++) {
    host_array[i] = 0;
  }

  // copy to device, call global, and copy output back
  cudaMemcpy(device_array_a, host_array, SIZE, cudaMemcpyHostToDevice);
  device_global<<<BLOCKS,(SIZE/BLOCKS)>>> (device_array_a, SIZE);
  cudaMemcpy(host_array, device_array_a, SIZE, cudaMemcpyDeviceToHost);

  // print output
  for (int i=0; i<SIZE; i += SIZE/BLOCKS) {
    for (int j=0; j<SIZE/BLOCKS; j++){
      printf("%d, ", host_array[i+j]);
    }
    printf("\n");
  }

  // cleanup
  free(host_array);
  cudaFree(device_array_a);
}