/* 
File: lab7app.c
Revision date: 10 November 2005
Description: Application code for EE 425 lab 7 (Event flags)
*/

#include "clib.h"
#include "yakk.h"                     /* contains kernel definitions */
#include "simptris.h"

#define TASK_STACK_SIZE   4096         /* stack size in words */
#define MSGQSIZE          50
#define CW_MASK 0x4000 //0B0100000000000000 
#define CCW_MASK 0
#define RIGHT_MASK 0x4000 //0B0100000000000000
#define LEFT_MASK 0
#define SLIDE_MASK 0x8000 //0B1000000000000000
#define ROTATE_MASK 0
#define CW 1
#define CCW 0
#define RIGHT 1
#define LEFT 0
#define ID_MASK 0x3FFF //0B0011111111111111

// Placement state machine globals


// Stack memory allocation
int PTaskStk[TASK_STACK_SIZE]; // Place task
int CTaskStk[TASK_STACK_SIZE]; // Communicate task
int STaskStk[TASK_STACK_SIZE]; // Stats task

// Msg Queue Mem allocation/declaration
void *PMsgQ[MSGQSIZE];           /* space for message queue */
void *CMsgQ[MSGQSIZE];           /* space for message queue */
YKQ *PMsgQPtr;                   /* actual name of queue */
YKQ *CMsgQPtr;                   /* actual name of queue */

// Communication Semaphore
YKSEM *CSemPtr; 

// placement function
void choose_spot_and_position(void* id, int type, int orientation, int column )
{
    static int long_state = 0;
    static int corner_state = 0;
    int i;
    
    if ( type == 1 )
    {    // long
        if ( orientation == 0 ) // up and down
            YKQPost(CMsgQPtr, (void*) (id)); // rotate
            
        
        switch( long_state )
        {
            case 0:
                // slide left to column 0
                for (i = 0; i < column; ++i) {
                    YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | (int)id)); 
                }
                long_state = 1;
                break;
            case 1:
                // slide right to column 5
                for (i = column; i < 5; ++i) {
                    YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id)); 
                }
                long_state = 2;
                break;
            case 2:
                // slide right to column 4
                if (column < 4) {
                    for (i = column; i < 4; ++i) {
                        YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id)); 
                    }
                }
                // slide left to column 4
                else if (column > 4) {
                    YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | (int)id)); 
                }
                long_state = 0;
                break;
            default:
                break;
        }
    }
    else
    { // corner
        
        if ( corner_state == 0 ) // bottom left corner to be placed.
        {
            switch( orientation )
            {
                case 0: // bottom left position;            
                    break;
                case 1: // bottom right
                    // rotate clockwise once
                    YKQPost(CMsgQPtr, (void*) (CW_MASK | (int)id)); 
                    break;
                case 2:    // top right
                    // rotate cclockwise once
                    YKQPost(CMsgQPtr, (void*) (id)); 
                case 3: // top left position
                    // rotate counter-clockwise once
                    YKQPost(CMsgQPtr, (void*) (id)); 
                    break;
                default:
                    break;
            }
            // move to column 1
            if (column > 1) { 
                for (i = column; i > 1; --i) {
                    // slide left
                    YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | (int)id)); 
                } 
            }
            else if (column < 1) {
                // slide right
                YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id)); 
            }
            corner_state = 1;
        }
        else // bottom right corner to be placed.
        {
            switch( orientation )
            {
                case 0: // bottom left position
                    // rotate cclockwise once
                    YKQPost(CMsgQPtr, (void*) (id));
                case 1: // bottom right position 
                    // rotate cclockwise once
                    YKQPost(CMsgQPtr, (void*) (id));
                case 2: // top right position 
                    break;
                case 3: // top left position 
                    // rotate clockwise once
                    YKQPost(CMsgQPtr, (void*) (CW_MASK | (int)id)); 
                default:
                    break;
            }
            // move to column 3;
            if (column > 3) { 
                for (i = column; i > 3; --i) {
                    // slide left
                    YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | (int)id)); 
                } 
            }
            else if (column < 3) {
                // slide right
                for (i = column; i < 3; ++i) {
                    YKQPost(CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id)); 
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
        //get id, type, orientation, column

        id = YKQPend(PMsgQPtr); 
        type = (int)YKQPend(PMsgQPtr);
        orientation = (int)YKQPend(PMsgQPtr);
        column = (int)YKQPend(PMsgQPtr);
        /*
        printNewLine();
        printInt(id);        
        printNewLine();
        printInt(type);
        printNewLine();
        printInt(orientation);
        printNewLine();
        printInt(column);
        printNewLine();*/
        choose_spot_and_position(id, type, orientation, column);
    }
}

void CTask(void) {
    int tmp;
    int id;
    int moved_piece;
    while(1) {
        tmp = (int) YKQPend(CMsgQPtr); 
        id = ID_MASK & tmp;

        /*printNewLine();
        printInt(id);
        printNewLine();
        printInt(tmp);*/
        if (SLIDE_MASK & tmp) { // slide
            if (RIGHT_MASK & tmp) {
                SlidePiece(id, RIGHT); // slide right
            }
            else {
                SlidePiece(id, LEFT); // slide left
            }
        }
        else { // rotate
            if (CW_MASK & tmp) {
                RotatePiece(id, CW); // rotate cw
            }
            else {
                RotatePiece(id, CCW); // rotate ccw
            }
        }

        YKSemPend(CSemPtr);
        printInt(CSemPtr->value);
        printNewLine();
         
    }
}

void STask(void)                /* tracks statistics */
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

    YKNewTask(PTask, (void *) &PTaskStk[TASK_STACK_SIZE], 20);
    YKNewTask(CTask, (void *) &CTaskStk[TASK_STACK_SIZE], 10);

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
    YKNewTask(STask, (void *) &STaskStk[TASK_STACK_SIZE], 0);
    CSemPtr = YKSemCreate(0);
    CMsgQPtr = YKQCreate(CMsgQ, MSGQSIZE);
    PMsgQPtr = YKQCreate(PMsgQ, MSGQSIZE);
    YKRun();
}
