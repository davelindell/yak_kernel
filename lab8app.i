# 1 "lab8app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "lab8app.c"






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
# 8 "lab8app.c" 2
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
# 9 "lab8app.c" 2
# 1 "simptris.h" 1


void SlidePiece(int ID, int direction);
void RotatePiece(int ID, int direction);
void SeedSimptris(long seed);
void StartSimptris(void);
# 10 "lab8app.c" 2
# 29 "lab8app.c"
int PTaskStk[4096];
int CTaskStk[4096];
int STaskStk[4096];


void *PMsgQ[50];
void *CMsgQ[50];
YKQ *PMsgQPtr;
YKQ *CMsgQPtr;


YKSEM *CSemPtr;


void choose_spot_and_position(void* id, int type, int orientation, int column )
{
    static int long_state = 0;
    static int corner_state = 0;
    int i;

    if ( type == 1 )
    {
        if ( orientation == 0 )
            YKQPost(CMsgQPtr, (void*) (id));


        switch( long_state )
        {
            case 0:

                for (i = 0; i < column; ++i) {
                    YKQPost(CMsgQPtr, (void*) (0x8000 | (int)id));
                }
                long_state = 1;
                break;
            case 1:

                for (i = column; i < 5; ++i) {
                    YKQPost(CMsgQPtr, (void*) (0x8000 | 0x4000 | (int)id));
                }
                long_state = 2;
                break;
            case 2:

                if (column < 4) {
                    for (i = column; i < 4; ++i) {
                        YKQPost(CMsgQPtr, (void*) (0x8000 | 0x4000 | (int)id));
                    }
                }

                else if (column > 4) {
                    YKQPost(CMsgQPtr, (void*) (0x8000 | (int)id));
                }
                long_state = 0;
                break;
            default:
                break;
        }
    }
    else
    {

        if ( corner_state == 0 )
        {
            switch( orientation )
            {
                case 0:
                    break;
                case 1:

                    YKQPost(CMsgQPtr, (void*) (0x4000 | (int)id));
                    break;
                case 2:

                    YKQPost(CMsgQPtr, (void*) (id));
                case 3:

                    YKQPost(CMsgQPtr, (void*) (id));
                    break;
                default:
                    break;
            }

            if (column > 1) {
                for (i = column; i > 1; --i) {

                    YKQPost(CMsgQPtr, (void*) (0x8000 | (int)id));
                }
            }
            else if (column < 1) {

                YKQPost(CMsgQPtr, (void*) (0x8000 | 0x4000 | (int)id));
            }
            corner_state = 1;
        }
        else
        {
            switch( orientation )
            {
                case 0:

                    YKQPost(CMsgQPtr, (void*) (id));
                case 1:

                    YKQPost(CMsgQPtr, (void*) (id));
                case 2:
                    break;
                case 3:

                    YKQPost(CMsgQPtr, (void*) (0x4000 | (int)id));
                default:
                    break;
            }

            if (column > 3) {
                for (i = column; i > 3; --i) {

                    YKQPost(CMsgQPtr, (void*) (0x8000 | (int)id));
                }
            }
            else if (column < 3) {

                for (i = column; i < 3; ++i) {
                    YKQPost(CMsgQPtr, (void*) (0x8000 | 0x4000 | (int)id));
                }
            }
            corner_state = 0;
        }
    }
}

void PTask(void) {
    void *id;
    int type, orientation, column;
    while(1) {


        id = YKQPend(PMsgQPtr);
        type = (int)YKQPend(PMsgQPtr);
        orientation = (int)YKQPend(PMsgQPtr);
        column = (int)YKQPend(PMsgQPtr);
# 180 "lab8app.c"
        choose_spot_and_position(id, type, orientation, column);
    }
}

void CTask(void) {
    int tmp;
    int id;
    int moved_piece;
    while(1) {
        tmp = (int) YKQPend(CMsgQPtr);
        id = 0x3FFF & tmp;





        if (0x8000 & tmp) {
            if (0x4000 & tmp) {
                printInt(id);
                SlidePiece(id, 1);
            }
            else {
                SlidePiece(id, 0);
            }
        }
        else {
            if (0x4000 & tmp) {
                RotatePiece(id, 1);
            }
            else {
                RotatePiece(id, 0);
            }
        }

        YKSemPend(CSemPtr);
        printInt(CSemPtr->value);
        printNewLine();

    }
}

void STask(void)
{
    unsigned max, switchCount, idleCount;
    int tmp;
    long seed;
    seed = 1234;

    YKDelayTask(1);
    printString("Welcome to the YAK kernel\r\n");
    printString("Determining CPU capacity\r\n");
    YKDelayTask(1);
    YKIdleCount = 0;
    YKDelayTask(5);
    max = YKIdleCount / 25;
    YKIdleCount = 0;

    YKNewTask(PTask, (void *) &PTaskStk[4096], 20);
    YKNewTask(CTask, (void *) &CTaskStk[4096], 10);

    SeedSimptris(seed);
    StartSimptris();

    while (1)
    {
        YKDelayTask(20);

        YKEnterMutex();
        switchCount = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKExitMutex();

        printString("<<<<< Context switches: ");
        printInt((int)switchCount);
        printString(", CPU usage: ");
        tmp = (int) (idleCount/max);
        printInt(100-tmp);
        printString("% >>>>>\r\n");

        YKEnterMutex();
        YKCtxSwCount = 0;
        YKIdleCount = 0;
        YKExitMutex();
    }
}



void main(void)
{
    YKInitialize();
    YKNewTask(STask, (void *) &STaskStk[4096], 0);
    CSemPtr = YKSemCreate(0);
    CMsgQPtr = YKQCreate(CMsgQ, 50);
    PMsgQPtr = YKQCreate(PMsgQ, 50);
    YKRun();
}
