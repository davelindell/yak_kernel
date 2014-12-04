#include "yakk.h"

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















































