# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "myinth.c"
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
# 2 "myinth.c" 2
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




typedef enum {READY, DELAYED, SEMAPHORE, QUEUE} tcb_state_t;

typedef struct YKSEM {
    int value;
} YKSEM;

typedef struct YKQ {
    void **base_addr;
    int max_length;
    int head;
    int tail;
    int size;
} YKQ;

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
    YKQ* queue;
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
extern YKSEM YKSEMArray[4];
extern YKSEM* YKAvailSEMList;
extern YKQ YKQArray[1];
extern YKQ* YKQAvailQList;

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
YKQ *YKQCreate(void **start, unsigned size);
void *YKQPend(YKQ *queue);
int YKQPost(YKQ *queue, void *msg);

void YKAddReadyTask(tcb_t* task);
void YKBlockTask();
tcb_t *YKUnblockTask();
void YKBlock2Ready(tcb_t *task);
void YKBlockSEM2Ready(YKSEM* semaphore);
void YKBlockQ2Ready(YKQ* queue);
# 3 "myinth.c" 2
# 1 "lab6defs.h" 1
# 9 "lab6defs.h"
struct msg
{
    int tick;
    int data;
};
# 4 "myinth.c" 2

extern YKQ *MsgQPtr;
extern struct msg MsgArray[];
extern int GlobalFlag;

extern int KeyBuffer;
extern YKSEM *NSemPtr;

void handleReset() {
    exit(0);
}


void handleTick() {
 tcb_t* current;


    static int next = 0;
    static int data = 0;
    ++YKTickNum;


    MsgArray[next].tick = YKTickNum;
    data = (data + 89) % 100;
    MsgArray[next].data = data;
    if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
 printString("  TickISR: queue overflow! \n");
    else if (++next >= 20)
 next = 0;



    printString("TICK ");
    printInt(YKTickNum);
    printNewLine();
 current = YKBlockList;
# 50 "myinth.c"
 while ( current )
 {
  if ( current->state == DELAYED )
  {
   current->delay--;
   if ( !current->delay )
   {
    current = YKUnblockTask( current );
    continue;
   }
  }
  current = current->next;
 }


    return;
}


void handleKeyboard() {
    int i = 0;
    GlobalFlag = 1;

    if (KeyBuffer == 24178)
        exit(0);
    else if (KeyBuffer == 'd') {
        printNewLine();
        printString("DELAY KEY PRESSED");
        for (i = 0; i < 10000; ++i){}
        printNewLine();
        printString("DELAY COMPLETE");
        printNewLine();
    }
    else if (KeyBuffer == 24180) {
        handleTick();
    }
    else {
        printNewLine();
        printString("KEYPRESS (");
        printChar(KeyBuffer);
        printString(") IGNORED");
        printNewLine();
    }
    return;

}
