#include "yakk.h"

extern int KeyBuffer;
extern unsigned NewPieceID;
extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;
extern unsigned NewPieceColumn;
extern YKSEM *CSemPtr;
extern YKQ *PMsgQPtr;
extern int my_sanity;

void handleReset() {
    exit(0);
}


void handleTick() {
	tcb_t* current;
    ++YKTickNum;
    current = YKBlockList;

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
	exit(0);
}

void handleNewPiece(void) {
    YKQPost(PMsgQPtr, (void*) NewPieceID);
    YKQPost(PMsgQPtr, (void*) NewPieceType);
    YKQPost(PMsgQPtr, (void*) NewPieceOrientation);
    YKQPost(PMsgQPtr, (void*) NewPieceColumn);
}

void handleReceivedComm(void) {
	CSemPtr->value = -1;
	//printInt(CSemPtr->value);
	//printNewLine();   

	YKSemPost(CSemPtr);
	return;
}

void handleTouchdown(void) {
	return;
}

void handleLineClear(void) {
	return;
}















































