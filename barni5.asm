; ;Kaputelefon(f4) k‚t m gneses. KTS3-hoz RFID olvas¢s
; ; K‚t m gneses: Zsilip kapus mudul is indul 1 m sodpercre nyit skor
; ; de nem lehet kl”n szab lyozni

; ;2014.07.11.	RFID nyit skor tiltott zene jelz‚skor zen‚t is kikapcsol 
; ;2008.10.31.	Villog a k rtya ‚rv‚nyesit‚s programoz sakor
; ;2008.07.24.	Automata ajt¢nyit¢ haszn lhat¢
; ;2007.08.05.	A lak s bekapcsol sa k”zben a sorkap CLR 0-ban van.
; ;2007.08.31.	Uj LAKKI rutin
; ;2005.06.24. 	RFID jelz‚s fent hiba javit s
; ;2005.08.08. 	24LC64 kezel‚s javit sa

; ;KONSTANSOK

; SZKOD	EQU 500	;SZERELO KOD (SZKDB darab) 
; KODENG  EQU 506	;K¢dra nyit s + nyit skor zene enged‚lyez‚s
; AJTIDA	EQU 507	;KAPUMAGNES MEGHUZASI IDO
; ATLAK1	EQU 508	;µtir nyitott lak s1
; ;	EQU 509	;µtir nyitott lak s1 uj cime
; ATLAK2	EQU 510 ;µtir nyitott lak s2
; ;	EQU 511	;µtir nyitott lak s2 uj cime 
; ;
; SZKDB	EQU 6	;SZERELOKOD DB
; ;BIPIDA	EQU 15	;BILLENTYUZET BIP IDO (1 SEC)
; BEKIDA	EQU 25	;LAKAS BEKAPCSOLASA UTANI TRANZIENS IDO
; CSIDOA	EQU 60	;CSENGETES IDO (30 SEC)
; CSIDEA	EQU 2	;CSENGETES ELO IDO TRANZIENS ALATT NEM FIGYELI
		; ;A KEZIBESZELO FELVETELET
; CSVILA	EQU 11	;CSENGETES VEGEN A VILLOGAS (DB)
; ERIDOA	EQU 2	;TRANZIENS KIVARASA EROSITO BEKAPCSOLASAKOR
; AUTIDA	EQU 9	;AUTOMATIKUS FELCSONGETESHEZ A VARAKOZASI IDO
; KEZDRB	EQU 200	;ISMETLES KEZIBESZELONEL
; KDB	EQU 14	;A KOD PUFFER HOSSZA
; Y	EQU 32	;SZORZO A DALLAM TABLABAN

