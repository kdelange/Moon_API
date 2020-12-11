#!/usr/bin/env python

import json
import csv
import argparse

parser = argparse.ArgumentParser(description='Process json file from moon, containing parent vcf file and numer information')
parser.add_argument('--json', help='json file from moon with all the sample names and numbers')
parser.add_argument('--inn', help='txt file with patient and parent information, , separated')
parser.add_argument('--outt', help='txt file with patient and parent information, and parents numbers from moon added')

args = parser.parse_args()
print('json file:', args.json)
print('inn file:', args.inn)
print('outt file:', args.outt)



f = open(args.json,)
data = json.load(f)

header = False
with open(args.inn, 'r') as info:
	for line in info:
		print('line: ',line)
		splitline = line.split(',')
		print('splitline: ',splitline)
		motherID = splitline[5]
		print('motherID: ',motherID)
		fatherID = splitline[7]
		print('fatherID: ',fatherID)
		for sample_dict in data['samples']:
			if sample_dict['name'] == motherID:
				motherLine = str.rstrip(line)
				print('motherLine: ',motherLine)
				motherLine1 = motherLine+','+str(sample_dict['id'])
				print('motherLine1: ',motherLine1)
		for sample_dict in data['samples']:
			if sample_dict['name'] == fatherID:
				print('sample_dict: ',sample_dict)
				print('motherLine1: ',motherLine1)
				finalLine = motherLine1+','+(str(sample_dict['id']))
				print('finalLine: ',finalLine)
				with open(args.outt, 'a') as outfile:
					if header == False:
						outfile.write('file,gender,project_id,age,hpo_terms,mother,mother_health,father,father_health,motherID,fatherID'+'\n')
						header = True
					outfile.write(finalLine+'\n')
f.close()
