#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import glob
import time
import base64
import multiprocessing
from ctypes import cast
from ctypes import cdll
from ctypes import c_int
from ctypes import c_ubyte
from ctypes import POINTER
from ctypes import c_char_p
try:
	from PIL import Image, ImageFile
	ImageFile.LOAD_TRUNCATED_IMAGES = True
except:
	print('Install Pillow with "pip3 install Pillow"')
	quit()

inputFolder = r'C:\images\to\be\hashed'

def generateHash(outputFolder, libName, imagePath):
	try:
		workerId = multiprocessing.current_process().name
		imageFile = Image.open(imagePath, 'r')
		if imageFile.mode != 'RGB':
			imageFile = imageFile.convert(mode = 'RGB')
		libPhotoDNA = cdll.LoadLibrary(os.path.join(outputFolder, libName))

		ComputeRobustHash = libPhotoDNA.ComputeRobustHash
		ComputeRobustHash.argtypes = [c_char_p, c_int, c_int, c_int, POINTER(c_ubyte), c_int]
		ComputeRobustHash.restype = c_ubyte

		hashByteArray = (c_ubyte * 144)()
		ComputeRobustHash(c_char_p(imageFile.tobytes()), imageFile.width, imageFile.height, 0, hashByteArray, 0)

		hashPtr = cast(hashByteArray, POINTER(c_ubyte))
		hashList = [str(hashPtr[i]) for i in range(144)]
		hashString = ','.join([i for i in hashList])
		hashList = hashString.split(',')
		for i, hashPart in enumerate(hashList):
			hashList[i] = int(hashPart).to_bytes((len(hashPart) + 7) // 8, 'big')
		hashBytes = b''.join(hashList)
		
		with open(os.path.join(outputFolder, workerId + '.txt'), 'a', encoding = 'utf8') as outputFile:
			#outputFile.write('"' + imagePath + '","' + hashString + '"\n') # uncomment if you prefer base10 hashes
			outputFile.write('"' + imagePath + '","' + base64.b64encode(hashBytes).decode('utf-8') + '"\n')
	except Exception as e:
		print(e)

if __name__ == '__main__':
	outputFolder = os.getcwd()
	if sys.platform == "win32":
		libName = 'PhotoDNAx64.dll'
	elif sys.platform == "darwin":
		libName = 'PhotoDNAx64.so'
	else:
		print('Linux is not supported.')
		quit()
	if (inputFolder == r'C:\images\to\be\hashed'):
		print('Please update the input folder path on row 23.')
		quit()
	startTime = time.time()
	print('Generating hashes for all images under ' + inputFolder)
	
	p = multiprocessing.Pool()
	print('Starting processing using ' + str(p._processes) + ' threads.')
	imageCount = 0
	images = glob.glob(os.path.join(inputFolder, '**', '*.jp*g'), recursive = True)
	images.extend(glob.glob(os.path.join(inputFolder, '**', '*.png'), recursive = True))
	images.extend(glob.glob(os.path.join(inputFolder, '**', '*.gif'), recursive = True))
	images.extend(glob.glob(os.path.join(inputFolder, '**', '*.bmp'), recursive = True))
	for f in images:
		imageCount = imageCount + 1
		p.apply_async(generateHash, [outputFolder, libName, f])
	p.close()
	p.join()
		
	allHashes = []
	for i in range(p._processes):
		try:
			workerId = 'SpawnPoolWorker-' + str(i + 1)
			with open(os.path.join(outputFolder, workerId + '.txt'), 'r', encoding = 'utf8') as inputFile:
				fileContents = inputFile.read().splitlines()
			allHashes.extend(fileContents)
			os.remove(os.path.join(outputFolder, workerId + '.txt'))
			#print('Merged the ' + workerId + ' output.')
		except FileNotFoundError:
			#print(workerId + ' not used. Skipping.')
			pass
	
	with open(os.path.join(outputFolder, 'hashes.csv'), 'a', encoding = 'utf8', errors = 'ignore') as f:
		for word in allHashes:
			f.write(str(word) + '\n')
	
	print('Results saved into ' + os.path.join(outputFolder, 'hashes.csv'))
	print('Generated hashes for ' + f'{imageCount:,}' + ' images in ' + str(int(round((time.time() - startTime)))) + ' seconds.')