# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "yakc.c"
# 1 "yakk.h" 1


# 1 "yaku.h" 1
# 4 "yakk.h" 2




typedef enum {READY, DELAYED} tcb_state_t;

typedef struct tcb_t {
    int ax;
    int bx;
    int cx;
    int dx;
    void *ip;
    void *sp;
    void *bp;
    int si;
    int di;
    int cs;
    int ss;
    int ds;
    int es;
    int flags;
    int priority;
    tcb_state_t state;
    int delay;
    struct tcb_t *prev;
    struct tcb_t *next;
} tcb_t;

extern int YKCtxSwCount;
extern int YKIdleCount;
extern int YKTickNum;
extern int YKISRDepth;
extern int YKRunFlag;

extern tcb_t *YKRdyList;
extern tcb_t *YKBlockList;
extern tcb_t *YKAvailTCBList;
extern tcb_t YKTCBArray[3 +1];
extern tcb_t *YKCurrTask;
extern int YKIdleTaskStack[256];


void YKInitialize(void);
void YKNewTask(void (*task)(void), void *task_stack, unsigned char priority);
void YKRun(void);
void YKDelayTask(unsigned count);
void YKEnterMutex(void);
void YKExitMutex(void);
void YKEnterISR(void);
void YKExitISR(void);
void YKScheduler(void);
void YKDispatcher(void);
void YKTickHandler(void);

void YKAddReadyTask(tcb_t* task);
void YKBlockTask(tcb_t *task);
void YKBlock2Ready(tcb_t *task);
# 2 "yakc.c" 2
int YKCtxSwCount;
int YKTickNum;
int YKIdleCount;
int YKISRDepth;
int YKRunFlag;

tcb_t *YKRdyList;
tcb_t *YKBlockList;
tcb_t *YKAvailTCBList;
tcb_t YKTCBArray[3 +1];
tcb_t *YKCurrTask;
int YKIdleTaskStack[256];


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
    cur_tcb->flags = 512;
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
    YKRdyList = 0;

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
    if (YKCurrTask != YKRdyList) {
        YKDispatcher();
    }
}


void YKAddReadyTask(tcb_t *cur_tcb) {
    if(YKRdyList == 0) {
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