; ;BYTE VALTOZOK
; BIPIDO	EQU 30H	;
; KAR	EQU 31H	;AZ UTOLJARA NYOMOT BILLENTYU
; KAR1    EQU 32H ;1-es DIGIT
; KAR10	EQU 33H ;10-es DIGIT
; KAR100	EQU 34H	;100-as DIGIT
; LAKSZ	EQU 35H	;Lak ssz m bin risan (0=NINCS BEKAPCSOLHAT¢)
; KARE	EQU 36H ;Az oszlop m‚r‚s t rol sa
; CSIDO	EQU 37H	;CSENGETESI IDO (0=LEJART)
; AUTIDO	EQU 38H	;AUTOMATIKUS FELCSONGETES IDO
; AJTIDO	EQU 39H	;KAPUMAGNES MEGHUZASI IDO
; SECIDO	EQU 3AH	;FEL MASODPERC IDO
; CSIDEL	EQU 3BH	;CSENGETES ELEJE, TRANZIENS MIATTI KIVARAS
; ERIDO	EQU 3CH	;EROSITO BEKAPCSOLASA TRANZIENS UTAN
; BEKIDO	EQU 3DH	;LAKAS BEKAPCSOLAS UTANI TRANZIENS KIVARASA
; KIJSZ	EQU 3EH	;KIVILAGITOTT DIGIT MUTATO FLAG
; AJTE	EQU 3FH ;1. ELOZO KULCS GOMB HELYZET
; AJTEDB  EQU 40H	;2. ENNYI DB EGYFORMA MAR VOLT
; AJTT	EQU 41H	;3. EZ AZ ELFOGADOTT ERTEKE
; KEZE	EQU 42H	;1. KEZIBESZELO HELYZET
; KEZEDB	EQU 43H	;2. ENNYI DB EGYFORMA
; KEZT	EQU 44H	;3. EZ AZ ELFOGADOTT ERTEKE
; LKOD1	EQU 45H	;A LAKASHOZ TARTOZO BYTOK AZ EEPROMBAN
; LKOD2	EQU 46H
; LKOD3	EQU 47H
; KODIDO	EQU 48H	;KODRA NYITASKOR A MAGNES IDEJE
; KAR1T	EQU 49H	;PROGRAMOZAS ALATT A KAR1-3 TAROLASA
; KAR10T	EQU 4AH
; KAR100T	EQU 4BH
; PRIDO   EQU 4CH	;PROGRAMOZAS ALLATTI SURU BIP IDO
; THH	EQU 4DH	;A DALLAM H BYTE-JA
; TLH	EQU 4EH	;    "- " L   "
; HANG	EQU 4FH	;A DALLAM EGY HANGJANAK HOSSZA
; DPOINT	EQU 50H	;A DALLAM POINTERE 
; HHOSSZ	EQU 51H	;A DALLAM UTEM SZORZOJA
; ZENEF	EQU 52H	;ZENE  0=TILTAS,1-4=ZENE FAJTA, 5=>VELETLEN 
; LDAL	EQU 53H	;A DALLAM KEZDO CIMENEK LO BYTE-JA
; HDAL	EQU 54H ;	""              HI  "
; HMAG	EQU 55H	;HANGMAGASSAG ELTOLAS (CSAK PAROS LEHET)
; KODZEN	EQU 56H	;1.K¢dra nyit skor a zene hossza/ 2.Besz‚d id‹
; ZENEV	EQU 57H ;VELETLEN SZAM ZENEHEZ
; BELIDO 	EQU 58H	;Bels“ ajt¢nyit¢ kapcsol¢ ideje
; INTR	EQU 59H	;INT 512 usec sz ml l¢(Cseng‹ hang)
; INTR2	EQU 5AH	;INT  2 msec sz ml l¢ (Kijelz‹ rutin)
; INTR3	EQU 5BH ;Er‹sit‹ mikrofon ‚s hangsz¢r¢ kapcsol¢ jel sz ml l¢
; PROBA	EQU 5CH	;
; BMUT	EQU 5DH	;Billentyûzet mutat¢ (0111 1111=nem kell lek‚rdezni)
; BPUF	EQU 5EH	;Az infrasugarak m‚r‚s‚nek t rol sa
; HANGR	EQU 5FH ;Csenget‚si hanger‹
; ESTIDO	EQU 60H	;S”t‚tben a  vonal kijelz‚s ideje(30 sec)
; LEDIDO	EQU 61H	;Vil git s LED k‚sleltet‚si id‹
; ZENER	EQU 62H	;El“z“ zene fajta
; NORMAG	EQU 63H	;Norm l m gnes teljes er‹vel h£z 0.25 sec-ig
; RF1	EQU 64H	;RFID lak ssz m ‚rv‚nyesit‚skor
; RF2	EQU 65H	;RFID lak ssz m keres‚skor
; RF3	EQU 66H	;Az el‹z‹ k rtya adatai(5 byte)
; RF4	EQU 6BH	;70 msec a lek‚rdez‚s
; PUF	EQU 6CH ;KOD PUFFER A BILLENTYUZES SOR TAROLASARA

; ;BIT VALTOZOK
; ALAP	EQU 57H	;ALAPHELYZET FLAG 0=ALAP  1=BEKAPCSOLT LAKAS
; FELVET  EQU 56H	;KEZIBESZELO  0=NEM VOLT FELVEVE, 1=FEL VOLT
; HFLAG	EQU 55H	;0=NINCS HIBA, 1=KULCS GOMB BE VAN RAGADVA A
		; ;KEZIBESZELON
; PFLAG   EQU 54H	;A LAKO PROGRAMOZZA A LAKASKODOT
; TRUN	EQU 53H ;1=TIMER0 JAR, 0=LEALLITHATO
; MIKRO   EQU 52H	;MIKRO SZUNET FLAG KET HANG KOZOTT
; RSZ	EQU 51H ;RENDES SZUNET FLAG
; REFF	EQU 50H	;REFREN FLAG 1=REFRENT JATSZA

