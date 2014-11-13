all: yakfinal
	
yakfinal: yakfinal.s
	nasm yakfinal.s -o yakfinal.bin -l yakfinal.lst

yakfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab6app.s
	cat clib.s myinth.s myisr.s yaks.s yakc.s lab6app.s > yakfinal.s

yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
	
lab6app.s: lab6app.c
	cpp lab6app.c lab6app.i
	c86 -g lab6app.i lab6app.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s

clean: 
	rm yakfinal.s yakc.s lab6app.s yakc.i lab6app.i yakfinal.bin yakfinal.lst myinth.s
