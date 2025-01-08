# Code for the method "Directed Network of Angular Similarity (DNAS)", from the work "Complex Networks for Modeling Texture and Spectral Features of Hyperspectral Images for Environmental Analysis"


## Usage
* Make sure you have a `mex` compiler and that you can run/compile the `.cpp` source files.

* The main script is `run.m`. It extract features with DNAS using the given `rset` (radius set, e.g. [1,4] as in the paper). `base` is the path to the dataset.

```
[data, classes] = run(base, rset)
```

* It extract features, train classifiers and show classification results. If you want to use the DNAS features with other classifiers or applications, the script also returns `data`, a matrix with DNAS features for each image, and `classes`, a vector with the ground-truth class of each image (row of the matrix `data`).
