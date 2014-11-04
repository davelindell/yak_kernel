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
# 3 "myinth.c" 2

extern int KeyBuffer;
extern YKSEM *NSemPtr;

void handleReset() {
    exit(0);
}


void handleTick() {
 tcb_t* current;
    tcb_t* temp;
    ++YKTickNum;
    printNewLine();
    printString("TICK ");
    printInt(YKTickNum);

 current = YKBlockList;
# 31 "myinth.c"
 while ( current )
 {
  if ( current->state == DELAYED )
  {
   current->delay--;
   if ( !current->delay )
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
  }
  current = current->next;
 }


    return;
}


void handleKeyboard() {
    int i = 0;
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
    else if (KeyBuffer == 'p') {
        YKSemPost(NSemPtr);
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
