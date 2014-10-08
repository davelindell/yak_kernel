#ifndef YAKK_H
#define YAKK_H
#include "yaku.h"
#define STACK_SIZE 256
#endif

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
    int flags;
    int priority;
    tcb_state_t state; //ready, blocked (reason blocked)
    int delay;
    struct tcb_t *next;
} tcb_t;

extern int YKCtxSwCount;
extern int YKIdleCount;
extern int YKTickNum;
extern int YKISRDepth;
extern int YKRunFlag;

extern tcb_t *YKRdyList;        /* a list of TCBs of all ready tasks in order of decreasing priority */
extern tcb_t *YKBlockList;      /* tasks delayed or suspended */
extern tcb_t *YKAvailTCBList;       /* a list of available TCBs */
extern tcb_t YKTCBArray[MAXTASKS+1];    /* array to allocate all needed TCBs (extra one is for the idle task) */
extern int YKIdleTaskStack[IDLE_STACK_SIZE]; /* idle task stack */

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


