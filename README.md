## The Eigenfacebook
================

a Matlab GUI for creating a database of eigenface-profiles and accessing profiles using a login picture


### Steps needed for eigenface approach

1. Assemble all photos into one mean-difference matrix ```M```

2. Assemble the reference image into a mean-difference vector ```T```

3. Obtain the projection matrix ```U``` from the SVD for ```M```

4. Obtain the weight-score of ```U``` on ```M```, ie ```U'*M```

5. Obtain the weight-score of ```U``` on ```T```, ie ```U'*T```

6. Obtain the minimal Euclidean Distance between ```U'*T``` and ```U'*M```, ie find ```min(sum((U'*M-U'*T).^2))```.