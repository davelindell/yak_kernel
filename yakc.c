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
YKQ YKQArray[MAXQUEUES];        // Memory for message queue array
YKQ* YKQAvailQList;             // pointer to list of available queues
YKEVENT YKEventArray[MAXEVENTS];        // Memory for event array
YKEVENT* YKAvailEventList;             // pointer to list of available events

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
    // Init Queues
    YKQAvailQList = YKQArray;

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
    cur_tcb->semaphore = NULL;
    cur_tcb->queue = NULL;
    cur_tcb->eventState->event = NULL;
    cur_tcb->eventState->eventMask = 0;
    cur_tcb->eventState->waitMode = 0;
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

tcb_t* YKUnblockTask( tcb_t *task )
{
	tcb_t *temp;

	temp = task->prev;
	if ( temp ) temp->next = task->next;
	else		YKBlockList = task->next;

	temp = task->next;
	if ( temp ) temp->prev = task->prev;
	
	task->prev = 0;
	task->next = 0;
	task->state = READY;
	YKAddReadyTask( task );
	return temp;
}

void YKBlockSEM2Ready(YKSEM* semaphore){
	tcb_t* current;
	current = YKBlockList;

	while ( current )
	{
		if ( current->semaphore == semaphore )
		{
            current->semaphore = NULL;
			current = YKUnblockTask( current );
            continue;
		}
		current = current->next;
	}
    
    return;
}

void YKBlockQ2Ready(YKQ* queue){
	tcb_t* current;
	current = YKBlockList;

	while ( current )
	{
		if ( current->queue == queue )
		{
            current->queue = NULL;
			current = YKUnblockTask( current );
			continue;
		}
		current = current->next;
	}
    return;
}

void YKBlockEvent2Ready(YKEVENT *event){
	tcb_t* current;
    int tmp;
    int unblock_this_task; // don't unblock by default
	
    current = YKBlockList;

	while ( current )
	{
		if ( current->state == EVENT && current->eventState->event == event)
		{
            // compare event flags with the mask
            tmp = event->flags & current->eventState->eventMask;
            unblock_this_task = 0;

            if (current->eventState->waitMode == EVENT_WAIT_ANY) {
                if (tmp > 0)
                    unblock_this_task = 1;
            }    
            else if (current->eventState->waitMode == EVENT_WAIT_ALL) {
                if (tmp == current->eventState->eventMask)
                    unblock_this_task = 1;
            }
            else {
                // this shouldn't happen
                printString("messed up waitmode in YKBlockEvent2Ready. Corrupted tcb?");        
                exit(0);
            }            
            
            if (unblock_this_task) {
                current->eventState->event = NULL;
                current->eventState->eventMask = 0;
                current->eventState->waitMode = 0;
			    current = YKUnblockTask( current );
                continue;
            }
			
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
        YKBlockTask();
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
    
    if (YKISRDepth == 0) {
        YKExitMutex();        
        YKScheduler();
    }
    YKExitMutex();
}   

YKQ *YKQCreate(void **start, unsigned size) {
    // Set up return value
    YKQ *return_val;
    return_val = YKQAvailQList;

    // create a queue and put it in our queue list
    YKQAvailQList->base_addr = start;
    YKQAvailQList->max_length = size;
    YKQAvailQList->head = 0;
    YKQAvailQList->tail = 0;
    YKQAvailQList->size = 0;
    ++YKQAvailQList;
    return return_val;
}

void *YKQPend(YKQ *queue) {
    void *return_data;
    YKEnterMutex();

    if (queue->size == 0) {
        YKCurrTask->state = QUEUE;
        YKCurrTask->queue = queue;
        YKBlockTask(YKCurrTask);
        YKExitMutex();
        YKScheduler();
    }
    
    YKEnterMutex();
    --(queue->size);
    return_data = queue->base_addr[queue->head];
    if ( queue->head == (queue->max_length - 1) )
        queue->head = 0;      
    else
        ++(queue->head);
    YKExitMutex();
    return return_data;
}

int YKQPost(YKQ *queue, void *msg) {
    int return_value;
    // put message into queue
    YKEnterMutex();
    if (queue->size != queue->max_length ) {
        ++(queue->size);
        queue->base_addr[queue->tail] = msg;

        if ( queue->tail == (queue->max_length - 1) )
            queue->tail = 0;      
        else
            ++(queue->tail);
        
        if (queue->size == 1) {
            YKBlockQ2Ready(queue); 
            if (YKISRDepth == 0) {
                YKExitMutex();
                YKScheduler();
            }
        }
        return_value = 1;
    }
    else
        return_value = 0;
    
    YKExitMutex();
    return return_value;
}

YKEVENT *YKEventCreate(unsigned initialValue) {
    // Set up return value
    YKEVENT *return_val;
    return_val = YKAvailEventList;

    // initialize the event
    YKAvailEventList->flags = initialValue;
    ++YKAvailEventList;
    return return_val;
}

unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode) {
    YKEVENT* curr_event;
    unsigned *curr_eventMask;
    int *curr_waitMode;
    int block_this_task;    
    int tmp;    

    block_this_task = 1; //block the task unless the event flags are already what the task is waiting for
    
    // compare event flags with the mask
    tmp = event->flags & eventMask;
    
    if (waitMode == EVENT_WAIT_ANY) {
        if (tmp > 0)
            block_this_task = 0;
    }    
    else if (waitMode == EVENT_WAIT_ALL) {
        if (tmp == eventMask)
            block_this_task = 0;
    }
    else {
        // this shouldn't happen
        printString("Someone passed in the wrong waitMode to YKEventPend");        
        exit(0);
    }
    if (block_this_task) {
        YKEnterMutex();
        YKCurrTask->state = EVENT;
        YKCurrTask->eventState->event = event;
        YKCurrTask->eventState->eventMask = eventMask;
        YKCurrTask->eventState->waitMode = waitMode;
        YKBlockTask(YKCurrTask);
        YKExitMutex();
        YKScheduler(); 
    }
    return event->flags;
}

void YKEventSet(YKEVENT *event, unsigned eventMask) {
    // set the flags    
    event->flags = event->flags | eventMask;

    // grab things from the blocked list and move to ready
    YKEnterMutex();    
    YKBlockEvent2Ready(event);
    YKExitMutex();
    if (YKISRDepth == 0) 
        YKScheduler();
}

void YKEventReset(YKEVENT *event, unsigned eventMask) {
    eventMask = ~eventMask;
    event->flags = event->flags & eventMask;
}


