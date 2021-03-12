import tables as tb
import numpy as np
import os 
import time as t
import math
import matplotlib.pyplot as plt
import sys

class Sample(tables.IsDescription):
	data = tables.StringCol(pos = 0)
	data
	data_dados
	confirmados
	confirmados_arsnorte
	confirmados_arscentro
	confirmados_arslvt
	confirmados_arsalentejo
	confirmados_arsalgarve
	confirmados_acores
	confirmados_madeira
	confirmados_estrangeiro
	confirmados_novos
	recuperados
	obitos
	internados
	internados_uci
	lab
	suspeitos
	vigilancia
	n_confirmados,
	cadeias_transmissao,
	transmissao_importada,
	confirmados_0_9_f,
	confirmados_0_9_m,
	confirmados_10_19_f,
	confirmados_10_19_m,
	confirmados_20_29_f,
	confirmados_20_29_m,
	confirmados_30_39_f,
	confirmados_30_39_m,
	confirmados_40_49_f,
	confirmados_40_49_m,
	confirmados_50_59_f,
	confirmados_50_59_m,
	confirmados_60_69_f,
	confirmados_60_69_m,
	confirmados_70_79_f,
	confirmados_70_79_m,
	confirmados_80_plus_f,confirmados_80_plus_m,sintomas_tosse,sintomas_febre,sintomas_dificuldade_respiratoria,sintomas_cefaleia,sintomas_dores_musculares,sintomas_fraqueza_generalizada,confirmados_f,confirmados_m,obitos_arsnorte,obitos_arscentro,obitos_arslvt,obitos_arsalentejo,obitos_arsalgarve,obitos_acores,obitos_madeira,obitos_estrangeiro,recuperados_arsnorte,recuperados_arscentro,recuperados_arslvt,recuperados_arsalentejo,recuperados_arsalgarve,recuperados_acores,recuperados_madeira,recuperados_estrangeiro,obitos_0_9_f,obitos_0_9_m,obitos_10_19_f,obitos_10_19_m,obitos_20_29_f,obitos_20_29_m,obitos_30_39_f,obitos_30_39_m,obitos_40_49_f,obitos_40_49_m,obitos_50_59_f,obitos_50_59_m,obitos_60_69_f,obitos_60_69_m,obitos_70_79_f,obitos_70_79_m,obitos_80_plus_f,obitos_80_plus_m,obitos_f,obitos_m,confirmados_desconhecidos_m,confirmados_desconhecidos_f,ativos,internados_enfermaria,confirmados_desconhecidos
	camera = tables.IntCol(pos = 1)
	subject = tables.IntCol(pos = 2)
	replication = tables.IntCol(pos = 3)
	action = tables.IntCol(pos = 4)

	length = tables.IntCol(pos = 5)
	begining = 	tables.IntCol(pos = 6)
	
	vname =  tables.StringCol(20, pos = 7)