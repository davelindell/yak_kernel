all: yakfinal
	
yakfinal: yakfinal.s
	nasm yakfinal.s -o yakfinal.bin -l yakfinal.lst

yakfinal.s: clib.s myisr.s myinth.s yaks.s yakc.s lab4d_app.s
	cat clib.s myinth.s myisr.s yaks.s yakc.s lab4d_app.s > yakfinal.s

yakc.s: yakc.c
	cpp yakc.c yakc.i
	c86 -g yakc.i yakc.s
	
lab4d_app.s: lab4d_app.c
	cpp lab4d_app.c lab4d_app.i
	c86 -g lab4d_app.i lab4d_app.s

myinth.s: myinth.c
	cpp myinth.c myinth.i
	c86 -g myinth.i myinth.s

clean: 
	rm yakfinal.s yakc.s lab4d_app.s yakc.i lab4d_app.i yakfinal.bin yakfinal.lst myinth.s
