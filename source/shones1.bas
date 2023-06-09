10 ' *********************************
20 '
30 '   INDIANA SHONES PART 1
40 ' 
50 '   PROGRAMMED BY ABURI6800 2023
60 ' 
70 ' *********************************

100 SCREEN 1,2,0:WIDTH 32:COLOR 15,1,1:KEY OFF:DEFINT A-Z:CLEAR 200,&HC000:DEFUSR=&H7E:A=USR(0)
110 GOSUB 9000:GOTO 300

150 ' ***** PLAYER SPRITE PUT *****
160 PUT SPRITE 0,(X(0)\16+4,Y(0)\16-1),4,(P(0)+R(0)*2)
170 PUT SPRITE 1,(X(0)\16+4,Y(0)\16-1),11,(P(0)+R(0)*2)+1:RETURN

200 ' ***** PLAYER SPRITE UPDATE *****
210 X=X(0)\16+4:Y=Y(0)\16-1:P=(P(0)*4)+(R(0)*8):AD=BASE(8)
220 VPOKE AD,Y:VPOKE AD+1,X:VPOKE AD+2,P
230 VPOKE AD+4,Y:VPOKE AD+5,X:VPOKE AD+6,P+4:RETURN

250 ' ***** OTHER SPRITE PUT *****
260 PUT SPRITE N+1,(X(N)\16+4,Y(N)\16),C(N),P(N):RETURN

270 ' ***** OTHER SPRITE UPDATE *****
280 X=X(N)\16+4:Y=Y(N)\16:P=(P(N)+R(N))*4:AD=BASE(8)+((N+1)*4)
290 VPOKE AD,Y:VPOKE AD+1,X:VPOKE AD+2,P:RETURN

300 ' ***** MAIN ROUTINE *****
310 ON GS GOSUB 5000,3000,400,3500,4000,1700,1800
320 GOTO 300

400 ' ***** GAME MAIN *****
410 ON BF+1 GOSUB 500,600
420 A=&H1800+(X(0)\128+1)+(Y(0)\128)*32:IF VPEEK(A)<>32 OR VPEEK(A-32)<>32 THEN GS=6:RETURN
430 X=X(0)\16:Y=Y(0)\16:FOR I=4 TO 7:IF F(I) AND ABS((X(I)\16)-X)<16 AND ABS((Y(I)\16)-Y)<16 THEN GS=6
440 NEXT I
450 IF SF THEN GOSUB 800
460 GOSUB 1000
470 GOSUB 1600
480 A=USR2(0):WT=10:GOSUB 8300:RETURN

500 ' ***** PLAYER CONTROL *****
510 IF JF THEN Y(0)=Y(0)+JY(JF):JF=JF-1:S=JS:GOTO 550
515 IF TL=0 THEN GS=4:RETURN
520 IF STRIG(0)+STRIG(1) AND BF=0 AND JF=0 THEN BF=1:RETURN
530 S=STICK(0)+STICK(1):IF S=8 OR S=1 OR S=2 THEN JF=7:JS=S:RETURN
540 IF S=0 THEN R(0)=1:GOTO 590
550 X(0)=X(0)+VX(S):IF X(0)<512 OR X(0)>3320 THEN X(0)=X(0)-VX(S)
560 IF (S=6 OR S=7 OR S=8) AND P(0)<>4 THEN P(0)=4:R(0)=0:GOTO 590
570 IF (S=2 OR S=3 OR S=4) AND P(0)<>0 THEN P(0)=0:R(0)=0:GOTO 590
580 R(0)=R(0) XOR 1
590 GOSUB 200:RETURN

600 ' ***** SITE CONTROL *****
610 IF STRIG(0)+STRIG(1)=0 AND SF=0 GOTO 700
620 S=STICK(0)+STICK(1)
625 X(1)=X(1)+VX(S):Y(1)=Y(1)+VY(S)
630 IF X(1)<512 OR X(1)>3320 THEN X(1)=X(1)-VX(S)
640 IF Y(1)<15 OR Y(1)>1664 THEN Y(1)=Y(1)-VY(S)
650 IF S>0 THEN N=1:GOSUB 270
660 RETURN

