all: yakfinal
	
yakfinal: yakfinal.s
	nasm yakfinal.s -o yakfinal.bin -l yakfinal.lst

yakfinal.s: clib.s yaks.s yakc.s
	cat clib.s yaks.s yakc.s > yakfinal.s

yakc.s: yakc.i
	c86 yakc.i yakc.s

yakc.i: yakc.c
	cpp yakc.c yakc.i
	
