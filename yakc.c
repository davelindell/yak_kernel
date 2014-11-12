#include "yakk.h"
int YKCtxSwCount;
unsigned YKTickNum;
unsigned YKIdleCount;
int YKISRDepth;
int YKRunFlag;

int YKErrorFlag;        // All purpose error flag variable (should always be 0)


tcb_t *YKRdyList;        /* a list of TCBs of all ready tasks in order of decreasing priority */
tcb_t *YKBlockList;      /* tasks delayed or suspended */
tcb_t *YKAvailTCBList;       /* a list of available TCBs */
tcb_t YKTCBArray[MAXTASKS+1];    /* array to allocate all needed TCBs (extra one is for the idle task) */
tcb_t *YKCurrTask;
int YKIdleTaskStack[IDLE_STACK_SIZE]; /* idle task stack */
YKSEM YKSEMArray[MAXSEMAPHORES];
YKSEM* YKAvailSEMList;

void YKIdleTask(void) {
	int dummy;
    while(1){
		++dummy;
		--dummy;
		++dummy;
        ++YKIdleCount;
    }
}

void YKInitialize(void) {
    // Init Tasks
    void (*idle_task_p)(void);
    void *idle_task_stack_p; 
    int lowest_priority = 100;
    YKCtxSwCount = 0;
    YKTickNum = 0;
    YKIdleCount = 0;
    YKISRDepth = 0;
    YKRunFlag = 0;
	YKBlockList = 0;
    YKRdyList = NULL;    
    YKCurrTask = NULL;
    idle_task_p = YKIdleTask;
    idle_task_stack_p = YKIdleTaskStack + IDLE_STACK_SIZE - 1;
    lowest_priority = 100;
    YKErrorFlag = 0;
    
    // Init Semaphores
    YKAvailSEMList = YKSEMArray;

    // Finish
    YKAvailTCBList = YKTCBArray;
    YKNewTask(idle_task_p, idle_task_stack_p, lowest_priority);
}

//void YKEnterMutex(void)

//void YKExitMutex(void)

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority) {
    tcb_t *cur_tcb = YKAvailTCBList;
    YKAvailTCBList++;
    cur_tcb->ax = 0;
    cur_tcb->bx = 0;
    cur_tcb->cx = 0;
    cur_tcb->dx = 0;
    cur_tcb->ip = task;
    cur_tcb->sp = taskStack;
    cur_tcb->bp = taskStack;
    cur_tcb->si = 0;
    cur_tcb->di = 0;
    cur_tcb->cs = 0;
    cur_tcb->ss = 0;
    cur_tcb->ds = 0;  
    cur_tcb->es = 0;
    cur_tcb->flags = 512; //O:0 D:0 I:1 T:0 S:0 Z:0 A:00 P:00 C:00 
    cur_tcb->priority = priority;
    cur_tcb->state = READY;
    cur_tcb->delay = 0;
    cur_tcb->prev = 0;
    cur_tcb->next = 0;
    YKAddReadyTask(cur_tcb);

    if (YKRunFlag) {
        YKScheduler();
    }
}

void YKRun(void) {
    YKRunFlag = 1;
    YKScheduler();
}

int print_ready_list(void)
{
    int count = 0;
	tcb_t* iter = YKRdyList;
	while( iter )
	{
		printInt( iter->priority );
		printNewLine();
		iter = iter->next;
        ++count;
	}
    return count;
}

int print_delay_list(void)
{   
    int count = 0;
	tcb_t* iter = YKBlockList;
	while( iter )
	{
		printInt( iter->priority );
        if (iter->state == DELAYED) {
		    printString( " Delay: " );
		    printInt( iter->delay );
        }
        else if (iter->state == SEMAPHORE) {
		    printString( " Semaphore: " );
		    printInt( iter->semaphore->value );
        }
		printNewLine();
		iter = iter->next;
        ++count;
	}
    return count;
}  

void YKScheduler(void) {
    if (YKCurrTask != YKRdyList) { // going to change contexts
		/*print_ready_list();
		printString("DispatchingTask: ");
		printInt(YKRdyList);
		printNewLine();
		printString("CurTask: ");
		printInt(YKCurrTask);
		printNewLine();
        int count;        
        YKEnterMutex();        
        printNewLine();
        printString("Block List:");
        printNewLine();
	    count = print_delay_list();
        printString("Ready List:");
        printNewLine();
        count += print_ready_list();
        if (count != 6)
            YKErrorFlag = 1;
        YKExitMutex();*/

        YKDispatcher();
    }
}


