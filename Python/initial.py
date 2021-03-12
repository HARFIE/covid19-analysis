import sys
import os
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

import math
import tables
import numpy as np
import pandas as pd


class Population():
	self.norte = 3818722
	self.lvt = 2808414
	self.centro = 2348453
	self.alentejo = 776339
	self.algarve = 395208
	self.madeira = 245012
	self.acores = 244 006

	self.total = 10636154

def read_csv(name):
	data = pd.read_csv(f'{name}.csv')

	data['data'] = data['data'].astype(np.datetime64)
	data['data_dados'] = data['data_dados'].astype(np.datetime64)
	data.sort_values(by = 'data', inplace = True)

	return data

class Plotter():

	def __init__(self, data, plotter_name = None):
		self.data = data
		self.name =plotter_name
	def set_Locators(self,):
		self.years = mdates.YearLocator()   # every year
		self.months = mdates.MonthLocator()  # every month
		self.days = mdates.DayLocator()
		self.years_fmt = mdates.DateFormatter('%d-%m-%Y')


	def My_plot(self, date_col, data_col, label = None, fig = None, ax = None, show = False):
		if not fig and ax:
			self.fig, self.ax = plt.subplots()
		else:
			self.fig , self.ax = fig,ax
		ini = 0 #None
		fin = None #None
		self.ax.plot(self.data[date_col][ini:fin], self.data[data_col][ini:fin], label = label)

		# format the ticks
		self.ax.xaxis.set_major_locator(self.months)
		self.ax.xaxis.set_major_formatter(self.years_fmt)
		self.ax.xaxis.set_minor_locator(self.days)

		# round to nearest years.
		
		#datemin = np.datetime64(data['data'], 'Y')
		#datemax = np.datetime64(data['data'], 'Y') + np.timedelta64(1, 'Y')
		#ax.set_xlim(datemin, datemax)

		# format the coords message box
		self.ax.format_xdata = mdates.DateFormatter('%d-%m-%Y')
		#ax.format_ydata = lambda x: '$%1.2f' % x  # format the price.
		self.ax.grid(True)

		# rotates and right aligns the x labels, and moves the bottom of the
		# axes up to make room for them
		self.fig.autofmt_xdate()
		self.ax.set_title(data_col)
		if show:
			plt.show()

	def plotConfRegion(self):
		fig, ax = plt.subplots()
		counter = 0
		self.data_backup = self.data.copy()

		for col in self.data.columns:
			if (col != 'data') and (len(col.split('_')) ==2) and ('confirmados' in col) and (counter < 8):
				ploter.My_plot('data', col, fig = fig, ax = ax, label = col)
				counter +=1
				print(f'Figure {counter} - {col}')
		plt.legend()
		plt.show()
		self.data = self.data_backup

if __name__ == '__main__':

	print('hello')

	database =read_csv('data') #filename
	print(database)

	ploter = Plotter(database, 'data csv')
	ploter.set_Locators()

	#ploter.plotConfRegion()

	# Normalize data


	



	