700 ' ***** KNIFE INIT *****
710 BF=0:SF=1:MC=0:N=2:X=X(0):Y=Y(0):TX=X(1):TY=Y(1):SP=2:GOSUB 2000
720 P(N)=11:F(N)=1:R(N)=0:C(N)=15:GOSUB 250:RETURN

800 ' ***** KNIFE MOVE *****
810 MC=MC+1:N=2:GOSUB 2100:IF TF=0 THEN RETURN
820 SF=0:X=X(1)\16:Y=Y(1)\16-4:FOR I=3 TO 5:IF ABS(X(I)\16-X)<20 AND ABS(Y(I)\16-Y)<20 THEN GOSUB 850
830 NEXT I:IF SC=0 THEN GS=6 ELSE SC=SC-10:GOSUB 2400
840 Y(N)=3200:GOSUB 270:RETURN
850 SC=SC+(MC*10):GOSUB 2400:TL=TL+(TL>0):PLAY "T255L32O5V12CGEB":F(I)=0:Y(I)=3200:SWAP N,I:GOSUB 270:SWAP N,I
860 RETURN

1000 ' ***** ENEMY MOVE *****
1010 FOR I=0 TO 1
1020 N=C+3:ON C GOSUB 1100,1100,1100,1500
1030 C=C MOD 4+1
1040 NEXT I:RETURN

1100 ' ----- BAT -----
1110 ON F(N) GOTO 1150,1300

1120 IF INT(RND(1)*3)<>0 THEN RETURN
1130 X=(INT(RND(1)*22)+4)*128:Y=1:TX=(INT(RND(1)*22)+4)*128:TY=((INT(RND(1)*(3+RD*2))+2)*128):SP=1:GOSUB 2000
1140 F(N)=1:P(N)=12:R(N)=0:C(N)=5:GOSUB 250:RETURN

1150 R(N)=R(N) XOR 1:GOSUB 2100:IF TF THEN 1200
1160 IF RD>1 AND INT(RND(1)*100)<(RD-1)*3 THEN LOCATE X(N)\128+1,Y(N)\128+1:PRINT "n";
1170 RETURN

1200 X=X(N):Y=Y(N):IF INT(RND(1)*50)<RD*2 THEN 1220
1210 TX=(INT(RND(1)*22)+4)*128:TY=(INT(RND(1)*(3+RD*2)))*128:SP=1:GOSUB 2000:RETURN
1220 TX=X(0):TY=Y(0)+128:SP=2:GOSUB 2000:F(N)=2:RETURN

1300 GOSUB 2100:IF TF=0 THEN IF RD=5 THEN 1160 ELSE RETURN
1310 X=X(N):Y=Y(N):TX=X(N):TY=(INT(RND(1)*3)+2)*8*16:SP=1:GOSUB 2000:F(N)=1:RETURN

1500 ' ----- SKELETON -----
1510 IF F(N) GOTO 1550

1520 IF RD<3 OR INT(RND(1)*5)<>0 THEN RETURN
1530 F(N)=1:C(N)=14:R(N)=0:SP=1:Y=2304:TY=2304:IF X(0)>2048 THEN X=128:TX=3584:P(N)=14 ELSE X=3584:TX=128:P(N)=16
1540 GOSUB 2000:GOSUB 250:RETURN

1550 R(N)=R(N) XOR 1:GOSUB 2100:IF TF THEN F(N)=0:Y(N)=3200:GOSUB 250
1560 RETURN

1600 ' ***** ROCK *****
1610 IF RD<4 OR INT(RND(1)*100)>(RD\2)*5 THEN RETURN
1620 X=RND(1)*22+5:LOCATE X,1:PRINT "ij";:LOCATE X,2:PRINT "kl";:RETURN

1700 ' ***** MISS *****
1710 IF TL=0 THEN GS=3:RETURN
1720 GOSUB 8600:JF=7:P(0)=8:R(0)=0:GOSUB 150
1730 Y(0)=Y(0)+JY(JF):GOSUB 200:JF=JF+(JF>1):WT=4:GOSUB 8300:IF Y(0)<3072 THEN 1730
1740 IF LF=0 THEN GS=7:RETURN
1750 LF=LF-1:IF SC=0 THEN SC=100
1760 GS=3:GOSUB 2400:GOSUB 2200:GOSUB 2300:GOSUB 5300:RETURN

