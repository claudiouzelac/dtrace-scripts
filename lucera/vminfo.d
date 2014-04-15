#!/usr/sbing/dtrace -s
#pragma D option quiet

/*
 * vminfo.d
 *
 * Returns all the paging calls
 * Done in the past second.
 *
 */

dtrace:::BEGIN
{
    printf("Virtual Memory Statistics DTrace");
}

/* Increases the count each time
* A virtual Memory Probe is increased  */
vminfo:::
{
    @A[pid, execname, probename] = count();
}

/* Print out Virtual Memory Stats */
profile:::tick-1sec
{
    printf("\nNew Second\n");
    printf("%10-s %-10s %-15s %-10s\n", "PID", "EXECNAME", "VMINFOCALL", "COUNTS");
    printa("%-10d %-10s %-15s %-10@d\n", @A);
    trunc(@A);
}
