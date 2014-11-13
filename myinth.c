#include "clib.h"
#include "yakk.h"

extern int KeyBuffer;
extern YKSEM *NSemPtr;

void handleReset() {
    exit(0);   
}


void handleTick() {
	tcb_t* current;
    ++YKTickNum;
    printNewLine();
    printString("TICK ");
    printInt(YKTickNum);

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
    else if (KeyBuffer == 'p') { //^t
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
