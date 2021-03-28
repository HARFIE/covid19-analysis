import sys
import os
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

import math
import tables
import numpy as np
import pandas as pd


sys.path.append('Python/classes/')
import myTime as MT



data_columns = ['data', 'obitos', 'recuperados', 'ativos' ]
vacinas_columns = ['data', 'doses1', 'doses2']



def readTables(tablepaths, columns2keep , verbose = 0):
	if len(tablepaths) == len(columns2keep):
		tables = [None]* len(tablepaths)
		date_min = 0
		date_max = 0
		for i,(path, columns) in enumerate(zip(tablepaths, columns2keep)):
			table = pd.read_csv(path)
			table['data'] = pd.to_datetime(table['data'])    
			tables[i] = table[columns]


		date_mins = [table.iloc[0,0] for table in tables]
		date_maxs = [table.iloc[-1,0] for table in tables]


		date_min = np.argmin(date_mins)
		date_max = np.argmax(date_maxs)

		

		newTable = pd.DataFrame(pd.date_range(date_mins[date_min], date_maxs[date_max], freq ='D' ), columns = ['data'])

		for table in tables:
			newTable = concatTable(newTable, table, verbose = verbose -1)

		return newTable

	else:
		if verbose>0:
			print('Wrong Use of readTables ---- Not equal length')
		return -1
	

def concatTable(BigTable, smallTable, verbose = 0):

		eq_ini = (smallTable.iloc[0,0] == BigTable.iloc[0,0])
		eq_fin = (smallTable.iloc[-1,0] == BigTable.iloc[-1,0])

		eq_both = eq_ini * eq_fin
		eq_one = eq_ini + eq_fin

		if (len(smallTable) == len(BigTable) ):
			if (smallTable.iloc[0,0] == BigTable.iloc[0,0]) & eq_both:
				if verbose>0:
					print('Both', verbose)
				
				col = list(smallTable.columns)
				col.remove('data')
				BigTable[col] = smallTable[col]
			
			else:
				if verbose>0:
					print('\tWhat??? - NOT IMPLEMENTED')


		elif eq_one:
			if verbose>0:
				print('One')
			if eq_ini:
				if verbose>0:
					print('Ini')
				if smallTable.iloc[-1,0]< BigTable.iloc[-1,0]:
					if verbose>0:
						print('smallTable fin before BigTable fin')
					smallTable = padFin(BigTable, smallTable)

					col = list(smallTable.columns)
					col.remove('data')
					BigTable[col] = smallTable[col]


				elif smallTable.iloc[-1,0]> BigTable.iloc[-1,0]:
					if verbose>0:
						print('smallTable fin after BigTable fin - NOT IMPLEMENTED')

			elif eq_fin:
				if verbose>0:
					print('Fin')
				if smallTable.iloc[0,0]< BigTable.iloc[0,0]:
					if verbose>0:
						print('smallTable ini before BigTable ini - NOT IMPLEMENTED')

				elif smallTable.iloc[0,0]> BigTable.iloc[0,0]:
					if verbose>0:
						print('smallTable ini after BigTable ini')
					
					smallTable = padIni(BigTable, smallTable)
					col = list(smallTable.columns)
					col.remove('data')
					BigTable[col] = smallTable[col]


		else:
			if verbose>0:
				print('None - NOT IMPLEMENTED')

		BigTable.fillna(0, inplace =True)



		return BigTable

def padIni(BigTable, smallTable, ):
	
	auxTable =  pd.DataFrame(pd.date_range(BigTable.iloc[0,0], smallTable.iloc[0,0], freq ='D', closed = 'left' ), columns = ['data'])
	col = list(smallTable.columns)
	col.remove('data')
	for c in col:
		auxTable[c] = 0

	auxTable = auxTable.append(smallTable, ignore_index= True)

	return auxTable

def padFin(BigTable, smallTable,):

	auxTable =  pd.DataFrame(pd.date_range(smallTable.iloc[-1,0], BigTable.iloc[-1,0], freq ='D', closed = 'right' ), columns = ['data'])
	col = list(smallTable.columns)
	col.remove('data')
	for c in col:
		auxTable[c] = 0

	smallTable = smallTable.append(auxTable, ignore_index= True)

	return smallTable

if __name__ == '__main__':

	clock = MT.Clock(1)

	clock.startTimer(0,'Starting Read Table',verbose = True)
	table = readTables(['datasets/data.csv', 'datasets/vacinas.csv'], [data_columns, vacinas_columns])
	clock.stopTimer(0,'Duration', verbose = True)


