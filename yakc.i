# 1 "yakc.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "yakc.c"
# 1 "yakk.h" 1


# 1 "yaku.h" 1
# 4 "yakk.h" 2
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 5 "yakk.h" 2




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
extern unsigned YKIdleCount;
extern unsigned YKTickNum;
extern int YKISRDepth;
extern int YKRunFlag;

extern tcb_t *YKRdyList;
extern tcb_t *YKBlockList;
extern tcb_t *YKAvailTCBList;
extern tcb_t YKTCBArray[4 +1];
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
unsigned YKTickNum;
unsigned YKIdleCount;
int YKISRDepth;
int YKRunFlag;


tcb_t *YKRdyList;
tcb_t *YKBlockList;
tcb_t *YKAvailTCBList;
tcb_t YKTCBArray[4 +1];
tcb_t *YKCurrTask;
int YKIdleTaskStack[256];

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
    YKRdyList = 0;
    YKCurrTask = 0;
    idle_task_p = YKIdleTask;
    idle_task_stack_p = YKIdleTaskStack + 256 - 1;
    lowest_priority = 100;

    YKAvailTCBList = YKTCBArray;
    YKNewTask(idle_task_p, idle_task_stack_p, lowest_priority);
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

    YKCurrTask->delay = count;
 YKCurrTask->state = DELAYED;


    YKRdyList = YKCurrTask->next;
    YKRdyList->prev = 0;


    if (YKBlockList == 0) {
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
