import sys
import os
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

import math
import tables
import numpy as np
import pandas as pd
import seaborn as sns
from datetime import timedelta

from matplotlib import cm
import matplotlib.colors as mcolors

from sklearn.linear_model import LinearRegression
from sklearn.model_selection import learning_curve

sys.path.append('Python/tables/')
import ReadTables as RT

sys.path.append('Python/classes/')
import myTime as MT
import LSTM_BatchGenerators as BG

def test_LinReg(table, Xcols , target_col ,show = False):
	if show:
		sns.pairplot(table)
		plt.show()

	data = table[Xcols].values
	target = table[target_col].values
	
	
	X,y =data, target

	lin_reg = LinearRegression(normalize = False)

	#print(X.shape, y.shape)
	#print('\tTraining input shape: ', X.shape)
	lin_reg.fit(X,y)

	score = lin_reg.score(X,y)

	return lin_reg, score

def prepDataFrame(table_s, target_s, neg_shift):
	table = table_s.copy()
	target_d = 'targ_'+target_s
	table[target_d] = table[target_s].shift(-neg_shift)

	table = table.iloc[table.ne(0).idxmax()[target_s]:-neg_shift,:] 
	return table

def addTimeShifts(table, colname, nshifts, shift):
	colnames = [colname]
	for n in range(1,nshifts+1):
		colnames += [f'{colname}-{n}']
		table[f'{colname}-{n}'] = table[colname].shift(n*shift)
	return table, colnames


def test_LinearRegression(table, target_shift = 1, n_Lag = 7, length_Lag = 1 ):

	
	table_diff= table.copy()						
	table_diff.iloc[:,1:] = table.iloc[:,1:].diff()
	table_diff = table_diff.iloc[1:,:]				

		
	table_Ativ = prepDataFrame(table_diff, 'ativos', target_shift)	# create target column by performing a time shift of the "ativos" column
	#print('table_Ativ shape PrepDF ', table_Ativ.shape)	

	table_Ativ, colnames = addTimeShifts(table_Ativ, 'ativos', n_Lag, length_Lag)
	#print('table_Ativ shape addTimeShifts ', table_Ativ.shape)
	
	table_Ativ = table_Ativ.iloc[n_Lag*length_Lag:,:]

	Totalsize = len(table_Ativ)
	Testsize = (Totalsize)//4		# 
	Trainsize = Totalsize - Testsize
	
	#print(Trainsize)
	model, score = test_LinReg(table_Ativ.iloc[:Trainsize,:], colnames, 'targ_ativos')
	#a = learning_curve(model, table_Ativ[colnames], table_Ativ['targ_ativos'], train_sizes = [Trainsize])


	myInput = table_Ativ[colnames].iloc[Trainsize:,:].values
	predT = model.predict(myInput)

	predS = StandalonePredict(model, myInput[0].reshape(1,-1), len(myInput), length_Lag)

	TrueX = table_Ativ['ativos'].values

	trained = TrueX[:Trainsize]
	expected = 	TrueX[Trainsize:]


	return model, trained, expected, predT, predS, Trainsize, Testsize, myInput, table_Ativ#, a


def StandalonePredict(model, model_input, length, length_Lag):
	
	preds = []
	row_input = model_input
	for n in range(length):

		pred = model.predict(row_input).item()

		row_input = np.roll(row_input, length_Lag, axis = 1)
		row_input[0,0] = pred

		preds += [pred]

	preds = np.array(preds)
	return preds



