import tables as tb
import numpy as np
import os 
import time as t
import math
import matplotlib.pyplot as plt
import sys

class TableHandler():
	def __init__(self, path = 'Mine/tables/database.h5'):
		self.path = path
		if not os.path.isfile(self.path):
			self.tables = tb.open_file(self.path, 'a')
			print(f'\tCreating {self.path} ...')
		else:
			self.tables =tb.open_file(self.path, 'a')
	
	def _createTable(self, table_name, description):
		if not self.tables.__contains__(f'/{table_name}'):
			self.tables.create_table(self.tables.root, table_name, description= description)
		else:
			print(f'\t Table {table_name} already exists !!!')

	def _getTable(self, table_name):
		if self.tables.__contains__(f'/{table_name}'):
			return self.tables.root._f_get_child(f'{table_name}')
		else:
			print(f'\t Table {table_name} does NOT exists !!!')