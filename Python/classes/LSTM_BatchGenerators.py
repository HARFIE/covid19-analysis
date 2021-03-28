import sys
import os
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

import math
import tables
import numpy as np
import pandas as pd

from tensorflow.keras.utils import Sequence

class UpgradedInput(Sequence) :
  
	def __init__(self, input_data,label_data, batch_size, window_size)  :
		self.input = input_data	
		self.batch_size = batch_size
		self.labels = label_data
		self.window_size = window_size

		self.indexes = np.zeros((len(self.input)-(self.window_size-1), window_size))
		for n in range(len(self.input)-(self.window_size-1)):
			self.indexes[n,:] = np.arange(n, self.window_size+n,1)
		self.indexes = self.indexes.astype(int)
			

		
    
	def __len__(self) :
		#
		return (np.ceil(      ( len(self.indexes) ) / float(self.batch_size))).astype(np.int)
  
  
	def __getitem__(self, idx) :

		idd = self.indexes[idx*self.batch_size: (idx+1)*self.batch_size]
		
		batch_x = np.ones((*(idd.shape), self.input.shape[-1]))
		batch_y = []
		for i,row in enumerate(idd):
			batch_x[i,:] = self.input[ row ]

			batch_y += [self.labels[row[-1]]]

		return batch_x, np.array(batch_y, dtype = float)

if __name__ == '__main__':
	Table = np.arange(388*5).reshape(388,5)
	ui = UpgradedInput(Table,5, 10)
	print(ui)