1800 ' ***** GAME OVER *****
1810 GOSUB 2200:GOSUB 2300
1820 LOCATE 11,9:PRINT "GAME OVER";:GOSUB 8700
1830 GS=1:RETURN

2000 ' ***** CHARACTER MOVE INIT SUB *****
2010 X(N)=X:Y(N)=Y:TX(N)=TX:TY(N)=TY:DX=TX-X(N):DY=TY-Y(N)
2020 IF DX+DY=0 THEN WX(N)=1:WY(N)=1
2030 IF ABS(DX)>ABS(DY) THEN A=ABS(DX) ELSE A=ABS(DY)
2040 WX(N)=INT((DX/A)*(8*SP)*16):WY(N)=INT((DY/A)*(8*SP)*16)
2050 RETURN

2100 ' ***** CHARACTER MOVE SUB *****
2110 X(N)=X(N)+WX(N):Y(N)=Y(N)+WY(N):IF Y(N)<0 THEN Y(N)=0
2120 GOSUB 270:TF=0:IF ABS(X(N)-TX(N))<256 AND ABS(Y(N)-TY(N))<256 THEN TF=1
2130 RETURN

2200 ' ***** ALL SPRITE ERASE SUB *****
2210 FOR I=0 TO 31:PUT SPRITE I,(0,192),0,0:NEXT I:RETURN

2300 ' ***** MAIN SCREEN ERASE SUB *****
2310 FOR I=1 TO 19:LOCATE 4,I:PRINT SPACE$(24);:NEXT I:RETURN

2400 ' ***** PRINT INFO *****
2410 LOCATE 7,22:PRINT USING "#####";SC;
2420 LOCATE 19,22:PRINT RD;
2430 LOCATE 29,22:PRINT LF;
2440 IF GS=3 THEN LOCATE 14,0:PRINT USING "##";TL
2450 RETURN

3000 ' ***** ROUND START *****
3010 CLS:GOSUB 8000:X(0)=1*8*16:Y(0)=2304:F(0)=1:P(0)=0:R(0)=1:GOSUB 150
3020 P(0)=0:X1=1:X2=15:GOSUB 5400
3030 N=1:X(1)=X(0):Y(1)=Y(0)-384:C(1)=15:P(1)=18:GOSUB 250:P(0)=4:GOSUB 200:GOSUB 6020
3040 Y(1)=3200:GOSUB 270:P(0)=0:GOSUB 200
3050 GOSUB 5300:LOCATE 9,8:PRINT USING "ROUND # START";RD
3060 N=3:X(N)=12*8*16:Y(N)=(11*8+4)*16:C(N)=5:P(N)=12:GOSUB 250
3070 LOCATE 15,12:PRINT "= ";TL
3080 GOSUB 8750:Y(N)=3200:GOSUB 270:GOSUB 2300
3090 GS=3:GOSUB 2400:RETURN

3500 ' ***** ROUND CLEAR *****
3510 FOR N=1 TO 7:Y(N)=3200:X(N)=128:GOSUB 270:NEXT N:GOSUB 2300
3520 GOSUB 6030:X1=X(0)/128:X2=29:P(0)=0:GOSUB 5400
3530 LOCATE 9,8:PRINT USING "ROUND # CLEAR";RD
3540 LOCATE 10,10:PRINT USING "BONUS #####";RD*100
3550 GOSUB 8800:SC=SC+RD*100:IF RD=5 THEN GS=5 ELSE RD=RD+1:GS=2
3560 RETURN