def test_NLT_LAG(table, target_shift = 7, n_Lag = 50, length_Lag = 7):
	predS_N_mse  = []
	predT_N_mse = []
	SN_MSE = []
	TN_MSE = []
	
	labels = []
	N_LAGS = []
	LLAGS = []
	target_shifts = []
	input_Shapes = []

	counter = 1
	step = 100
	print(target_shift*n_Lag*length_Lag)

	clock.startTimer(0)
	for n in range(1, n_Lag+1):
		for m in range(1,length_Lag+1):
			for t in range(1, target_shift+1):
				model, trained, expected, predT, predS, Trainsize, Testsize, myInput, table_Ativ = test_LinearRegression(table,t, n, m) # , a


				predS_N_mse += [(predS-expected)**2]
				predT_N_mse += [(predT-expected)**2]

				SN_MSE += [np.mean(predS_N_mse[n-1])]
				TN_MSE += [np.mean(predT_N_mse[n-1])]

				labels += [f'{n} - {m}']
				N_LAGS += [n]
				LLAGS += [m]
				input_Shapes += [myInput.shape]
				target_shifts += [t]
				if counter % step == 0:
					clock.startTimer(clock.stopTimer(0, 'Duration', (True, counter, target_shift*n_Lag*length_Lag, step), verbose = True))
				counter +=1


	Lag_df = pd.DataFrame({'N_LAGS': N_LAGS,
							'LLAGS': LLAGS,
							'TLAGS': target_shifts,
							'predT': TN_MSE,
							'predS': SN_MSE,
							'input shape': input_Shapes
							})
	print(Lag_df)

	#sub_Lag_df = (Lag_df.loc[Lag_df['TLAGS'] == 1].iloc[:,:-1].groupby(by=[ 'N_LAGS']).mean()[['predS']]/(10**6))
	sub_Lag_df = Lag_df.sort_values(by=['predS'])
	sub_Lag_df['predT'] /= 10**6
	sub_Lag_df['predS'] /= 10**6
	sub_Lag_df.round({'predT': 3, 'predS':3})

	fig = plt.figure()
	ax = fig.add_subplot(111, projection = '3d')

	cmap_v = cm.get_cmap('viridis', target_shift)
	cmap = mcolors.LinearSegmentedColormap('my_colormap', cdict, target_shift)

	px = Lag_df['N_LAGS'].values
	py = Lag_df['LLAGS'].values
	pz = Lag_df['predS'].values

	pc = cmap(Lag_df['TLAGS'].values-1)
	pc[:,-1] = 1/target_shift
	#ax.set_color_cycle(pc)
	ax.scatter(px, py, pz, c= pc, s = (target_shift +1-Lag_df['TLAGS'].values)*10)
	ax.set_xlabel('N_LAGS')
	ax.set_ylabel('LLAGS')
	ax.set_zlabel('predS')

	sub2 = sub_Lag_df.loc[ sub_Lag_df['predS'] == sub_Lag_df['predS'].iloc[0] ]

	sub2.hist()

	print(len(sub2), len(sub_Lag_df), f'{100*len(sub2)/ len(sub_Lag_df):.02}')
	print(sub2)
	plt.show()

def test_NLAG(table, target_shift, n_Lag, length_Lag, n_min, n_step):

	fig = plt.figure()
	ax = fig.add_subplot(111, projection = '3d')
	
	for N in range(n_min, n_Lag+1, n_step):
		model, trained, expected, predT, predS, Trainsize, Testsize, myInput, table_Ativ = test_LinearRegression(table,target_shift, N, length_Lag)

		px = [N]*len(predS)
		py = np.arange(len(predS))#table_Ativ['data'].iloc[Trainsize:]
		pz = predS

		pe = expected

		ax.plot(px,py,zs = pe, color = 'darkgreen')
		ax.plot(px,py,zs = pz, color = 'darkblue')
		print(f'N: {N}\t Trainsize: {Trainsize}\t Testsize: {Testsize}\t Total: {Trainsize+Testsize}')

	ax.set_xlabel('N_LAGS')
	ax.set_ylabel('Days')
	ax.set_zlabel('Daily active cases increase')
	print(n_Lag)
	plt.show()



class myDates():
	def __init__(self, ax, fig):
		self.fig = fig
		self.ax = ax

	def set_Locators(self,):
		self.years = mdates.YearLocator()   # every year
		self.months = mdates.MonthLocator()  # every month
		self.days = mdates.DayLocator()	# every year
		self.auto = mdates.AutoDateLocator()
		self.date_fmt = mdates.DateFormatter('%d-%m-%Y')

	def format(self,):		
		self.ax.xaxis.set_major_locator(self.auto)
		self.ax.xaxis.set_minor_locator(self.auto)
		self.ax.xaxis.set_major_formatter(self.date_fmt)

		# format the coords message box
		self.ax.format_xdata = self.date_fmt
		
		# rotates and right aligns the x labels, and moves the bottom of the
		# axes up to make room for them
		self.fig.autofmt_xdate()


