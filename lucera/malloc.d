#!/usr/sbin/dtrace -s
#pragma D option quiet

/*
 * malloc.d
 *
 * Prints The Failed Malloc
 * Calls for a given Process
 *
 * Usage: malloc.d PID
 *
 */

dtrace:::BEGIN
{
            printf("Looking for failed Mallocs\n");
}

/* Traces the failed malloc call  */
pid$1::malloc:return
/arg1 < 0 /
{
            printf("%-10s %-15s %-10s", "PID", "EXECNAME", "FAILEDarg");
            printf("\n %-10d %-15s %-10d\n" , pid, execname, arg1);
            @a[pid, execname] = count();
}

/* Prints the final malloc totals */
dtrace:::END
{
            printf("\n%-10s %-15s %-10s ", "PID", "EXECNAME", "COUNTS");
            printa("\n%-10d %-15s %-10@d", @a);
}
