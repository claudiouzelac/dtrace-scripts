#!/usr/sbin/dtrace -s
#pragma D option quiet

/*
 * memcall.d
 *
 * Prints The mmap and brk
 * Memory Calls that Happen
 * Over one second
 *
 */


/* Starts the Program */
dtrace:::BEGIN
{
        printf("Printing out amount of memory calls and average Time per second");
}

/* Marks each time mmap is called */
::mmap:entry
{
        @P[pid, execname, arg1] = count();
        this->start = timestamp;
}

/* Marks each time brk is called */
::brk:entry
{
        @Q[pid, execname] = count();
        this->beginning = timestamp;
}

/* Adds time to average */
::mmap:return
{
        this->finish = timestamp;
        @A[pid, execname] = avg(this->finish - this->start);
}

/* Adds time to average  */
::brk:return
{
        this->tail = timestamp;
        @B[pid, execname] = avg(this->tail - this->beginning);
}


/* Prints out all the values each Second */
profile:::tick-1sec
{

        printf("\n%-10s", "mmap");
        printf("\n%-10s %-15s %-10s %-10s\n", "PID", "EXECNAME", "SIZE", "COUNT");
        printa("%-10d %-15s %-10d %-10@d\n", @P);
        printf("%-10s %-15s %-10s\n", "PID", "EXECNAME", "AVGTIME");
        printa("%-10d %-15s %-10@d\n", @A);

        printf("\n%-10s", "brk");
        printf("\n%-10s %-15s %-10s\n", "PID", "EXECNAME", "COUNT");
        printa("%-10d %-15s  %-10@d\n", @Q);
        printf("%-10s %-15s %-10s\n", "PID", "EXECNAME", "AVGTIME");
        printa("%-10d %-15s %-10@d\n", @B);

        trunc(@P);
        trunc(@Q);
        trunc(@B);
        trunc(@A);
}
