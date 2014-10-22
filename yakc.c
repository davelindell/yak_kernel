#include "yakk.h"
int YKCtxSwCount;
unsigned YKTickNum;
unsigned YKIdleCount;
int YKISRDepth;
int YKRunFlag;


tcb_t *YKRdyList;        /* a list of TCBs of all ready tasks in order of decreasing priority */
tcb_t *YKBlockList;      /* tasks delayed or suspended */
tcb_t *YKAvailTCBList;       /* a list of available TCBs */
tcb_t YKTCBArray[MAXTASKS+1];    /* array to allocate all needed TCBs (extra one is for the idle task) */
tcb_t *YKCurrTask;
int YKIdleTaskStack[IDLE_STACK_SIZE]; /* idle task stack */

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

void YKScheduler(void) {
    if (YKCurrTask != YKRdyList) { // going to change contexts
		/*printString("DispatchingTask: ");
		printInt(YKRdyList);
		printNewLine();
		printString("CurTask: ");
		printInt(YKCurrTask);
		printNewLine();*/
        YKDispatcher();
    }
}


void YKAddReadyTask(tcb_t *cur_tcb) {    
    if(YKRdyList == NULL) {
        YKRdyList = cur_tcb;
    }
    else {
        tcb_t *iter = YKRdyList;
        int moved_to_top = 1;
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

void YKDelayTask(unsigned count) {
    // modify tcb to add delay count
    YKCurrTask->delay = count;
	YKCurrTask->state = DELAYED;

    // readjust ready list
    YKRdyList = YKCurrTask->next;
    YKRdyList->prev = NULL;

    // put tcb in blocked list
    if (YKBlockList == NULL) {
        YKBlockList = YKCurrTask;
		YKBlockList->next = 0;
    }
    else {
        tcb_t *iter = YKBlockList;
        int moved_to_top = 1;
        while (YKCurrTask->priority > iter->priority) {
            iter = iter->next;
            moved_to_top = 0;
        }
        YKCurrTask->next = iter;
        if (iter->prev) 
            iter->prev->next = YKCurrTask;  

        YKCurrTask->prev = iter->prev;             
        iter->prev = YKCurrTask;

        if (moved_to_top)
            YKBlockList = YKCurrTask;
    }

    // call scheduler
    YKScheduler();
}

void YKEnterISR(void) {
    ++YKISRDepth;
}
void YKExitISR(void) {
    --YKISRDepth;
    if (YKISRDepth == 0) {
        YKScheduler();
    }
}





