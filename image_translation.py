import tensorflow as tf
import keras
import cv2
import numpy as np
from keras.models import load_model
import matplotlib
import os
import matplotlib.image
from PIL import Image
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import statistics

path_1 = r'/home/Sanjay/TUMGAID_pix2pix_GAN/GEI_TUMGAID_GAN/'
files = os.listdir(path_1)
for names in files:
    print(names)
    generator = load_model(path_1 + names)
    path1 = '/DATA/Sanjay/TUMGAID_data_analysis/Depth_Cropped_Fliped_Renamed_BinaryImageShifted_Fliped_PEI_06/'
    path_2 = '/DATA/Sanjay/TUMGAID_data_analysis/TUMGAID_data_analysis/Depth_Cropped_Fliped_Renamed_BinaryImageShifted_Fliped_PEI_06_pix2pix/'
    subjects = os.listdir(path1)
    print(path1)
    numberOfSubject = len(subjects)
    for number1 in range(0, numberOfSubject):#115
        path2 = (path1 + subjects[number1] + '/')
        sequences = os.listdir(path2)
        print(path2)
        numberOfsequences = len(sequences)
        for number2 in range(0, numberOfsequences):
            path3 = (path2 + sequences[number2])
            # print(path3)
            img = cv2.imread(path3)
            # print(img.shape)
            img = cv2.resize(img, (256, 256))
            # print(img.shape)
            img = np.array(img) / 255.0
            img = np.expand_dims(img, axis=0)
            # print(img.shape)
            img1 = generator.predict(img)
            img_1 = np.reshape(img1, (256, 256, 3))
            # print(img_1.shape)
            img_1[img_1 < 0] = 0
            # print(img_1.shape)
            img = img_1 / (img_1.max())
            arr1 = path2.split('/')
            path = path_2 + '/' + arr1[len(arr1) - 2] + '/'
            # print(path)

            try:
                os.makedirs(path)
            except OSError:
                print("Creation of the directory %s failed" % path)
            else:
                print("Successfully created the directory %s " % path)
            arr1 = path3.split('/')
            path = path + arr1[len(arr1) - 1]
            # print(path)
            matplotlib.image.imsave(path, img)
            # cv2.imwrite(path,img_1)
