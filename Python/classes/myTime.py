import time as t
import math
import numpy as np

def Prints(oldS, oldC, oldSu, s,c,su, clock, verbose = False):
	
	if su-1 != oldSu:
		clock.startTimer(clock.stopTimer(1, f'\t\t\t\tSubject {oldSu+1}', verbose = verbose))

		oldSu = su-1
		startSu =t.time_ns()

	if c-1 != oldC:
		clock.startTimer(clock.stopTimer(2,f'\t\tCamera {oldC+1}',verbose = verbose))

		oldC = c-1
		startC =t.time_ns()


	if s-1 != oldS:
		clock.startTimer(clock.stopTimer(3, f'Setup {oldS+1}',eta=(verbose, oldS+1, 18,1),verbose = verbose))
		
		oldS = s-1
		startS =t.time_ns()

	return oldS, oldC, oldSu


def buildTime(ns):
    ms = ns/1000000
    Hour= getHour(ms)
    Min = getMin(ms)
    Sec = getSec(ms)
    Ms = getMs(ms)
    return f'{int(Hour)}:{int(Min)}:{int(Sec)} - {int(Ms):03}'

def getHour(ms):
    Vhour=ms/(1000*60*60)
    return Vhour
def getMin(ms):
    Vmin= getHour(ms)-math.floor(getHour(ms))
    return Vmin * 60
def getSec (ms):
    Vsec = getMin(ms)- math.floor(getMin(ms))
    return Vsec * 60
def getMs(ms):
    Vms= getSec(ms)- math.floor(getSec(ms))
    return Vms*1000


class Timer:
	def __init__(self, n):
		self._start = 0
		self._dur = 0
		self.id = n
		
		self.durs = np.zeros((100,)) 
		self.durs_leng = 0
		self.avg_dur = 0
	
	def start(self,message = '', name = None, pETA = False, actual = 0, final = 0,verbose = False):

		self._start = t.time_ns()
		
		if name:
			self.name = name
		if verbose:
				print('\t'*self.id+f'{message} ')

	def stop(self, message = '', pETA = False, actual = 0, final = 0, step = 1,verbose = False):


		
		self._dur = t.time_ns() - self._start

		if self.durs_leng < self.durs.shape[0]:
			self.durs[self.durs_leng] = self._dur
			self.durs_leng += 1
		else:
			self.durs = np.roll(self.durs, -1)
			self.durs[-1] = self._dur

		self.avg_dur = np.average(self.durs[:self.durs_leng])

		if verbose:
			if pETA:
				#print(final, actual)
				eta = self.avg_dur * ((final- actual)/step)
				print('\t'*self.id+f'{message}: {buildTime(self._dur)} ms\t ETA: {buildTime(eta)} ms\t avg = {buildTime(self.avg_dur)} ms')
			else:
				print('\t'*self.id+f'{message}: {buildTime(self._dur)} ms\t ')
		return self.id

class Clock:
	usable = []
	def __init__(self, n_timers=0):
		self.timers = [Timer(n) for n in range(n_timers)]
		self.usable = list(range(n_timers))

	def startTimer(self, n=None, message='',verbose = False):
		if len(self.usable)>0 :
			if n==None:
				n=self.usable[0]
			elif(n in self.usable): 
				self.timers[n].start(message = message, verbose = verbose)
				i = self.usable.index(n)
				self.usable.pop(i)
			else: 
				return -1
		else:
			n = len(self.timers)
			self.timers += [Timer(n)]
			self.timers[n].start()
		return n

	def stopTimer(self,n, message = '',eta = (False, 0,0,1) , verbose = False):
		if ( n in self.usable):
			raise Exception(f'Timer {n} not started')
		pETA = eta[0]
		if pETA:
			actual = eta[1]
			final = eta[2]
			step = eta[3]
			ret=self.timers[n].stop(message,pETA = pETA, actual = actual, final = final, step = step, verbose = verbose)				
		else:
			ret=self.timers[n].stop(message, verbose = verbose)
		self.usable += [n]
		return ret
