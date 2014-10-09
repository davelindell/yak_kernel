#include "clib.h"
#include "yakk.h"
extern int KeyBuffer;

void handleReset() {
    exit(0);   
}


void handleTick() {
    ++YKTickNum;
    printNewLine();
    printString("TICK ");
    printInt(YKTickNum);
    printNewLine();
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
    else {
        printNewLine();
        printString("KEYPRESS (");
        printChar(KeyBuffer);
        printString(") IGNORED");
        printNewLine();
    }
    return;

}
