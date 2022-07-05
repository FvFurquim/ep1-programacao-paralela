#! /bin/bash

set -o xtrace

MEASUREMENTS=10
ITERATIONS=10
INITIAL_SIZE=16

SIZE=$INITIAL_SIZE

NAMES=('mandelbrot_pth' 'mandelbrot_omp')
N_THREADS=('2' '4' '8' '10' '16' '32')

make
mkdir results

for NAME in ${NAMES[@]}; do
    for N_TH in ${N_THREADS[@]}; do
        mkdir results/$NAME/
        mkdir results/$NAME/$N_TH

        for ((i=1; i<=$ITERATIONS; i++)); do
                perf stat -r $MEASUREMENTS ./$NAME -2.5 1.5 -2.0 2.0 $SIZE $N_TH >> full.log 2>&1
                perf stat -r $MEASUREMENTS ./$NAME -0.8 -0.7 0.05 0.15 $SIZE $N_TH >> seahorse.log 2>&1
                perf stat -r $MEASUREMENTS ./$NAME 0.175 0.375 -0.1 0.1 $SIZE $N_TH >> elephant.log 2>&1
                perf stat -r $MEASUREMENTS ./$NAME -0.188 -0.012 0.554 0.754 $SIZE $N_TH >> triple_spiral.log 2>&1
                SIZE=$(($SIZE * 2))
        done

        SIZE=$INITIAL_SIZE

        mv *.log results/$NAME/$N_TH
        rm output.ppm
    done
done
