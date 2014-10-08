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
    int ip;
    int sp;
    int bp;
    int si;
    int di;
    int cs;
    int ss;
    int ds;
    int es;
    int priority;
    tcb_state_t state;
    int delay;
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
int YKIdleTaskStack[256];


void YKIdleTask(void) {
    while(1){}
}

void YKNewTask(void (* task)(void), void *taskStack, unsigned char priority) {


}


void YKInitialize(void) {
    YKCtxSwCount = 0;
    YKTickNum = 0;
    YKIdleCount = 0;
    YKISRDepth = 0;
    YKRunFlag = 0;

    tcb_t *idle_task = &YKTCBArray[0];
    idle_task->ax = 0;
    idle_task->bx = 0;
    idle_task->cx = 0;
    idle_task->dx = 0;
    idle_task->ip = &YKIdleTask;
    idle_task->sp = &YKIdleTaskStack[0];
    idle_task->bp = &YKIdleTaskStack[0];
    idle_task->si = 0;
    idle_task->di = 0;
    idle_task->cs = 0;
    idle_task->ss = 0;
    idle_task->ds = 0;
    idle_task->es = 0;
    idle_task->priority = 100;
    idle_task->state = READY;
    idle_task->delay = 0;

}



int main() {
    YKIdleTask();
    return 1;
}