; BINF0	EQU 4FH	;Dallam lej tsz skor szinkron flag
; K1F	EQU 4EH	;EGYSZERI FLAG,NE TOROLJON KODRANYITAS
; KODENF	EQU 4DH	;KODRA NYITAS FLAG (0=TILTOTT A KODRA NYITAS)
; KODZZF	EQU 4CH	;KODRA NYITASKOR ZENE ENGEDELYEZETT (0=TILTVA)
; PSFL	EQU 4BH	;PSORKI RUTIN FLAGJE
; BINF	EQU 4AH ;Billentyûzet szinkron flag
; KODZZE	EQU 49H	;K¢dra nyit s jelz‚se a lak sban egyedileg engedve
; MBF	EQU 48H	;Norm l m gnest minden m sodik ciklusn l kikapcsolja
; EROF	EQU 47H	;Er‹sit‹ kapcsol¢i flag
; KOZF	EQU 46H	;A k”z”s input lek‚rdez‚s flagja
; INVF	EQU 45H ;Inverz jumper flag
; BILF	EQU 44H	;1=Az IT m‚rje a sugarakat, 0=K‚sz a m‚r‚s
; VILF	EQU 43H ;Villogtat s flag
; EEPF	EQU 42H	;A eeprom rutin ne legyen megszakitva
; EEPF2	EQU 41H	;KTL00 rutin ne szakithassa meg ”nmag t 	
; TORF	EQU 40H	;T”rl‚s flag, az IT-ben kijel”lik
; FELVIT	EQU 3FH	;Az IT felv‚tel vizsg l¢ flagje
; ;Hardware le¡r s:
; ;AT89C2051 (P1,P3,TIMER0,TIMER1, 128 BYTE RAM, 2KBYTE FLASH)
; ;24LC64 (64 Kbit= 8 Kbyte soros EEPROM)
; ;74HC595 SOROS PORT

	; ;Sorosan irhat¢ portok (74HC595, U9,U5,U8)	
; PSOR1  	EQU 2FH	;U9 PSOR1 rutin kezeli	
		; ;BIT cimek
; LEDN 	EQU 78H	;N‚vsor LED-ek	(U9)
; LEDB 	EQU 79H	;RFID olvas¢ vez‚rl‹: 0=van  1=nincs olvas s
; DALENG 	EQU 7AH	;BIP vagy a dallam kapcsol sa az er‹sit‹re
; MAGNES 	EQU 7BH	;M gnes mûk”dtet‚s
; INFRA 	EQU 7CH	;Infra ledek k”z”s an¢dja
; KJEGY	EQU 7DH	;1-es digit an¢dja 
; KJTIZ 	EQU 7EH	;10-es digit an¢dja
; KJSZAZ 	EQU 7FH	;100-as digit an¢dja

; PSOR2	EQU 2EH	;U5
		; ;BIT c¡mek
; GOND1	EQU 70H	;+1 lak s
; GOND2	EQU 71H	;+2 lak s
; SKDA	EQU 72H	;Sorkapocs adat, csenget‚si hanger‹ k”zepes
; SKCK	EQU 73H	;Sorkapocs clok, csenget‚si hanger‹ halk
; O1	EQU 74H	;Vonal feszlts‚g lekapcsol sa felcsenget‚skor
; O2	EQU 75H	;Rel‚ mûk”dtet‚s di¢d sn l
; DALT	EQU 76H	;BIP-kor tilt s a fesz.sokszorz¢n l
; ZUM	EQU 77H	;Zmmer mûk”dtet‚s m gnes kezel‚sn‚l

; PSOR3	EQU 2DH	;U8

	; ;A port3 bitjei 68H-6EH-ig a lak spanelek paralel CLK bitjei
; SKCLR	EQU 6FH	;A lak spanelek k”z”s t”rl‹ bitje

; PSOR4	EQU 2CH;U20 PSOR2 rutin kezeli
		; ;BIT cimek
	; ;60H-67H-IG INFRA ad¢ LED, 7 szegmenses kijelz‹, 
	; ;k”z”s ‚rz‚kel‹ BIT-ek 
; L1	EQU 60H	;Bels‹ nyit¢ gomb
; L2 	EQU 61H	;Inverz ‚rz‚kel‹
; L3	EQU 62H	;S”t‚ted‚s ‚rz‚kel‹
; L7	EQU 67H	;DP h‚tszegmenses kijelz‹

