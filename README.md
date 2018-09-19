# Moving Object Detection through Robust MatrixCompletion Augmented with Objectness    

## 1. Introduction
This is the code for the following paper:

B. Rezaei, S. Ostadabbas, “Moving Object Detection through Robust Matrix Completion Augmented with Objectness,” IEEE Journal of Selected Topics in Signal Processing (J-STSP), August 2018.

This paper has supplementary downloadable material on qualitative comparison of the  augmented fRMC against other object detection methods available at \href{http://www.coe.neu.edu/Research/AClab/J-STSP-2018-supplementary/}{J-STSP-2018-Sup}, provided by the authors. Contact the corresponding author for further questions about this work.

Contact: 
[Behnaz Rezaei](brezaei@ece.neu.edu),

[Sarah Ostadabbas](ostadabbas@ece.neu.edu)


## 2. Installation

This code is written for Matlab (tested with versions 2016 and later) and requires the Matlab Image Processing and Computer Vision Toolbox.
Code was tested in windows machine but there should not be any problem running on Mac or Linux.
In addition it requires Piotr's Matlab Toolbox (version 3.26 or later) which can be downloaded at: https://pdollar.github.io/toolbox/.
for finding the candidate object with highest objectness we use the edgeBoxes function provided in https://github.com/pdollar/edges.
you do not need to download the corresponding functions seperately. they are provided in this repository.


## 3. Getting started
before starting to use the code you need to clone fRMC code from https://github.com/ostadabbas/fRMC


## 4. Contents

Code:
   Aug_fRMC	- main function which applies the augmented fRMC on a matrix containing the video frames in each column.
   performance_eval_CRMI13      	- function for generating the evaluation metrics on the selected videos of CRMI13 dataset
   run-aug_fRMC              - script for running the aug_fRMC on the CRMI13 videos

Other:
	ground-truth    - folder containing the ground truth images of the selected video of the CRMI13 dataset
	videos          - folder containing the 
    readme.txt  	- This file.


## 5. History / ToDo

Version 1.0 (09/05/2018)
 - initial version

####################################################################

## 6. Citation 
If you find our work useful in your research please consider citing our paper:
```
@article{rezaei2018moving,
  title={Moving Object Detection through Robust Matrix Completion Augmented with Objectness},
  author={Rezaei, Behnaz and Ostadabbas, Sarah},
  journal={IEEE Journal of Selected Topics in Signal Processing},
  year={2018},
  publisher={IEEE}
}
```
and
```
@inproceedings{rezaei2017background,
  title={Background Subtraction via Fast Robust Matrix Completion},
  author={Rezaei, Behnaz and Ostadabbas, Sarah},
  booktitle={Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
  pages={1871--1879},
  year={2017}
}
```
## 7. License 
* This code is for non-commertial purpose only. For other uses please contact ACLab of NEU. 
* No maintainence survice 

## 8. Acknowledgements
[1] Zitnick, C. Lawrence, and Piotr Dollar. "Edge boxes: Locating object proposals from edges." In European conference on computer vision, pp. 391-405. Springer, Cham, 2014.

[2] Dollar, Piotr, and C. Lawrence Zitnick. "Fast edge detection using structured forests." IEEE transactions on pattern analysis and machine intelligence 37, no. 8 (2015): 1558-1570.
