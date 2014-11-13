#include "clib.h"
#include "yakk.h"
#include "lab6defs.h"

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

    // start lab 6 code
    static int next = 0;
    static int data = 0;
    ++YKTickNum;

    /* create a message with tick (sequence #) and pseudo-random data */
    MsgArray[next].tick = YKTickNum;
    data = (data + 89) % 100;
    MsgArray[next].data = data;
    if (YKQPost(MsgQPtr, (void *) &(MsgArray[next])) == 0)
	printString("  TickISR: queue overflow! \n");
    else if (++next >= MSGARRAYSIZE)
	next = 0;
    // end lab 6 code


    printString("TICK ");
    printInt(YKTickNum);
    printNewLine();
	current = YKBlockList;

    /*printNewLine();
    printString("Block List:");
    printNewLine();
    print_delay_list();
    printString("Ready List:");
    printNewLine();
    print_ready_list();*/


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

    //YKSemPost(NSemPtr);
    return;
}


void handleKeyboard() {
    int i = 0;
    GlobalFlag = 1;    // for lab 6

    if (KeyBuffer == 24178)
        exit(0);
    else if (KeyBuffer == 'd') { //^r
        printNewLine();
        printString("DELAY KEY PRESSED");
        for (i = 0; i < 10000; ++i){}
        printNewLine();
        printString("DELAY COMPLETE");
        printNewLine();
    }
    else if (KeyBuffer == 24180) { //^t
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
