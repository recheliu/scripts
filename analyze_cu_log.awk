#!/bin/awk -f

# This script is used to parse the CUDA's performance log in .csv format.
BEGIN {
    # Get the current script's name.
    # Reference: http://www.mombu.com/programming/programming/t-the-name-of-script-itself-2040784.html
    getline t < "/proc/self/cmdline"; split(t,T,"\0");

    # Print the usage.
    printf("Usage: %s < <cu.csv>\n", T[3]);

    # Reset the counters.
    uNrOfMemcpyHtoD = 0; fTimeForMemcpyHtoD = 0.0;
    uNrOfMemcpyDtoH = 0; fTimeForMemcpyDtoH = 0.0;
    uNrOfKernelCalls = 0; fTimeForKernelCalls = 0.0;
    FS = ",";
}
/^memcpyHtoD/ {
    uNrOfMemcpyHtoD++;
    fTimeForMemcpyHtoD += $2;
}
/^memcpyDtoH/ {
    uNrOfMemcpyDtoH++;
    fTimeForMemcpyDtoH += $2;
}
/^_Z/ {
    uNrOfKernelCalls++;
    fTimeForKernelCalls += $2;
}
// {
    ; # do nothing
}
END {
    print ",\t#H2D,\t#D2H,\t#Kernels";
    printf("#,\t%d,\t%d,\t%d\n", uNrOfMemcpyHtoD, uNrOfMemcpyDtoH, uNrOfKernelCalls);
    printf("Total,\t%.2f,\t%.2f,\t%.2f\n",
        fTimeForMemcpyHtoD, fTimeForMemcpyDtoH, fTimeForKernelCalls);
    printf("Avg.,\t%.2f,\t%.2f,\t%.2f\n",
        fTimeForMemcpyHtoD / uNrOfMemcpyHtoD,
        fTimeForMemcpyDtoH / uNrOfMemcpyDtoH,
        fTimeForKernelCalls / uNrOfKernelCalls);
}
