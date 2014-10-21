# 1 "lab4c_app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "lab4c_app.c"






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
# 8 "lab4c_app.c" 2
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
extern unsigned YKIdleCount;
extern unsigned YKTickNum;
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
# 9 "lab4c_app.c" 2



int TaskStack[256];

void Task(void);

void main(void)
{
    YKInitialize();

    printString("Creating task...\n");
    YKNewTask(Task, (void *) &TaskStack[256], 0);

    printString("Starting kernel...\n");
    YKRun();
}

void Task(void)
{
    unsigned idleCount;
    unsigned numCtxSwitches;

    printString("Task started.\n");
    while (1)
    {
        printString("Delaying task...\n");

        YKDelayTask(2);

        YKEnterMutex();
        numCtxSwitches = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKIdleCount = 0;
        YKExitMutex();

        printString("Task running after ");
        printUInt(numCtxSwitches);
        printString(" context switches! YKIdleCount is ");
        printUInt(idleCount);
        printString(".\n");
    }
}