4000 ' ***** ALL ROUND CLEAR *****
4010 CLS:GOSUB 8000
4020 LOCATE 13,17:PRINT "  ";CHR$(130);CHR$(131);CHR$(132);
4030 LOCATE 13,18:PRINT " ";CHR$(131);CHR$(132);CHR$(131);CHR$(129);CHR$(131);
4040 LOCATE 13,19:PRINT CHR$(131);CHR$(129);CHR$(131);CHR$(131);CHR$(131);CHR$(132);CHR$(129);
4050 X(0)=256:Y(0)=2304:F(0)=1:P(0)=0:R(0)=1:GOSUB 150:X1=1:X2=12:GOSUB 5400
4060 LOCATE 8,5:PRINT "CONGRATULATIONS!!";
4070 LOCATE 4,8:PRINT "YOU'VE GOT THE TREASURE!"
4080 LOCATE 11,12:PRINT USING "BONUS ####";(LF+1)*1000
4090 SC=SC+(LF+1)*1000:GOSUB 2400
4100 GOSUB 8900:GS=1:RETURN

5000 ' ***** TITLE *****
5010 CLS:GOSUB 8000
5020 FOR I=0 TO 6:VPOKE &H184B+I,161+I:VPOKE &H186B+I,193+I:NEXT I
5030 FOR I=0 TO 6:VPOKE &H188F+I,168+I:VPOKE &H18AF+I,200+I:NEXT I
5040 FOR I=0 TO 15:VPOKE &H18E8+I,175+I:NEXT I
5050 LOCATE 8,16:PRINT "[ABURI GAMES 2023";
5060 LOCATE 7,18:PRINT "ALL RIGHTS RESERVED";
5070 X(0)=256:Y(0)=2304:F(0)=1:P(0)=0:R(0)=1:GOSUB 150
5080 GOSUB 8500:LOCATE 11,12:PRINT "PUSH BUTTON";
5090 X(1)=5:X(2)=8:X(3)=21:X(4)=26:X(5)=27
5100 Y(1)=3:Y(2)=1:Y(3)=2:Y(4)=1:Y(5)=3
5110 FOR I=1 TO 5:F(I)=RND(1)*2:NEXT I   :N=1
5120 WT=10:GOSUB 8300:IF INT(RND(1)*8)=0 THEN F(N)=F(N) XOR 1:LOCATE X(N),Y(N):PRINT MID$(" m",F(N)+1,1);
5130 N=N MOD 5+1:IF STRIG(0)+STRIG(1)=0 THEN 5120
5140 FOR I=12 TO 18:LOCATE 7,I:PRINT "                   ";:NEXT I
5150 X1=3:X2=26:GOSUB 5400:GOSUB 6030:X1=26:X2=30:GOSUB 5400:Y(0)=3200:GOSUB 150

5160 ' ----- GAME GLOBAL INIT -----
5170 GOSUB 2200:RD=1:LF=2:SC=100:TL=0:GS=2:RETURN

5300 ' ----- GAME INIT -----
5310 C=1:SF=0:BF=0:JF=0:JS=0:TF=0:IF TL=0 THEN TL=((RD*3)+2)
5320 FOR I=0 TO 8:F(I)=0:Y(I)=192*16:GOSUB 270:NEXT I
5330 X(0)=15*128:Y(0)=18*128:P(0)=0:F(0)=1:GOSUB 150
5340 X(1)=15*128:Y(1)=10*128:P(1)=10:F(1)=1:C(1)=14:N=1:GOSUB 250
5350 RETURN

5400 ' ----- SHONES MOVE(DEMO) ----
5410 FOR I=X1 TO X2:X(0)=I*128:R(0)=R(0) XOR 1:GOSUB 200:WT=10:GOSUB 8300:NEXT I
5420 RETURN

6000 ' ***** DOOR ANIM *****
6010 X=0:GOTO 6050 :' LEFT OPEN
6020 X=0:GOTO 6060 :' LEFT CLOSE
6030 X=30:GOTO 6050 :' RIGHT OPEN
6040 X=30:GOTO 6060 :' RIGHT CLOSE
6050 Y=2:GOSUB 6110:Y=1:GOSUB 6120:Y=0:GOSUB 6130:RETURN :' OPEN
6060 Y=0:GOSUB 6130:Y=1:GOSUB 6120:Y=2:GOSUB 6110:RETURN :' CLOSE
6100 ' ---- DOOR PRINT SUB -----
6110 LOCATE X,17+Y-2:PRINT "of";
6120 LOCATE X,17+Y-1:PRINT "fo";
6130 LOCATE X,17+Y:PRINT "oo";
6140 IF Y<2 THEN LOCATE X,17+Y+1:PRINT "  ";
6150 GOSUB 6200:RETURN
6200 ' ----- DOOR MOVE SOUND SUB -----
6210 WT=1:FOR Q=2 TO 0 STEP -1:FOR R=100 TO 0 STEP -20
6220 SOUND 4,Q*60+R+30:SOUND 5,14:SOUND 10,7+(Q*3)+(r\20)
6230 GOSUB 8300:NEXT R,Q:SOUND 10,0:RETURN

