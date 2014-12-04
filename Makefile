all: yakfinal
	
yakfinal: yakfinal.s
	nasm yakfinal.s -o yakfinal.bin -l yakfinal.lst

yakfinal.s: clib.s simptris.s myisr.s myinth.s yaks.s yakc.s lab8app.s
	cat clib.s simptris.s  myinth.s myisr.s yaks.s yakc.s lab8app.s > yakfinal.s

yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
	
lab8app.s: lab8app.c
	cpp lab8app.c lab8app.i
	c86 -g lab8app.i lab8app.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s

clean: 
	rm yakfinal.s yakc.s lab8app.s yakc.i lab8app.i yakfinal.bin yakfinal.lst myinth.s
