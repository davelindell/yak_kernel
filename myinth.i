# 1 "myinth.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "myinth.c"
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




typedef enum {READY, DELAYED, SEMAPHORE, QUEUE, EVENT} tcb_state_t;

typedef struct YKEVENT {
    int flags;
} YKEVENT;

typedef struct eventstate_t {
    YKEVENT *event;
    unsigned eventMask;
    int waitMode;
} eventstate_t;

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
    eventstate_t eventState;
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
extern YKSEM YKSEMArray[1];
extern YKSEM* YKAvailSEMList;
extern YKQ YKQArray[2];
extern YKQ* YKQAvailQList;
extern YKEVENT YKEventArray[1];
extern YKEVENT* YKAvailEventList;

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
YKEVENT *YKEventCreate(unsigned initialValue);
unsigned YKEventPend(YKEVENT *event, unsigned eventMask, int waitMode);
void YKEventSet(YKEVENT *event, unsigned eventMask);
void YKEventReset(YKEVENT *event, unsigned eventMask);

void YKAddReadyTask(tcb_t* task);
void YKBlockTask();
tcb_t *YKUnblockTask();
void YKBlock2Ready(tcb_t *task);
void YKBlockSEM2Ready(YKSEM* semaphore);
void YKBlockQ2Ready(YKQ* queue);
# 2 "myinth.c" 2

extern int KeyBuffer;
extern unsigned NewPieceID;
extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;
extern unsigned NewPieceColumn;
extern YKSEM *CSemPtr;
extern YKQ *PMsgQPtr;

void handleReset() {
    exit(0);
}


void handleTick() {
 tcb_t* current;
    ++YKTickNum;
    current = YKBlockList;
# 29 "myinth.c"
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


void handleKeyboard()
{
 char c;
 c = KeyBuffer;
 printNewLine();
    printString("KEYPRESS (");
    printChar( c );
    printString(") IGNORED");
    printNewLine();
}

void handleGameOver(void) {

}

void handleNewPiece(void) {
    YKQPost(PMsgQPtr, (void*) NewPieceID);
    YKQPost(PMsgQPtr, (void*) NewPieceType);
    YKQPost(PMsgQPtr, (void*) NewPieceOrientation);
    YKQPost(PMsgQPtr, (void*) NewPieceColumn);
}

void handleReceivedComm(void) {
    YKSemPost(CSemPtr);
}

void handleTouchdown(void) {

}

void handleLineClear(void) {

}
