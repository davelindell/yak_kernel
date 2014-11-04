all: yakfinal
	
yakfinal: yakfinal.s
	nasm yakfinal.s -o yakfinal.bin -l yakfinal.lst

yakfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab5app.s
	cat clib.s myinth.s myisr.s yaks.s yakc.s lab5app.s > yakfinal.s

yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
	
lab5app.s: lab5app.c
	cpp lab5app.c lab5app.i
	c86 -g lab5app.i lab5app.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s

clean: 
	rm yakfinal.s yakc.s lab5app.s yakc.i lab5app.i yakfinal.bin yakfinal.lst myinth.s
