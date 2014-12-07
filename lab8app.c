/* 
File: lab7app.c
Revision date: 10 November 2005
Description: Application code for EE 425 lab 7 (Event flags)
*/

#include "clib.h"
#include "yakk.h"                     /* contains kernel definitions */
#include "simptris.h"

#define TASK_STACK_SIZE   4096         /* stack size in words */
#define MSGQSIZE          200
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

long left_height;
long right_height;

int left_bin_state;
int right_bin_state;



/*

BIN STATES:

0 :  ***

1 : |*  |
    |** |
    |***|

2 : |  *|
    | **|
    |***|
*/

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

// placement functions
void move_long( void *id, int bin, int orientation, int column )
{
	int i;

	if ( bin )
	{
		// move to column 4
		if ( column < 4 )
			for ( i = column; i < 4; ++i )
                YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
		else if ( column == 5 )
			YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );
		right_height++;
	}
	else
	{
		// move to column 1
		if ( column > 1 )
			for ( i = column; i > 1; --i )
                YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );
		else if ( column == 0 )
			YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
		left_height++;
	}

	if ( orientation == 1 ) // up and down, rotate
		YKQPost( CMsgQPtr, (void*) (int)id );
}

void move_corner( void *id, int bin, int orientation, int column )
{
	int i;
	int bin_state;
	int left_column;
	int right_column;

	if ( bin )
	{
		left_column = 3;
		right_column = 5;
		bin_state = right_bin_state;
	}
	else
	{
		left_column = 0;
		right_column = 2;
		bin_state = left_bin_state;
	}

	switch ( bin_state )
	{
		case 0:
			switch( orientation )
			{
				case 3:
					// rotate ccw
                    YKQPost( CMsgQPtr, (void*) (int)id );
				case 0:
					// move to column left_column
					if ( column < left_column )
						for ( i = column; i < left_column; ++i )
		                    YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
					else
						for ( i = column; i > left_column; --i )
		                    YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );
					if ( bin ) right_bin_state = 1;
					else	   left_bin_state = 1;
					break;
				case 2:
					// rotate cw
                    YKQPost( CMsgQPtr, (void*) (CW_MASK | (int)id) ); 
				case 1:
					// move to column right_column
					if ( column < right_column )
						for ( i = column; i < right_column; ++i )
		                    YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
					else
						for ( i = column; i > right_column; --i )
		                    YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );
					if ( bin ) right_bin_state = 2;
					else	   left_bin_state = 2;
					break;
				default:
					break;
			}
			if ( bin ) right_height += 2;
			else	   left_height +=  2;
			
			break;
		case 1:
			switch( orientation )
			{
				case 0:
					// rotate ccw
					if ( column == 0 ) {
						YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
						column = 1;
					}
                    YKQPost( CMsgQPtr, (void*) (int)id );					
				case 1:
					// rotate ccw
                    YKQPost( CMsgQPtr, (void*) (int)id );
				case 2:
					break;
				case 3:
					// rotate cw
					if ( column == 0 ) {
						YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
						column = 1;
					}
                    YKQPost( CMsgQPtr, (void*) (CW_MASK | (int)id) );					
					break;
				default:
					break;
			}
			// move to right_column					
			if ( column < right_column )
				for ( i = column; i < right_column; ++i )
                    YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
			else
				for ( i = column; i > right_column; --i )
                    YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );

			if ( bin ) right_bin_state = 0;
			else	   left_bin_state = 0;
			break;
		case 2:
			switch( orientation )
			{
				case 0:
					// rotate cw
                    YKQPost( CMsgQPtr, (void*) (CW_MASK | (int)id) );
					break;
				case 1:
					// rotate ccw
                    YKQPost( CMsgQPtr, (void*) (int)id );
				case 2:
					// rotate ccw
					if ( column == 5 ) {
                    	YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );
						column = 4;
					}
                    YKQPost( CMsgQPtr, (void*) (int)id );
				case 3:
					break;
			}	
			// move to left_column	
			if ( column < left_column )
				for ( i = column; i < left_column; ++i )
		            YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | RIGHT_MASK | (int)id) );
			else
				for ( i = column; i > left_column; --i )
		            YKQPost( CMsgQPtr, (void*) (SLIDE_MASK | (int)id) );

			if ( bin ) right_bin_state = 0;
			else	   left_bin_state = 0;			
			break;
		default:
			break;
	}
}

void choose_spot_and_position(void* id, int type, int orientation, int column )
{
	printNewLine();
	printString("Piece ID: ");
	printInt( (int) id );
	printNewLine();
	printString("Type: ");
	printInt( type );
	printNewLine();
	printString("Orient: ");
	printInt( orientation );
	printNewLine();
	printString("Column: ");
	printInt( column );
	printNewLine();
	printString("Left Bin State: ");
	printInt( left_bin_state );
	printNewLine();
	printString("Right Bin State: ");
	printInt( right_bin_state );
	printNewLine();
	if ( type == 1 )
	{	// long
		if ( left_bin_state == 0 && right_bin_state == 0 )
			move_long( id, right_height < left_height, orientation, column );
		else
			move_long( id, right_bin_state == 0, orientation, column );
	}
	else
	{ // corner
		if ( left_bin_state == 0 && right_bin_state == 0 )
			move_corner( id, right_height < left_height, orientation, column );
		else
			move_corner( id, left_bin_state == 0, orientation, column );
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
        choose_spot_and_position(id, type, orientation, column);
    }
}

void CTask(void) {
    int tmp;
    int id;
    int moved_piece;
	int i;
    while(1) {
        YKSemPend(CSemPtr);
        tmp = (int) YKQPend(CMsgQPtr);
        id = ID_MASK & tmp;
		
        printNewLine();
		printString( "Piece ID: " );
        printInt(id);
        printNewLine();
        if (SLIDE_MASK & tmp) { // slide
            if (RIGHT_MASK & tmp) {
                SlidePiece(id, RIGHT); // slide right
				printString( "Slide Right" );
            }
            else {
                SlidePiece(id, LEFT); // slide left
				printString( "Slide Left" );
            }
        }
        else { // rotate
            if (CW_MASK & tmp) {
                RotatePiece(id, CW); // rotate cw
				printString( "Rotate Clockwise" );
            }
            else {
                RotatePiece(id, CCW); // rotate ccw
				printString( "Rotate Counter-clockwise" );
            }
        }
		//for (i = 0; i < 100; ++i){;}
		printNewLine();  
    }
}

void STask(void)                /* tracks statistics */
{
    unsigned max, switchCount, idleCount;
    int tmp;
    long seed;
    seed = 1247;

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

	left_height = 0;
	right_height = 0;

	left_bin_state = 0;
	right_bin_state = 0;

    YKRun();
}
