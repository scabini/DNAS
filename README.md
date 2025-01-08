# Code for the method "Directed Network of Angular Similarity (DNAS)", from the work "Complex Networks for Modeling Texture and Spectral Features of Hyperspectral Images for Environmental Analysis"


## Usage
* Make sure you have a `mex` compiler and that you can run/compile the `.cpp` source files.

* The main script is `run.m`. It extract features with DNAS using the given `rset` (radius set, e.g. [1,4] as in the paper). `base` is the path to the dataset with `.lsm` image files with names `class1_sample1.lsm`, `class1_sample2.lsm`, ... , `class2_sample1.lsm`... etc.

```
[data, classes] = run(base, rset)
```

* It extract features, train classifiers and show classification results. If you want to use the DNAS features with other classifiers or applications, the script also returns `data`, a matrix with DNAS features for each image, and `classes`, a vector with the ground-truth class of each image (corresponding to rows of the matrix `data`).

## Dataset

* You can also download the biological dataset used in the paper. It contains 148 CLSM hyperspectral images from leaves of Jacaranda Caroba specimens under different pollutant levels.
* link TBA
