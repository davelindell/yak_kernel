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




typedef enum {READY, DELAYED, SEMAPHORE} tcb_state_t;

typedef struct YKSEM {
    int value;
} YKSEM;


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
    YKSEM* semaphore;
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
extern tcb_t YKTCBArray[5 +1];
extern tcb_t *YKCurrTask;
extern int YKIdleTaskStack[256];

int print_delay_list(void);
int print_ready_list(void);

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
YKSEM* YKSemCreate(int initialValue);
void YKSemPend(YKSEM *semaphore);
void YKSemPost(YKSEM *semaphore);

void YKAddReadyTask(tcb_t* task);
void YKBlockTask();
void YKBlock2Ready(tcb_t *task);
void YKBlockSEM2Ready(YKSEM* semaphore);
# 2 "yakc.c" 2
int YKCtxSwCount;
unsigned YKTickNum;
unsigned YKIdleCount;
int YKISRDepth;
int YKRunFlag;

int YKErrorFlag;


tcb_t *YKRdyList;
tcb_t *YKBlockList;
tcb_t *YKAvailTCBList;
tcb_t YKTCBArray[5 +1];
tcb_t *YKCurrTask;
int YKIdleTaskStack[256];
YKSEM YKSEMArray[4];
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
    YKErrorFlag = 0;


    YKAvailSEMList = YKSEMArray;


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
    if (YKCurrTask != YKRdyList) {
# 152 "yakc.c"
        YKDispatcher();
    }
}


void YKAddReadyTask(tcb_t *cur_tcb) {
    int moved_to_top;
    tcb_t* iter;
    if(YKRdyList == 0) {
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

    YKRdyList = YKCurrTask->next;
    YKRdyList->prev = 0;


    if (YKBlockList == 0) {
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
   else YKBlockList = current->next;

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
   else YKBlockList = current->next;

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

    YKCurrTask->delay = count;
 YKCurrTask->state = DELAYED;


    YKEnterMutex();
    YKBlockTask();
    YKExitMutex();


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


    available = semaphore->value > 0 ? 1 : 0;
    --(semaphore->value);


    if (!available) {
        YKCurrTask->state = SEMAPHORE;
        YKCurrTask->semaphore = semaphore;
        YKBlockTask(YKCurrTask);
    }

    YKExitMutex();



        YKScheduler();
}

void YKSemPost(YKSEM *semaphore) {
    YKEnterMutex();
    ++(semaphore->value);
    if (semaphore->value > 1)
        semaphore->value = 1;

    if (semaphore->value < 1) {
        YKBlockSEM2Ready(semaphore);

    }

    if (YKISRDepth == 0)
        YKScheduler();
    YKExitMutex();
}