8000 ' ***** COMMON SCREEN MAKE *****
8010 LOCATE 0, 0:PRINT "faaf                        aafa";
8015 IF GS>1 AND GS<7 THEN LOCATE 4, 0:PRINT "babfaaabaaaaafbfaafaaaab";
8020 LOCATE 0, 1:PRINT "aafd                        ceba";
8030 LOCATE 0, 2:PRINT "bff                          aaf";
8040 LOCATE 0, 3:PRINT "fac                          daf";
8050 LOCATE 0, 4:PRINT "ad                            fa";
8060 LOCATE 0, 5:PRINT "a d                           ca";
8070 LOCATE 0, 6:PRINT "a                            e a";
8080 LOCATE 0, 7:PRINT "d                              e";
8090 LOCATE 0, 8:PRINT " d                            e ";
8100 LOCATE 0, 9:PRINT "b                               ";
8110 LOCATE 0,10:PRINT "f                              b";
8110 LOCATE 0,11:PRINT "bd                            bf";
8120 LOCATE 0,12:PRINT "d                             eb";
8130 LOCATE 0,13:PRINT "                               e"; 
8140 LOCATE 0,20:PRINT "gggggggggggggggggggggggggggggggg";
8150 LOCATE 0,22:PRINT " SCORE        ROUND      LEFT";:GOSUB 2400
8160 IF GS=1 THEN 8220
8170 LOCATE 0,15:PRINT "hh";
8180 LOCATE 0,16:PRINT "hhh";
8190 LOCATE 0,17:PRINT "ooh"; :'of'
8200 LOCATE 0,18:PRINT "  h"; :'fo' 
8210 LOCATE 0,19:PRINT "  h"; :'oo'
8220 IF GS=5 THEN RETURN
8230 LOCATE 29,15:PRINT " hh";
8240 LOCATE 29,16:PRINT "hhh";
8250 LOCATE 29,17:PRINT "hoo";
8260 LOCATE 29,18:PRINT "hof";
8270 LOCATE 29,19:PRINT "hfo";
8280 RETURN

8300 ' ***** WAIT SUB *****
8310 TIME=0
8320 IF TIME<WT THEN 8320 ELSE RETURN

8500 ' ***** MUSIC *****
8505 ' ----- MAIN THEME -----
8510 PLAY "T110V12L16O4ER16FGR16","T110V12L16O3R8R16CR16","T110V12O4L16CV6CV12DEV6E"
8520 PLAY "O5CC8C4O4DR16EFF2","O4CO3CR16O4CO3CR16O4CO3CR16O4CO2GR16O3BO2GR16O3BO2GR16O3B","V12GG8G4O3BV6BV12AO4DD2"
8530 PLAY "GR16ABR16O5EE8E4","O2GR16O3BO2GR16O3BO2GR16O3BO2GR16O3B","EV6EV12FGV6GV12BB8B4"
8540 PLAY "O4AR16BO5CC2","O2AR16O3BO3CC2","EV6EV12FGG2"
8550 IF PLAY(0) THEN 8550 ELSE RETURN

8600 ' ----- MISS -----
8610 PLAY "T255L16S0M1000O4F#BO5ER2","T255L16S0M1000O5EFGR2"
8620 IF PLAY(0) THEN 8620
8630 PLAY "T120L16O4V12AV6AV12EF#V6F#V12O3BC#V6C#O5V12CO2AV6A","T120L16O5V12AV6AR16V12F#V6F#R16O4V12C#V6C#R16O3V12AV6A"
8640 RETURN

