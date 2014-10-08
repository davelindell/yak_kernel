#include "yakk.h"
int YKCtxSwCount;
int YKTickNum;
int YKIdleCount;
int YKISRDepth;
int YKRunFlag;

tcb_t *YKRdyList;        /* a list of TCBs of all ready tasks in order of decreasing priority */
tcb_t *YKBlockList;      /* tasks delayed or suspended */
tcb_t *YKAvailTCBList;       /* a list of available TCBs */
tcb_t YKTCBArray[MAXTASKS+1];    /* array to allocate all needed TCBs (extra one is for the idle task) */
tcb_t *YKCurrTask;
int YKIdleTaskStack[IDLE_STACK_SIZE]; /* idle task stack */


void YKIdleTask(void) {
    while(1){}
}


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
    YKAddReadyTask(cur_tcb);

    if (YKRunFlag) {
        YKScheduler();
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
    YKRdyList = NULL;    

    idle_task_p = YKIdleTask;
    idle_task_stack_p = YKIdleTaskStack;
    lowest_priority = 100;

    YKAvailTCBList = YKTCBArray;
    YKNewTask(idle_task_p, idle_task_stack_p, lowest_priority);
}

void YKRun(void) {
    YKRunFlag = 1;
    YKCurrTask = YKRdyList;
    YKScheduler();
}

void YKScheduler(void) {
    if (YKCurrTask != YKRdyList) { // going to change contexts
        YKDispatcher();
    }
}


void YKAddReadyTask(tcb_t *cur_tcb) {    
    if(YKRdyList == NULL) {
        YKRdyList = cur_tcb;
    }
    else {
        tcb_t *iter = YKRdyList;
        while (cur_tcb->priority > iter->priority) {
            iter = iter->next;
        }
        cur_tcb->next = iter;
        cur_tcb->prev = iter->prev;
        iter->prev->next = cur_tcb;        
        iter->prev = cur_tcb;
    }
    return;
}




int main() {
    YKIdleTask();
    return 1;
}