class myPlots():
	def __init__(self, data, lcolor=None, scolor=None, label=None, id_in = None, name = None ):
		self.data = data
		self.lcolor = lcolor
		self.scolor = scolor
		self.label = label
		self.id = id_in
		self.name = name
		self.last = data[-1]







cdict = { 'green': ((0.0, 0.0, 0.0),
   					(0.5, 0.5, 0.5),
                   (1.0, 1.0, 1.0)),

			'red':   ((0.0, 1.0, 1.0),
					(0.5, 0.5, 0.5),
                   (1.0, 0.0, 0.0)),

        	'blue':  ((0.0, 0.0, 0.0),
                   (1.0, 0.0, 0.0)),
         	}



if __name__ == '__main__':
	datasetpath = 'datasets/'
	tables2read = [f'{datasetpath}data.csv', f'{datasetpath}vacinas.csv']
	columns2keep = [ RT.data_columns, RT.vacinas_columns ]

	POPULATION = pd.read_csv(f'{datasetpath}/POP.csv')

	clock = MT.Clock(1)

	clock.startTimer(0)
	table = RT.readTables(tables2read, columns2keep, verbose = 0)
	clock.stopTimer(0,'Reading Tables Duration', verbose = True)

	testNLG = False
	testNLag = True
	# Testing ...
	
	if testNLG:
		target_shift = 1#7
		n_Lag = 100
		length_Lag = 1#7

		test_NLT_LAG(table,  target_shift, n_Lag, length_Lag)


	if testNLag:
		n_Lag = 70
		length_Lag = 1
		target_shift = 1
		n_min = 1
		n_step = 7

		test_NLAG(table, target_shift, n_Lag, length_Lag, n_min, n_step)

	# Finished Testing



	n_Lag = 7
	length_Lag = 1
	target_shift = 1


	model, trained, expected, predT, predS, Trainsize, Testsize, myInput, table_Ativ = test_LinearRegression(table,target_shift, n_Lag, length_Lag)
	
	all_values = trained.tolist() + expected.tolist()
	all_values = np.array(all_values)
	
	statistics = pd.DataFrame(table_Ativ['data'].iloc[Trainsize:].values.reshape(-1,1), columns = ['Data'])
	
	statistics['Predicted w/ Test'] = (predT-expected)**2
	statistics['Predicted Standalone'] = (predS-expected)**2
	statistics['Expected'] = (np.mean(expected)-expected)**2
	statistics['Trained'] = (np.mean(trained)-expected)**2
	statistics['All Values'] = (np.mean(all_values) - expected)**2

	stats_mse = statistics.mean()


	predS_mse  = []
	predT_mse = []
	exp_mse = []
	train_mse = []
	all_mse = []


	for n in range(len(predS)):
		mse = np.mean((predS[:n+1] - expected[:n+1])**2)
		predS_mse += [mse]

		mse = np.mean((predT[:n+1] - expected[:n+1])**2)
		predT_mse += [mse]

		mse = np.mean((np.mean(expected) - expected[:n+1])**2)
		exp_mse += [mse]

		mse = np.mean((np.mean(trained) - expected[:n+1])**2)
		train_mse += [mse]

		mse = np.mean((np.mean(all_values) - expected[:n+1])**2)
		all_mse += [mse]


	mses = {
			'all': myPlots(all_mse, lcolor='bisque', scolor = 'darkorange', label='All Values ', id_in = 0, name = 'all' ),
			'trained': myPlots(train_mse, lcolor='lightgray', scolor = 'darkgray', label='Trained ', id_in = 1, name = 'Trained' ),
			'expected': myPlots(exp_mse, lcolor='lightgreen', scolor = 'darkgreen', label='Expected ', id_in = 2, name = 'expected' ),
			'predT': myPlots(predT_mse, lcolor='lightcoral', scolor = 'darkred', label='Predicted w/ Test ', id_in = 3, name = 'predT' ),
			'predS': myPlots(predS_mse, lcolor='lightblue', scolor = 'darkblue', label='Predicted Standalone ', id_in = 4, name = 'predS' )
	}




	fig = plt.figure()
	ax = fig.add_subplot(122)

	ax.plot(table_Ativ['data'], [np.mean(trained)]*(Trainsize+Testsize), color = 'lightgray', label = 'Trained Mean')
	ax.plot(table_Ativ['data'], [np.mean(expected)]*(Trainsize+Testsize), color = 'lightgreen', label = 'Expected Mean')
	ax.plot(table_Ativ['data'], [np.mean(predT)]*(Trainsize+Testsize), color = 'lightcoral', label = 'Predicted w/ Test Mean')
	ax.plot(table_Ativ['data'], [np.mean(predS)]*(Trainsize+Testsize), color = 'lightblue', label = 'Predicted Standalone Mean')

	ax.plot(table_Ativ['data'].iloc[:Trainsize], trained, color = 'darkgray', label = 'Trained')

	ax.plot(table_Ativ['data'].iloc[Trainsize:], expected, color = 'darkgreen', label = 'Expected')

	ax.plot(table_Ativ['data'].iloc[Trainsize:], predT, color = 'darkred', label = 'Predicted w/ Test')

	ax.plot(table_Ativ['data'].iloc[Trainsize:], predS, color = 'darkblue', label = 'Predicted Standalone')

	#ax.set_xticklabels(table_Ativ['data'], rotation = 45)
	formater = myDates(ax,fig)
	formater.set_Locators()
	formater.format()

	ax.grid(True)

	ax.set_ylabel('Daily increase of active cases')


	ax.legend()
	ax.set_title('Extrapolation Values')

	
	

	ax = fig.add_subplot(121, projection = '3d')
	ax.view_init(25, -16)




	ax.set_title('Mean Square Error Range Evolution')
	

	XX = range(1,len(predS_mse)+1)
	#XX = table_Ativ['data'][Trainsize:].values
	labels = []
	for name in mses:
		px=XX
		py=[mses[name].id]*len(predS_mse)
		pz=mses[name].data
		ax.plot(px, py ,pz , color = mses[name].scolor, label = mses[name].label)	
		labels += [mses[name].label]
	
	for name in mses:
		bx = [XX[-1]]
		by = [mses[name].id]
		bz = [mses[name].last]
		ax.bar(by, bz, zs =bx, zdir = 'x', color = mses[name].lcolor, width = 0.4)


	ax.grid(True, axis = 'x', which = 'both')

	ax.set_title('Extrapolation Mean Squared Error')

	ax.set_xlabel('Days After finished Training')
	ax.set_ylabel('Line Ids')
	ax.set_zlabel('MSE')

	ax.legend(loc = 'upper left', bbox_to_anchor = (-0.2, 0.8))

	fig.suptitle('Daily Increase of Active Cases Extrapolation')
	

	#plt.show()


	fig = plt.figure()
	ax = fig.add_subplot(111)	


	ax.plot(range(1,len(predS_mse)+1), [stats_mse['Trained']]*len(predS_mse), color = 'lightgray', label = 'Trained Final Value')
	ax.plot(range(1,len(predS_mse)+1), [stats_mse['Expected']]*len(predS_mse), color = 'lightgreen', label = 'Expected Final Value')
	ax.plot(range(1,len(predS_mse)+1), [stats_mse['Predicted w/ Test']]*len(predS_mse), color = 'lightcoral', label = 'Predicted w/ Test Final value')
	ax.plot(range(1,len(predS_mse)+1), [stats_mse['Predicted Standalone']]*len(predS_mse), color = 'lightblue', label = 'Predicted Standalone Final Value')
	ax.plot(range(1,len(predS_mse)+1), [stats_mse['All Values']]*len(predS_mse), color = 'bisque', label = 'All Values Final Value')

	ax.plot(range(1,len(predS_mse)+1), exp_mse, color = 'darkgreen', label = 'Expected Final Value')	
	ax.plot(range(1,len(predS_mse)+1), train_mse, color = 'darkgray', label = 'Trained Final Value')
	ax.plot(range(1,len(predS_mse)+1), all_mse, color = 'darkorange', label = 'All Values')
	ax.plot(range(1,len(predS_mse)+1),predS_mse, color = 'darkblue', label = 'Predicted Standalone')
	ax.plot(range(1,len(predS_mse)+1), predT_mse, color = 'darkred', label = 'Predicted w/ Test')

	
	ax.legend()

	plt.show()