8700 ' ----- GAME OVER -----
8710 PLAY "T110L16O5V12DV6DV12C#CV6CO4V12BB4V9BV6B","T110L16O4V12A#V6A#V12AG#V6G#V12GG4V9GV6G","T110L16O2V12AR16O3A#D#R16GG4G8"
8720 PLAY "O5V12CV6CO4V12BA#V6A#V12AA4V9AV6A","O4V12G#V6G#V12GF#V6F#V12FF4V9FV6F","O2V12GR16O3G#C#R16FF4F8"
8730 PLAY "O4V12F#V6F#V12FF#V6F#V12GG8G2V11GV10GV9GV8G","O4V12C#V6C#V12C#DV6DV12D#D#8D#2V11D#V10D#V9D#V8D#","O2V12F#R16O3F#O2BR16GG8G2V11GV10GV9GV8G"
8740 IF PLAY(0) THEN 8740 ELSE RETURN

8750 ' ----- ROUND START -----
8760 PLAY "T140L16O4V12C#V8C#V12CV8CV12C#V8C#V12CV8C","T140L16O3V12A#V8A#V12AV8AV12A#V8A#V12AV8A","T140L16O2V12C#R16DR16D#R16ER16"
8770 PLAY "V12D#V8D#V12DV8DV12D#V8D#V12DV8D","V12BV8BV12A#V8A#V12BV8BV12A#V8A#","T140L16O2V12D#R16ER16FR16F#R16"
8780 PLAY "V12E2E4E8V10EV8E","V12O4C2C4C8V10CV8C","G2G4G8V10GV8G"
8790 IF PLAY(0) THEN 8790 ELSE RETURN

8800 ' ----- ROUND CLEAR -----
8810 PLAY "T110L16O5V12F#V10F#V8F#V12DF#R8.","T110L16O5V12DV10DV8DV12O4A#O5DR8.","T110L16O4V12F#R8O3A#O4F#O3A#O4DF#"
8820 PLAY "G#V10G#V8G#V12EG#R8.","EV10EV8EV12CER8.","G#R8CG#CEG#"
8830 PLAY "AV10AV8AV12EA8V10AV8AR1","EV10EV8EV12CE8V10EV8ER1","AV10AV8AV12CA8V10AV8AR1"
8840 IF PLAY(0) THEN 8840 ELSE RETURN

8900 ' ----- ALL CLEAR -----
8910 PLAY "T90L16V12O4ER16FGR16O5C8.C4O4AR16G","T90L16V12O4CR16DER8O6EV8EV12FGV8GV12O7CO4FR16E","T90L16V12R8.O3CR16O4CO3CR16O4CO3CR16O4CO3CR16O4C"
8920 PLAY "FF4F8.R16FR16GAR16O5","DR8O6AV8AV12GFV8FV12R16O4DR16EFR16","O2FR16O3FO2FR16O3FO2FR16O3FO2FR16O3FDR16O4"
8930 PLAY "D8.D4O4AR16BO5CR16E4E8.","G8.G4FR16GAR16B4B8.","DO3DR16O4DO3DR16O4DO3DR16O4DO3ER16O4E8O3ER16O4E8O3E"
8940 PLAY "R16ER16ER16ER16GG2G4.V10GV8GR1","R16BR16BR16BR16O5CC2C4.V10CV8CR1","R16O4ER16ER16ER16GG2G4.V10GV8GR1"
8950 IF PLAY(0) THEN 8840 ELSE RETURN

9000 ' ***** INITIALIZE *****
9010 DIM X(8),Y(8),TX(8),TY(8),F(8),C(8),WX(8),WY(8),VX(8),VY(8),JY(8):C=32*17::GS=1
9020 FOR I=1 TO 8:READ VX(I),VY(I):NEXT I
9030 FOR I=1 TO 7:READ JY(I):NEXT I
9040 ' PATTERN GENERATE TABLE & COLOR TABLE & SPRITE PATTERN
9050 BLOAD "PROGRAM.BIN":DEFUSR1=&HC000:DEFUSR2=&HC100:A=USR1(0)
9060 RETURN

9100 ' ***** DATA *****
9110 DATA    0,-128,  128,-128,  128,   0,  128, 128,    0,  128, -128, 128, -128,   0, -128,-128
9120 DATA 192, 128, 64, 0, -64, -128, -192
