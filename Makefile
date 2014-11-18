all: yakfinal
	
yakfinal: yakfinal.s
	nasm yakfinal.s -o yakfinal.bin -l yakfinal.lst

yakfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab7app.s
	cat clib.s myinth.s myisr.s yaks.s yakc.s lab7app.s > yakfinal.s

yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
	
lab7app.s: lab7app.c
	cpp lab7app.c lab7app.i
	c86 -g lab7app.i lab7app.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s

clean: 
	rm yakfinal.s yakc.s lab7app.s yakc.i lab7app.i yakfinal.bin yakfinal.lst myinth.s
