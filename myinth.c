#include "yakk.h"

extern int KeyBuffer;
extern unsigned NewPieceID;
extern unsigned NewPieceType;
extern unsigned NewPieceOrientation;
extern unsigned NewPieceColumn;
extern YKSEM *CSemPtr;
extern YKSEM *NPSemPtr;
extern YKQ *PMsgQPtr;
extern int busy;

int gotnewpiece;

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
    return;
}

void handleGameOver(void) {
	exit(0);
}

void handleNewPiece(void) {
    YKQPost(PMsgQPtr, (void*) NewPieceID);
    YKQPost(PMsgQPtr, (void*) NewPieceType);
    YKQPost(PMsgQPtr, (void*) NewPieceOrientation);
    YKQPost(PMsgQPtr, (void*) NewPieceColumn);
    YKSemPost(NPSemPtr);
    return;
}

void handleReceivedComm(void) {
	//CSemPtr->value = -1;
	//printInt(CSemPtr->value);
	//printNewLine();
    //if ( (busy && (CSemPtr->value > -1)) || !busy )
    //    YKSemPost(BusySemPtr);
    //else   
	    YKSemPost(CSemPtr);
	return;
}

void handleTouchdown(void) {
    return;
}

void handleLineClear(void) {
	return;
}















































