ISRReset:
    ; Save the context of whatever was running by pushing all registers onto the stack,
    ; except SP, SS, CS, IP, and the flags.
    push ax
    push bx
    push cx
    push dx
    push bp
    push si
    push di
    push ds
    push es
	call YKEnterISR
    ; enable interrupts
    sti
    ; call interrupt handler
    call handleReset
    ; disable interrupts
    cli
    ; Signal PIC that handler has finished
    call signalEOI
	call YKExitISR
    ; restore context
    pop es
    pop ds
    pop di
    pop si
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ; return from interrupt
    iret

ISRTick:
    ; Save the context of whatever was running by pushing all registers onto the stack,
    ; except SP, SS, CS, IP, and the flags.
    push ax
    push bx
    push cx
    push dx
    push bp
    push si
    push di
    push ds
    push es
	call YKEnterISR
    ; enable interrupts
    sti
    ; call interrupt handler
    call handleTick
    ; disable interrupts
    cli
    ; Signal PIC that handler has finished
    call signalEOI
	call YKExitISR
    ; restore context
    pop es
    pop ds
    pop di
    pop si
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ; return from interrupt
    iret

ISRKeyboard:
    ; Save the context of whatever was running by pushing all registers onto the stack,
    ; except SP, SS, CS, IP, and the flags.
    push ax
    push bx
    push cx
    push dx
    push bp
    push si
    push di
    push ds
    push es
	call YKEnterISR
    ; enable interrupts
    sti
    ; call interrupt handler
    call handleKeyboard
    ; disable interrupts
    cli
    ; Signal PIC that handler has finished
    call signalEOI
	call YKExitISR
    ; restore context
    pop es
    pop ds
    pop di
    pop si
    pop bp
    pop dx
    pop cx
    pop bx
    pop ax
    ; return from interrupt
    iret




