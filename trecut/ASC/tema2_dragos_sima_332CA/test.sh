#!/bin/bash

cat out/MyTestGcc-N.o* | (read; read; cat)
 
cat out/MyTestGcc-O.o* | (read; read; cat)

cat out/MpiTestGcc-Q.o* | (read; read; cat)