; PSOR5	EQU 2BH	;U19
		; ;BIT cimek
	; ;58H-5EH-ig INFRA vev‹ di¢d k
; F8	EQU 5FH	;Szabad

	; ;Processzor PORT-ok
	; ;P1 port 
; KOZIN 	EQU 90H		;K”z”s bemenet:Bels‹ nyit s, s”t‚ted‚s, inverz
; UJDAL 	EQU 91H		;Szoftveres dallam kimenet
; LED1	EQU 92H		;LED1 port GOMB1	EQU 0B7H	;1. gomb port
; KT 	EQU 93H		;Cseng‹ modul energia 
; ;INPUT BITEK:
; ZARL 	EQU 94H		;LENT A BELSO KAPCSOLO A KAPUNYITASHOZ
; ZARF 	EQU 95H		;LAKASKESZULEK  KULCS GOMBJA
; FELV 	EQU 96H		;A KEZIBESZELO HELYZETE
; BIN 	EQU 97H		;A BILLENTYUZET INPUTJA

; ;PORT3 BIT CIMEI
; DA 	EQU 0B0H	;Soros adat
; CK 	EQU 0B1H	;Soros clock
; OUT1 	EQU 0B2H	;PSOR1 paralel clock
; OUT2 	EQU 0B3H	;PSOR2 paralel clock
; EROM 	EQU 0B4H	;Er‹sit‹ mikrofon kapcsol¢ vez‚rl‚s
; CK24 	EQU 0B5H	;LC24 EEPROM clock
; GOMB1	EQU 0B7H	;1. gomb port
; ;
; ;FOPROGRAM
	; ORG 0
	; AJMP KEZD

; INTT0	CLR UJDAL	;TIMER0 RUTIN
	; CLR TR0
	; CLR ET0
	; RETI
	; ORG 0BH		;TIMER0 VECTOR
	; CLR BINF0	;A billentyûzet szinkron flag t”rl‚se
	; JNB TRUN,INTT0	;DAL LEALLITAS
	; JB RSZ,DAL1
	; JB MIKRO,MSZUN	;MIKRO SZUNETRE UGRIK
	; AJMP DALI
	; ORG 1BH
; ;	AJMP IDOINT1

; DALI	CPL UJDAL
	; CLR TR0
	; MOV TL0,TLH	;HOSSZ BEALLITAS
	; MOV TH0,THH
	; SETB TR0
	; RETI
; DAL1	CLR TR0		;SZAMLALAST LEALLIT
; MSZUN	CLR MIKRO
	; MOV TL0,#155	;222;#230; 24MHz,8MHz,6MHz
	; MOV TH0,#255  
	; RETI

; KEZD	MOV SP,#0FH	;SP be llit s. Bank 0 ‚s bank 1 haszn lhat¢
	; CLR CK24	;EEPROM chip select tilt sa
	; MOV C,MAGNES	;Billentyûzet RESET-re a m gnes ne mozduljon
	; MOV 07H,C
	; MOV C,LEDN
	; MOV 08H,C
	; CLR A		;Kezd‹ null z s
	; MOV R0,#7FH
; KEZD0   MOV @R0,A
	; DEC R0
	; CJNE R0,#22H,KEZD0

LED1	EQU 92H		;LED1 port
GOMB1	EQU 0B7H	;1. gomb port
GOMB2	EQU 93H		;2. gomb port
RF1	EQU 64H	;COUNTER1
RF2	EQU 65H	;COUNTER2
RF3	EQU 66H	;BLINK COUNTER

KEZD01	CLR LED1	 	;BARNI's program start from here
		MOV RF1,#255	;255 -> RF1 regiszter
		MOV RF2,#255
		MOV RF3,#005
MAIN	SETB GOMB1
		JNB GOMB1,TIMER
		JMP MAIN
TIMER	SETB LED1
		CALL TM1
		CLR LED1
		CALL TM1
		DJNZ RF3,TIMER
		JMP KEZD01
		
TM1		CALL TM2
		CALL TM2
		CALL TM2
		DJNZ RF1,TM1
		RET
		
TESTER	SETB GOMB1
		JB GOMB1,KEZD01
		RET

TM2		CALL TESTER
		DJNZ RF2,TM2
		RET