void YKAddReadyTask(tcb_t *cur_tcb) {    
    int moved_to_top;
    tcb_t* iter;
    if(YKRdyList == NULL) {
        YKRdyList = cur_tcb;
    }
    else {
        iter = YKRdyList;
        moved_to_top = 1;
        while (cur_tcb->priority > iter->priority) {
            iter = iter->next;
            moved_to_top = 0;
        }
        cur_tcb->next = iter;
        if (iter->prev) 
            iter->prev->next = cur_tcb;  

        cur_tcb->prev = iter->prev;             
        iter->prev = cur_tcb;

        if (moved_to_top)
            YKRdyList = cur_tcb;
    }
    return;
}

void YKBlockTask(){
    // readjust ready list
    YKRdyList = YKCurrTask->next;
    YKRdyList->prev = NULL;

    // put tcb in blocked list
    if (YKBlockList == NULL) {
        YKBlockList = YKCurrTask;
		YKBlockList->next = 0;
    }
    else if ( YKBlockList->priority > YKCurrTask->priority )
	{
		YKCurrTask->next = YKBlockList;
		YKBlockList->prev = YKCurrTask;
		YKCurrTask->prev = 0;
		YKBlockList = YKCurrTask;
	}
	else
	{
        tcb_t *iter = YKBlockList;
        while ( iter->next && YKCurrTask->priority > iter->next->priority ) {
            iter = iter->next;
        }

        YKCurrTask->next = iter->next;
        if (iter->next) 
            iter->next->prev = YKCurrTask;  

        YKCurrTask->prev = iter;             
        iter->next = YKCurrTask;
    }
}

void YKBlock2Ready(tcb_t *task){
	tcb_t* current;
    tcb_t* temp;
	current = YKBlockList;

	while ( current )
	{
		if ( current == task )
		{
			temp = current->prev;
			if ( temp ) temp->next = current->next;
			else		YKBlockList = current->next;

			temp = current->next;
			if ( temp ) temp->prev = current->prev;
			
			current->prev = 0;
			current->next = 0;
			current->state = READY;
			YKAddReadyTask( current );
			current = temp;
			continue;
		
		}
		current = current->next;
	}
    return;
}

void YKBlockSEM2Ready(YKSEM* semaphore){
	tcb_t* current;
    tcb_t* temp;
	current = YKBlockList;

	while ( current )
	{
		if ( current->semaphore == semaphore )
		{
			temp = current->prev;
			if ( temp ) temp->next = current->next;
			else		YKBlockList = current->next;

			temp = current->next;
			if ( temp ) temp->prev = current->prev;
			
			current->prev = 0;
			current->next = 0;
			current->state = READY;
			YKAddReadyTask( current );
			current = temp;
			continue;
		
		}
		current = current->next;
	}
    return;
}

void YKDelayTask(unsigned count) {
    // modify tcb to add delay count
    YKCurrTask->delay = count;
	YKCurrTask->state = DELAYED;

    // block the current task
    YKEnterMutex();
    YKBlockTask();
    YKExitMutex();    

    // call scheduler
    YKScheduler();
}

void YKEnterISR(void) {
    ++YKISRDepth;
}
void YKExitISR(void) {
    --YKISRDepth;
    /*printNewLine();
    printString("ISR Depth:"); 
    printInt(YKISRDepth);
    printNewLine();*/
    if (YKISRDepth == 0) {
        YKScheduler();
    }
}

YKSEM* YKSemCreate(int initialValue) {
    YKSEM* return_val;
    YKAvailSEMList->value = initialValue;
    return_val = YKAvailSEMList;
    ++YKAvailSEMList; 
    return return_val;
}

void YKSemPend(YKSEM *semaphore) {
    int available;
    YKEnterMutex();

    // check if available and decrement semaphore
    available = semaphore->value > 0 ? 1 : 0;
    --(semaphore->value);

    // if not available, block and change tcb state to semaphore
    if (!available) {
        YKCurrTask->state = SEMAPHORE;
        YKCurrTask->semaphore = semaphore;        
        YKBlockTask(YKCurrTask);
    }

    YKExitMutex();

    // call scheduler
    // if (!available)
        YKScheduler();
}

void YKSemPost(YKSEM *semaphore) {    
    YKEnterMutex();
    ++(semaphore->value);
    if (semaphore->value > 1)
        semaphore->value = 1;

    if (semaphore->value < 1)  {
        YKBlockSEM2Ready(semaphore);  
         
    }
    
    if (YKISRDepth == 0)
        YKScheduler();
    YKExitMutex();
}   

YKQ *YKQCreate(void **start, unsigned size) {
    
}

void *YKQPend(YKQ *queue) {
    
}

int YKQPost(YKQ *queue, void *msg) {
    
}


