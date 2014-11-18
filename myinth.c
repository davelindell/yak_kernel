#include "yakk.h"
#include "lab7defs.h"

extern int KeyBuffer;


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
	switch( c )
	{
		case 'a': YKEventSet( charEvent, EVENT_A_KEY ); break;
		case 'b': YKEventSet( charEvent, EVENT_B_KEY ); break;
		case 'c': YKEventSet( charEvent, EVENT_C_KEY ); break;
		case 'd': YKEventSet( charEvent, EVENT_A_KEY | EVENT_B_KEY | EVENT_C_KEY ); break;
		case '1': YKEventSet( numEvent, EVENT_1_KEY ); break;
		case '2': YKEventSet( numEvent, EVENT_2_KEY ); break;
		case '3': YKEventSet( numEvent, EVENT_3_KEY ); break;
		default:
			printNewLine();
		    printString("KEYPRESS (");
		    printChar( c );
		    printString(") IGNORED");
		    printNewLine();
			break;
	}
}
