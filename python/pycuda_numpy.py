import numpy as np
import pycuda.autoinit
import pycuda.driver as cuda
import pycuda.gpuarray as gpuarray

# 乱数配列を生成→GPUのメモリーを割いてデータを渡す
rand_array = np.random.randn(5, 5)
array_gpu = gpuarray.to_gpu(rand_array)
# 生成した配列の2乗の結果を取得
result = (array_gpu ** 2).get()

print(result)