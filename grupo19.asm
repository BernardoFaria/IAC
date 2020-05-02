; **************************************************************************
; * Projeto de Introdução a Arquitetura de Computadores - "Treino de Ninjas"
; * Ana Simões 			90703
; * Catarina Gonçalves 	90709
; * Bernardo Faria 		87636
; **************************************************************************



; **************************************************************************
; * Constantes
; **************************************************************************

DISPLAYS					EQU 0A000H		; endereço dos displays de 7 segmentos (periférico POUT-1)
TEC_LIN						EQU 0C000H		; endereço das linhas do teclado (periférico POUT-2)
TEC_COL						EQU 0E000H		; endereço das colunas do teclado (periférico PIN)
LINHA						EQU 8     		; linha a testar (4ª linha, 1000b)
SOMA 						EQU 0001H		; flag para a soma
SUBTRACAO					EQU 0002H		; flag para a subtração
TECLA_SUB					EQU 000DH		; tecla da subtração
TECLA_SOMA					EQU 000CH		; tecla da soma
TECLA_SUB_3					EQU 000FH		; tecla de subtrair 3
TECLA_SOMA_3				EQU 000EH		; tecla de somar 3
DEZ							EQU 10			; numero para fazer o resto da divisão
TAM_HEXA					EQU 4			; numero de bits de um hexadecimal
PIXELSCREEN					EQU	8000H		; endereço do pixelscreen
ATIVO						EQU	0001H		; ativar flags / comparar
DESATIVO					EQU	0000H		; desativar flags / comparar
CLEAN_PXS_LIMITE			EQU 8080H		; limite para limpar o pixelscreen





; **************************************************************************
; * Simbologia para o teclado
; **************************************************************************

SEM_TECLA                   EQU 0015H   	; representa sem rotina



; **************************************************************************
; * Valores para os ninjas e os seus movimentos
; **************************************************************************

NEXT_STRING					EQU 0001H		; valor que permite percorrer dentro das strings do ninja
COUNTER_INCREASE			EQU 1			; valor que incrementa os contadores
MOVE_UP						EQU 0001H		; movimento para cima
MOVE_DOWN					EQU 0002H		; movimento para baixo
MOVE_LEFT					EQU	0003H		; movimento para a esquerda
SHURIKEN_UP					EQU	0			; usada no contador	(pôr a estrela em cima)
SHURIKEN_DOWN				EQU	2			; usada no contador (pôr a estrela em baixo)
PRESENT_UP					EQU 4			; usada no contador	(pôr o presente em cima)
PRESENT_DOWN				EQU 7			; usada no contadro (pôr o presente em baixo)
NULL_OBJECT					EQU 0000H		; usada no upper_object e no lower_object



; **************************************************************************
; * Variáveis
; **************************************************************************

PLACE 2000H 
pilha:
	TABLE 200H				; espaço reservado para a pilha
fim_pilha:


tabela_teclado: 			; lista de funções que o teclado vai executar 
    WORD subir_ninja1		; tecla 0: subir o ninja 1
    WORD subir_ninja2		; tecla 1: subir o ninja 2
    WORD subir_ninja3		; tecla 2: subir o ninja 3
    WORD subir_ninja4		; tecla 3: subir o ninja 4
    WORD descer_ninja1		; tecla 4: descer o ninja 1
    WORD descer_ninja2		; tecla 5: descer o ninja 2
    WORD descer_ninja3		; tecla 6: descer o ninja 3
    WORD descer_ninja4		; tecla 7: descer o ninja 4
    WORD SEM_TECLA			; tecla 8: não tem função
    WORD SEM_TECLA			; tecla 9: não tem função
    WORD SEM_TECLA			; tecla A: não tem função
    WORD SEM_TECLA			; tecla B: não tem função
    WORD comecar_jogo		; tecla C: começar o jogo
    WORD SEM_TECLA;suspender_jogo		; tecla D: suspender/continuar o jogo
    WORD SEM_TECLA	;terminar_jogo		;E		
    WORD SEM_TECLA			; tecla F: não tem função

	

; Interrupções	
tab_int:
	WORD interruption_gravity	; int0
	WORD interruption_guns		; int1
	;WORD 0						; int2
	;WORD 0


objeto_atual:
	WORD	ninja
upper_object:
	WORD	0H				; objeto acima do meio do pixelscreen
lower_object:
	WORD	0H				; objeto abaixo do meio do pixelscreen


valor:
	STRING	00H 	
operacao_string:
	STRING	00H 
contador:					; contador para o gerador
	STRING	0H

	
estado_jogo:				; verifica o estado de jogo
	STRING	0H
	
	
	
ninja_1_x:					; coordenada x do ninja 1
	STRING	0H
ninja_1_y:					; coordenada y do ninja 1
	STRING	0AH				
ninja_2_x:					; coordenada x do ninja 2
	STRING	4H
ninja_2_y:					; coordenada y do ninja 2
	STRING 	0AH
ninja_3_x:					; coordenada x do ninja 3
	STRING	8H
ninja_3_y:					; coordenada y do ninja 3
	STRING	0AH
ninja_4_x:					; coordenada x do ninja 4
	STRING	0CH
ninja_4_y:					; coordenada y do ninja 4
	STRING	0AH
upper_x:
	STRING	1DH				; coordenada x acima do meio do pixelscreen
upper_y:
	STRING	7H				; coordenada y acima do meio do pixelscreen
lower_x:
	STRING	1DH				; coordenada x abaixo do meio do pixelscreen
lower_y:
	STRING	17H				; coordenada y abaixo do meio do pixelscreen


ninja:						; tabela que especifica o ninja
	STRING	4,3				; dimensão do objeto
	STRING	0,1,0
	STRING	1,1,1
	STRING	0,1,0
	STRING	1,0,1
	
estrela_laminas:			; tabela que especifica a estrela de lâminas (X)
	STRING	3,3				; dimensão do objeto
	STRING	1,0,1
	STRING	0,1,0
	STRING	1,0,1
	
presente:					; tabela que especifica o presente (+)
	STRING	3,3				; dimensão do objeto
	STRING	0,1,0
	STRING	1,1,1
	STRING	0,1,0


mask_table:					; Tabela para definir o pixel a ser pintado na coluna
	STRING 0080H			; Cada coluna tem 8 celulas por isso temos uma tabela
	STRING 0040H
	STRING 0020H
	STRING 0010H
	STRING 0008H
	STRING 0004H
	STRING 0002H
	STRING 0001H
	



flag_paintxy:
	STRING 0001H			; flag que verifica se é para pintar ou apagar
flag_paint_object:
	STRING 0001H			; flag que verifica se é para pintar ou não o objeto
flag_gravity:
	STRING 0000H			; flag que ativa a "gravidade" dos ninjas
flag_guns:
	STRING 0000H			; flag que ativa as armas (estrela de lâminas ou presente)
ultima_tecla_premida:
	STRING SEM_TECLA		; valor que o teclado nunca vai tomar
	
	

	
begining:
	STRING 0H, 2H, 0H, 0H
	STRING 0H, 2H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 01H, 08H, 0H
	STRING 0H, 01H, 08H, 0H
	STRING 0H, 07H, 0E0H, 0H
	STRING 0H, 07H, 0E0H, 0H
	STRING 0H, 01H, 08h, 0H
	STRING 0H, 01H, 08H, 0H
	STRING 0H, 06H, 060H, 0H
	STRING 0H, 06H, 060H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 0H, 0H, 0H, 0H
	STRING 42H, 0E8H, 5FH, 7EH
	STRING 62H, 4CH, 44H, 42H
	STRING 52H, 4AH, 44H, 42H
	STRING 4AH, 49H, 44H, 7EH
	STRING 46H, 48H, 04H, 42H
	STRING 42H, 0E8H, 5CH, 42H
	STRING 0H, 0H, 0H, 0H
	
	
	
; *********************************************************************
; * Código
; *********************************************************************

PLACE		0
MOV BTE, tab_int			; inicializa BTE
MOV SP, fim_pilha			; inicializa SP
EI1
EI0
EI

;MOV R1, 1  ;x
;MOV R2, 1	; y
;CALL paint_object


;MOV R0, flag_paintxy
;MOV R3, 0
;MOVB [R0], R3
;CALL paint_object

;MOV R1, 10
;MOV R2, 10

;MOV R0, flag_paintxy
;MOV R3, 1
;MOVB [R0], R3
;CALL paint_object

;MOV R8, 1H
;CALL move_object

;MOV R8, 3H
;CALL move_object

;MOV R8, 2H
;CALL move_object





;MOV R1, 15
;MOV R2, 10
;MOV R0, objeto_atual
;MOV R3, presente
;MOV [R0], R3
;CALL paint_object


CALL clean_pixelscreen			; limpa o ecrã
;CALL paint_screen_begining


main:
	CALL keyboardcheck			; rotina de leitura do teclado	
	CALL processamento_tecla	; rotina de processamento de tecla
	CALL interruptions			; rotina das interrupções
	JMP main


	
; **************************************************************************
; * Rotina:	keyboardcheck
; * Descrição: verifica qual a tecla permida
; *				
; *	Parâmetros: R8 (valor da tecla)
; * Devolve: 
; **************************************************************************

keyboardcheck:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R6
	PUSH R7
	PUSH R9
    MOV  R2, TEC_LIN   ; endereço do periférico das linhas
    MOV  R3, TEC_COL   ; endereço do periférico das colunas
    MOV  R4, DISPLAYS  ; endereço do periférico dos displays

colunas:                
    ;MOV  R1, 0000H 		
    ;MOV  R9, 0  
    ;MOVB [R4], R1      ; escreve linha e coluna a zero nos displays

caso_zero:
    MOV R1, LINHA

espera_tecla:
    MOVB [R2], R1      ; escrever no periférico de saída (linhas)
    MOVB R0, [R3]      ; ler do periférico de entrada (colunas)
    CMP  R0, 0         ; há tecla premida?
    JZ   proxima_linha ; se nenhuma tecla premida, repete
    JMP converter_valor

proxima_linha: 
    SHR R1,1
    JZ  nenhuma_tecla
    JMP espera_tecla

converter_valor:   
    MOV R6, R1          ;mover o valor para R6 para ser usado no cálculo das linhas
    MOV R7, R0          ;mover o valor para R7 para ser usado no cálculo das colunas
    MOV R8, 0           ;o R8 vai ser o contador dos shifts
contador_linhas:
    ADD R8, 4           ;adicionar o valor dos shifts feitos na coluna 
    SHR R6, 1           ;
    JNZ contador_linhas  
contador_colunas:
    ADD R8, 1
    SHR R7, 1
    JNZ contador_colunas
    SUB R8, 5           ;subtrai 5 ao número de shifts feitos porque para cada ciclo existe 5 a mais 
	JMP fim_keyboard
nenhuma_tecla: 
	MOV R8, SEM_TECLA
fim_keyboard:
	POP R9
	POP R7
	POP R6
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET



	
; **************************************************************************
; * Rotina:	processamento_tecla
; * Descrição: verifica qual a tecla permida, e realiza a sua rotina	

; *	Parâmetros: R8 (valor da tecla)
; **************************************************************************

processamento_tecla:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	
	MOV R0, ultima_tecla_premida
	MOVB R1, [R0]
	CMP R1, R8
	JZ fim_processamento_tecla
	MOVB [R0], R8
	
	MOV R0, SEM_TECLA		;O valor sem tecla representa que nenhuma tecla foi pressa
	CMP R8, R0				; se for verdadeiro faz o jump para o final da rotina
	JZ fim_processamento_tecla 
	
	MOV R0, tabela_teclado	; 
	SHL R8, 1				; corresponde à multiplicação por dois
	ADD R0, R8
	MOV R1, [R0]
	CALL R1
	
fim_processamento_tecla:
	POP R6
	POP R5
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
	
; **************************************************************************
; * Rotina:   subir_ninja1	
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
subir_ninja1:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_1_x				; vai buscar a coordenada x do ninja 1
	MOVB R1, [R0]					; lê a coordenada 
	MOV R0, ninja_1_y				; vai buscar a coordenada y do ninja 1
	MOVB R2, [R0]					; lê a coordenada	
	MOV R8, MOVE_UP					; vai buscar o valor que permite o ninja subir
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
	
	
; **************************************************************************
; * Rotina:   descer_ninja1	
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
descer_ninja1:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_1_x				; vai buscar a coordenada x do ninja 1
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_1_y				; vai buscar a coordenada y do ninja 1
	MOVB R2, [R0]					; lê a coordenada
	MOV R8, MOVE_DOWN				; vai buscar o valor que permite o ninja descer
	CALL move_object				; pinta o ninja na nova posição	
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET

	
	
; **************************************************************************
; * Rotina:   subir_ninja2	
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
subir_ninja2:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_2_x				; vai buscar a coordenada x do ninja 2
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_2_y				; vai buscar a coordenada y do ninja 2
	MOVB R2, [R0]					; lê a coordenada
	MOV R8, MOVE_UP					; vai buscar o valor que permite subir o ninja
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
; **************************************************************************
; * Rotina:   descer_ninja2	
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
descer_ninja2:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_2_x				; vai buscar a coordenada x do ninja 2
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_2_y				; vai buscar a coordenada y do ninja 2
	MOVB R2, [R0]					; lê a coordenada
	MOV R8, MOVE_DOWN				; vai buscar o valor que permite descer o ninja 
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET

	
	
; **************************************************************************
; * Rotina:   subir_ninja3
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
subir_ninja3:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_3_x				; vai buscar a coordenada x do ninja 3
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_3_y				; vai buscar a coordenada y do ninja 3
	MOVB R2, [R0]					; lê a coordenada 
	MOV R8, MOVE_UP					; vai buscar o valor que permite subir o ninja
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
	
; **************************************************************************
; * Rotina:   descer_ninja3
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
descer_ninja3:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_3_x				; vai buscar a coordenada x do ninja 3
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_3_y				; vai buscar a coordenada y do ninja 3
	MOVB R2, [R0]					; lê a coordenada
	MOV R8, MOVE_DOWN				; vai buscar o valor que permite descer o ninja
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET

	
	
; **************************************************************************
; * Rotina:   subir_ninja4	
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
subir_ninja4:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_4_x				; vai buscar a coordenada x do ninja 4
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_4_y				; vai buscar a coordenada y do ninja 4
	MOVB R2, [R0]					; lê a coordenada
	MOV R8, MOVE_UP					; vai buscar o valor que permite subir o ninja
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a coordenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
	
; **************************************************************************
; * Rotina:   descer_ninja4	
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
descer_ninja4:
	PUSH R0						
	PUSH R1
	PUSH R2
	PUSH R4
	
	MOV R0, ninja_4_x				; vai buscar a coordenada x do ninja 4
	MOVB R1, [R0]					; lê a coordenada
	MOV R0, ninja_4_y				; vai buscar a coordenada y do ninja 4
	MOVB R2, [R0]					; lê a coordenada 	
	MOV R8, MOVE_DOWN				; vai buscar o valor que permite descer o ninja
	CALL move_object				; pinta o ninja na nova posição
	MOVB [R0], R2					; atualiza a corodenada y do ninja
	
	POP R4
	POP R2
	POP R1
	POP R0
	RET
	
	
	
; **************************************************************************
; * Rotina:   paintxy		
; * Descrição: pinta ou limpa no pixelscreen nas coordenadas de um ponto (x,y)
; *
; *	Parâmetros: R1, R2
; **************************************************************************
	
paintxy:
	PUSH R0						; guarda o valor dos registos
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R8
	PUSH R9
	PUSH R10
	MOV R0, PIXELSCREEN			; registo que guarda o endereço do pixelscreen
	MOV R8, R1					; registo que guarda a coordenada x
	MOV R9, R2					; registo que guarda a coordenada y
	SHL R9, 2					; 4 * linha (shiftar duas vezes para ir para a primeira linha)
	SHR R8, 3					; coluna div 8 (shiftar três vezes para ir para a primeira coluna)
	ADD R8, R9					; equação do byte a ser pintado = pixelscreen + 4*linha + coluna//8
	ADD R0, R8					; byte a ser pintado
	
	MOV R5, mask_table			; registo que vai guardar as máscaras
	MOVB R9, [R0]				; guarda o endereço do byte a ser pintado
	MOV R6, 8
	MOD R1, R6					; bit a ser mudado pela máscara
	ADD R5, R1					; obtém o endereço da máscara pretendida
	MOVB R3, [R5]				; obtém a máscara pretendida
	
check_paintxy:	
	MOV R4, flag_paintxy		; vê se é para pintar ou para limpar
	MOVB R10, [R4]				; MOVB porque é uma string
	CMP R10, ATIVO				; vai verificar se é para pintar ou para limpar
	JNZ clear_pixel				; caso o bit esteja pintado, vai apagá-lo; caso contrário, vai pintar o pixel	
	
paint:
	OR R9, R3					; põe o bit a ser pintado a 1
	;MOV R10, 1
	;MOVB [R4], R10				; altera a flag_paintxy
	JMP paintxy_end				
	
clear_pixel:
	NOT R3						; "inverte" a máscara
	AND R9, R3					; põe o bit pintado a 0
	;MOV R10, 0
	;MOVB [R4], R10				; altera a flag_paintxy
	
paintxy_end:					; recupera o valor dos registos
	MOVB [R0], R9				; pinta/limpa o pixel correspondente no pixelscreen
	POP R10
	POP R9
	POP R8
	POP R6
	POP R5
	POP R4
	POP R2
	POP R1
	POP R0
	RET

	
	

; **************************************************************************
; * Rotina: paint_object
; * Descrição: Funcao que vai pintar os diferentes objetos
; *
; *	Parâmetros: 
; *	Destroy: -
; * Devolve: -
; **************************************************************************

paint_object:						; guarda o valor dos registos
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	MOV R5, objeto_atual			; recebe em memória o endereço da word
	MOV R6, [R5]					; preenche com a etiqueta que está gravada na word
	MOV R0, R6						; recebe em memória o ninja
	MOVB R3, [R0]					; contador do y: a altura do ninja é 4, portanto vão ser sempre 4 blocos a serem pintados
									; R1 é o ponteiro na tabela
	
	ADD R0, NEXT_STRING				; vai avançar para o segundo valor da primeira string do ninja (comprimento do ninja- x)
	MOVB R4, [R0]					; contador do x: o comprimento do ninja é 3, portanto vão ser sempre 3 blocos a serem pintados
	MOV R5, R1						; backup do valor do x
	MOV R6, R3						; usado para fazer subtração (contador do y)
	
check_heigth:						; vai verificar se pintamos o ninja todo
	MOV R7, R4						; usado para fazer subtração (contador do x)
	;JMP check_lenght				; começa por chamar a função que vai pintar o ninja
	MOV R1, R5						; o valor de x fica em R1
	;MOV R5, COUNTER_INCREASE		; incrementa o contador da altura (y) em 1
	;CMP R3, R5						; vejo se terminei de pintar o ninja
	;JNZ check_height				; caso não tenha terminado, vai acabar de pintá-lo
	;JMP paint_ninja_end				; caso tenha terminado, não pinta mais nada

check_length:						; vai verificar o que é para pintar, linha a linha
	ADD R0, NEXT_STRING				; vai lendo as strings
	MOVB R8, [R0]					; este registo aqui vai tendo os valores das strings
	CMP R8, ATIVO					; vê se é para pintar ou não
	JNZ dont_paint					; se a string é 0, não vai pintar esse píxel
	CALL paintxy					; se a string é 1, vai pintar esse píxel
	
dont_paint:
	ADD R1, COUNTER_INCREASE		; somar ao contador do x 
	SUB R7, COUNTER_INCREASE		; incrementa o contador do comprimento (x) em 1
	JNZ check_length				; caso não a tenhamos pintado toda, vai acabar de pintar
	
	ADD R2, COUNTER_INCREASE		; somar ao contador do y
	SUB R6, COUNTER_INCREASE		; subtraio ao contador
	JNZ check_heigth				;
	

paint_ninja_end:					; recupera o valor dos registos
	POP R8
	POP R7
	POP R6
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
	
	
	
; **************************************************************************
; * Rotina: move_object
; * Descrição: Funcao que vai mover os objetos
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************

move_object:
	PUSH R0
	PUSH R3
	MOV R0, flag_paintxy			; guarda a flag_paintxy
	MOV R3, DESATIVO				; vai meter a flag_paintxy a 0
	MOVB [R0], R3					; mete a flag_paintxy a 0
	CALL paint_object				; chama a função para limpar o objeto

	;MOV R4, R8						; vamos verificar qual o movimento a ser feito
	;MOVB R5, [R4]					; salvaguarda do endereço do parâmetro que vai receber

check_move:							; vê qual é o movimento a ser feito
	CMP R8, MOVE_UP					; vê se é para subir o objeto
	JZ move_up						; caso seja, vai mover o objeto para cima
	CMP R8, MOVE_DOWN				; vê se é para descer o objeto
	JZ move_down					; caso seja, vai mover o objeto para baixo
	CMP R8, MOVE_LEFT				; vê se é para mover o objeto para a esquerda
	JZ move_left					; caso seja, vai mover o objeto para a esquerda
	
move_up:							; mover o objeto para cima
	SUB R2, 1						; move a coordenada do y uma posição acima (move o objeto para cima)
	JMP paint_new_position			; vai pintar o objeto na nova posição
	
move_down:							; mover o objeto para baixo
	ADD R2, 1						; move a coordenada do y uma posição abaixo (move o objeto para baixo)
	JMP paint_new_position			; vai pintar o objeto na nova posição
	
move_left:							; mover o objeto para a esquerda
	SUB R1, 1						; move a coordenada do x uma posição para a esquerda (move o objeto para a esquerda)
	JMP paint_new_position			; vai pintar o objeto na nova posição
	
paint_new_position:					; vai pintar o objeto na nova posição
	MOV R0, flag_paintxy			; guarda a flag_paintxy
	MOV R3, ATIVO					; vai meter a flag_paintxy a 1
	MOVB [R0], R3					; mete a flag_paintxy a 1
	CALL paint_object				; chama a função para pintar o objeto na nova posição
	
move_object_end:
	POP R3
	POP R0
	RET
	
	
	
	
	
; **************************************************************************
; * Rotina: gerador
; * Descrição: Função que vai gerar os ninjas e verifica o estado de jogo
; *
; *	Parâmetros: 
; *	Destroy: -
; * Devolve: -
; **************************************************************************	
	
gerador:
	PUSH R0
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	MOV R0, contador			; R0 fica como contador
	MOVB R3, [R0]				; acedemos ao contador 
	ADD R3, 1					; valor que incrementa o contador
	MOVB [R0], R3				; incrementa o contador
	
check_estado_jogo:
	MOV R4, estado_jogo			; R4 fica com o estado do jogo
	MOVB R6, [R4]				; ler da string
	MOV R5, 1					; valor para comparar o esa
	CMP R6, R5					; vê se o estado de jogo está a 1
	JZ create_ninjas			; caso esteja a 1, vai criar os ninjas
	JMP gerador_end
	ADD R6, R5					; põe o estado de jogo igual a 2
	MOVB R4, [R6]				; atualiza o estado de jogo

create_ninjas:
	MOV R3, ninja_1_x			; coordenada x do primeiro ninja
	MOVB R1, [R3]				; leitura da coordenada x do primeiro ninja
	MOV R3, ninja_1_y			; coordenada y do primeiro ninja
	MOVB R2, [R3]				; leitura da coordenada y do primeiro ninja
	CALL paint_object			; pinta o primeiro ninja
	
	MOV R3, ninja_2_x			; coordenada x do segundo ninja
	MOVB R1, [R3]				; leitura da coordenada x do segundo ninja
	MOV R3, ninja_2_y			; coordenada y do segundo ninja
	MOVB R2, [R3]				; leitura da coordenada y do segundo ninja
	CALL paint_object			; pinta o segundo ninja
	
	MOV R3, ninja_3_x			; coordenada x do terceiro ninja
	MOVB R1, [R3]				; leitura da coordenada x do terceiro ninja
	MOV R3, ninja_3_y			; coordenada y do terceiro ninja
	MOVB R2, [R3]				; leitura da coordenada y do terceiro ninja
	CALL paint_object			; pinta o terceiro ninja
	
	MOV R3, ninja_4_x			; coordenada x do quarto ninja
	MOVB R1, [R3]				; leitura da coordenada x do quarto ninja
	MOV R3, ninja_4_y			; coordenada y do quarto ninja
	MOVB R2, [R3]				; leitura da coordenada y do quarto ninja
	CALL paint_object			; pinta o quarto ninja
	
gerador_end:
	POP R6
	POP R5
	POP R4
	POP R3
	POP R0
	RET
	
	
	
	
	
; **************************************************************************
; * Rotina: clean_pixelscreen
; * Descrição: Função que vai limpar o pixelscreen
; *
; *	Parâmetros: 
; *	Destroy: -
; * Devolve: -
; **************************************************************************	

clean_pixelscreen:
	PUSH R0
	PUSH R1
	PUSH R2

	MOV R0, PIXELSCREEN				; contém o pixelscreen

word_by_word:
	MOV R1, 0000H					; valor que limpa os pixeis
	MOV [R0], R1					; vai limpar word a word
	ADD R0, 2H						; soma dois para passar para a próxima word
	MOV R2, CLEAN_PXS_LIMITE		; vai ter o limite
	CMP R2, R0						; vê se acabou de pintar
	JNZ word_by_word				; verifica se já acabou de limpar o pixelscreen
	
	POP R2
	POP R1
	POP R0
	RET
	
	
	
	
; **************************************************************************
; * Rotina: create_shuriken
; * Descrição: Função que vai gerar a estrela de lâminas (shuriken)
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************	

create_shuriken:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R8
	MOV R0, objeto_atual				; guarda o objeto atual
	MOV R1, estrela_laminas				; mudamos o objeto atual
	MOV [R0], R1						; o objeto atual é agora a estrela de lâminas (shuriken)
	
	CMP R8, 0							; caso seja 0, o shuriken vai ficar na parte superior do pixelscreen
	JZ paint_shuriken_up				; e vai pintar o shuriken
	JNZ paint_shurike_down				; e vai pintar o shuriken

paint_shuriken_up:						; pinta o shuriken na parte superior do pixelscreen
	MOV R2, upper_object				; guarda a string
	MOV R3, estrela_laminas				; vamos mudar o objeto atual
	MOV [R2], R3						; o upper_object passa a ter a estrela de lâminas
	MOV R4, upper_x						; coordenada x acima do meio do pixelscreen
	MOVB R1, [R4]						; pomos a coordenada x correta
	MOV R4, upper_y						; coordenada y acima do meio do pixelscreen
	MOVB R2, [R4]						; pomos a coordenada y correta
	CALL paint_object					; pinta o shuriken na posição dada
	JMP create_shuriken_end				; termina a rotina
	
paint_shurike_down:						; pinta o shuriken na parte inferior do pixelscreen
	MOV R2, lower_object				; guarda a string
	MOV R3, estrela_laminas				; vamos mudar o objeto atual
	MOV [R2], R3						; i lower_object passa a ter a estrela de lâminas
	MOV R4, lower_x						; coordenada x abaixo do meio do pixelscreen
	MOVB R1, [R4]						; pomos a coordenada x correta
	MOV R4, lower_y						; coordenada y abaixo do meio
	MOVB R2, [R4]						; pomos a coordenada y correta
	CALL paint_object					; pinta o shuriken na posição dada
	JMP create_shuriken_end				; termina a rotina
	
create_shuriken_end:
	MOV R2, objeto_atual				; vamos voltar a tornar o objeto atual como ninja
	MOV R3, ninja						; recebe o ninja
	MOV [R2], R3						; mete o ninja como objeto atual de novo
	
	POP R8
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
	
	
	
; **************************************************************************
; * Rotina: create_present
; * Descrição: Função que vai gerar o presente
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************	

create_present:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R8
	MOV R0, objeto_atual				; guarda o objeto atual
	MOV R1, presente					; mudamos o objeto atual
	MOV [R0], R1						; o objeto atual é agora o presente
	
	CMP R8, 0							; caso seja 0, o presente vai ficar na parte superior do pixelscreen
	JZ paint_present_up					; e vai pintar o presente
	JMP paint_present_down				; e vai pintar o presente

paint_present_up:						; pinta o presente na parte superior do pixelscreen
	MOV R2, upper_object				; guarda a string
	MOV R3, presente					; vamos mudar o objeto atual
	MOV [R2], R3						; o upper_object passa a ter o presente
	MOV R4, upper_x						; coordenada x acima do meio do pixelscreen
	MOVB R1, [R4]						; pomos a coordenada x correta
	MOV R4, upper_y						; coordenada y acima do meio do pixelscreen
	MOVB R2, [R4]						; pomos a coordenada y correta
	CALL paint_object					; pinta o presente na posição dada
	JMP create_present_end				; termina a rotina
	
paint_present_down:						; pinta o presente na parte inferior do pixelscreen
	MOV R2, lower_object				; guarda a string
	MOV R3, presente					; vamos mudar o objeto atual
	MOV [R2], R3						; o lower_object passa a ter o presente
	MOV R4, lower_x						; coordenada x abaixo do meio do pixelscreen
	MOVB R1, [R4]						; pomos a coordenada x correta
	MOV R4, lower_y						; coordenada y abaixo do meio
	MOVB R2, [R4]						; pomos a coordenada y correta
	CALL paint_object					; pinta o presente na posição dada
	JMP create_present_end				; termina a rotina
	
	
create_present_end:
	MOV R2, objeto_atual				; vamos voltar a tornar o objeto atual como ninja
	MOV R3, ninja						; recebe o ninja
	MOV [R2], R3						; mete o ninja como objeto atual de novo
	
	POP R8
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	
	
	
	
	
; **************************************************************************
; * Rotina: gravity
; * Descrição: Rotina que vai movendo os ninjas para baixo
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************
	
gravity:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R8

	MOV R8, MOVE_DOWN			; vai descer o objeto
	
	MOV R3, ninja_1_x			; coordenada x do primeiro ninja
	MOVB R1, [R3]				; leitura da coordenada x do primeiro ninja
	MOV R3, ninja_1_y			; coordenada y do primeiro ninja
	MOVB R2, [R3]				; leitura da coordenada y do primeiro ninja
	CALL move_object			; move o primeiro ninja
	MOVB [R3], R2				; atualiza a nova posição do ninja 1
	
	MOV R3, ninja_2_x			; coordenada x do segundo ninja
	MOVB R1, [R3]				; leitura da coordenada x do segundo ninja
	MOV R3, ninja_2_y			; coordenada y do segundo ninja
	MOVB R2, [R3]				; leitura da coordenada y do segundo ninja
	CALL move_object			; move o segundo ninja
	MOVB [R3], R2				; atualiza a nova posição do ninja 2
	
	MOV R3, ninja_3_x			; coordenada x do terceiro ninja
	MOVB R1, [R3]				; leitura da coordenada x do terceiro ninja
	MOV R3, ninja_3_y			; coordenada y do terceiro ninja
	MOVB R2, [R3]				; leitura da coordenada y do terceiro ninja
	CALL move_object			; move o terceiro ninja
	MOVB [R3], R2				; atualiza a nova posição do ninja 3
	
	MOV R3, ninja_4_x			; coordenada x do quarto ninja
	MOVB R1, [R3]				; leitura da coordenada x do quarto ninja
	MOV R3, ninja_4_y			; coordenada y do quarto ninja
	MOVB R2, [R3]				; leitura da coordenada y do quarto ninja
	CALL move_object			; move o quarto ninja
	MOVB [R3], R2
	
gravity_end:
	POP R8
	POP R3
	POP R2
	POP R1
	POP R0
	RET
	


; **************************************************************************
; * Rotina: move_guns
; * Descrição: Rotina que ativa as flags e move as armas para a esquerda
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************

move_guns:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	
	MOV R8, 0					; vai mover o objeto para a esquerda
	
	MOV R0, contador 			; vai buscar o contador
	MOVB R3, [R0]				; lê o valor do contador
	MOV R0, 7					; isolar, de forma a ter os 3 últimos bits
	AND R3, R0					; 	"
	
	MOV R5, upper_object		; vamos verificar se o objeto é não nulo (não existe)
	MOV R6, [R5]				; lê da etiqueta
	MOV R4, NULL_OBJECT			; não nulo
	CMP R6, R4					; se for nulo, vamos verificar se o podemos criar
	JNZ	move_object_up			; se for não nulo, o objeto existe, e vamos movê-lo
	
	MOV R4, SHURIKEN_UP			; ver se é para mover a estrela na parte superior do pixelscreen			
	CMP R4, R3					; se for, vai criar a estrela
	JNZ check_present_up		; se não for, vai ver se é para mover o presente na parte superior do pixelscreen
	CALL create_shuriken		; vai criar o shuriken
	JMP move_guns_end			; termina a rotina
	
check_present_up:
	MOV R4, PRESENT_UP			; ver se é para mover o presente na parte superior do pixelscreen
	CMP R4, R3					; se for, vai criar o presente
	JNZ check_lower_object		; se não for, vai ver se é para mover o objeto na parte inferior do pixelscreen
	CALL create_present			; vai criar o presente
	JMP move_guns_end			; termina a rotina
	
move_object_up:
	MOV R4, upper_x				; vai buscar a coordenada x
	MOVB R1, [R4]				; atualiza a coordenada x para a nova posição
	MOV R4, upper_y				; vai buscar a coordenada y
	MOVB R2,  [R4]				; atualiza a coordenada y para a nova posição
	MOV R4, objeto_atual		; vai buscar o objeto_atual
	MOV [R4], R6				; altera o objeto atual para o objeto escolhido
	MOV R8, MOVE_LEFT			; seleciono o modo de mover para a esquerda
	CALL move_object			; move o objeto para a esquerda
	MOV R4, upper_x				; atualiza a coordenada x para que na próxima iteração...
	MOVB [R4], R1				; ...comece a partir dessa mesma coordenada
	
	MOV R4, objeto_atual		; temos de voltar...
	MOV R6, ninja				; ...a tornar o objeto atual...
	MOV [R4], R6				; ...num ninja
	


check_lower_object:				; verifica se é para mover o objeto na parte inferior do pixelscreen
	MOV R8, 1					; vai mover o objeto para a esquerda
	
	MOV R5, lower_object		; vamos verificar se o objeto é não nulo (não existe)
	MOV R6, [R5]				; lê da etiqueta
	MOV R4, NULL_OBJECT			; não nulo
	CMP R6, R4					; se for nulo, vamos verificar se o podemos criar
	JNZ	move_object_down		; se for não nulo, o objeto existe, e vamos movê-lo
	
	MOV R4, SHURIKEN_DOWN		; ver se é para mover a estrela na parte inferior do pixelscreen			
	CMP R4, R3					; se for, vai criar a estrela
	JNZ check_present_down		; se não for, vai ver se é para mover o presente na parte inferior do pixelscreen
	CALL create_shuriken		; vai criar o shuriken
	JMP move_guns_end			; termina a rotina
	
check_present_down:
	MOV R4, PRESENT_DOWN		; ver se é para mover o presente na parte superior do pixelscreen
	CMP R4, R3					; se for, vai criar o presente
	JNZ move_guns_end			; se não for, termina a rotina
	CALL create_present			; vai criar o presente
	JMP move_guns_end
	
move_object_down:
	MOV R4, lower_x				; vai buscar a coordenada x
	MOVB R1, [R4]				; atualiza a coordenada x
	MOV R4, lower_y				; vai buscar a coordenada y
	MOVB R2,  [R4]				; atualiza a coordenada y
	MOV R4, objeto_atual		; vai buscar o objeto_atual
	MOV [R4], R6				; altera o objeto atual para o objeto escolhido
	MOV R8, MOVE_LEFT			; seleciono o modo de mover para a esquerda
	CALL move_object			; move o objeto para a esquerda
	MOV R4, lower_x				; atualiza a coordenada x para que na próxima iteração...
	MOVB [R4], R1				; ...comece a partir dessa mesma coordenada
	
	MOV R4, objeto_atual		; temos de voltar...
	MOV R6, ninja				; ...a tornar o objeto atual...
	MOV [R4], R6				; ...num ninja

move_guns_end:
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET


	
	
; **************************************************************************
; * Rotina: interruptions
; * Descrição: Rotina que ativa as flags
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************

interruptions:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	
	DI								; desabilita as interrupções
	MOV R0, flag_gravity			; guarda a flag
	MOVB R1, [R0]					; lê da etiqueta
	MOV R2, 0						; comparador para a flag
	MOVB [R0], R2					; mete a flag a 0
	CMP R1, R2						; vamos ver se a flag está a 0
	JZ	check_interruption_guns		; se não estiver a 0, verifica a flag das armas
	CALL gravity					; se estiver, vai chamar a função gravidade

check_interruption_guns:
	MOV R0, flag_guns				; guarda a flag
	MOVB R1, [R0]					; lê da etiqueta
	;MOV R2, 0						; comparador para a flag
	MOVB [R0], R2					; mete a flag a 0
	CMP R1, R2						; vamos ver se a flag está a 0
	JZ	interruptions_end			; caso não esteja a 0, termina 
	CALL move_guns
	
interruptions_end:
	EI								; abilita as interrupções
	POP R5
	POP R4
	POP R3
	POP R2
	POP R1
	POP R0
	RET	
	
	
	
; **************************************************************************
; * Rotina: interruption_gravity
; * Descrição: Rotina que ativa a flag da gravidade
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************

interruption_gravity:
	PUSH R0
	PUSH R1
	
	MOV R0, flag_gravity			; guarda a flag
	MOV R1, 1						; vamos ativar a flag da gravidade
	MOVB [R0], R1					; ativa a flag
	
	POP R1
	POP R0
	RFE								; RET das interrupções (repõem as informações das flags)
	

	

; **************************************************************************
; * Rotina: interruption_guns
; * Descrição: Rotina que ativa a flag das armas
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************

interruption_guns:
	PUSH R0
	PUSH R1
	
	MOV R0, flag_guns				; guarda a flag
	MOV R1, 1						; vamos ativar a flag das armas
	MOVB [R0], R1					; ativa a flag
	
	POP R1
	POP R0
	RFE								; RET das interrupções (repõem as informações das flags)
	

	
; **************************************************************************
; * Rotina: paint_screen_begining
; * Descrição: Pinta o pixelscreen dada as etiquetas de inicialização
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************	

paint_screen_begining:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R0, PIXELSCREEN				; chama o pixelscreen
	MOV R1, begining				; vai buscar a string de inicio
	
paint_loop:
	MOVB R2, [R1]					
	MOVB [R0], R2
	ADD R2, 1
	MOV [R0], R2
	ADD R0, 2H						; soma dois para passar para a próxima word
	MOV R3, CLEAN_PXS_LIMITE		; limite do pixelscreen
	CMP R3, R0						; vê se já acabou de pintar
	JNZ paint_loop					; caso não, continua a pintar
	
	POP R3
	POP R2
	POP R1
	POP R0
	RET	
	
	

	

; **************************************************************************
; * Rotina: comecar_jogo
; * Descrição: Altera o estado do jogo para começar o jogo
; *
; *	Parâmetros: R8
; *	Destroy: -
; * Devolve: -
; **************************************************************************

comecar_jogo:
	PUSH R0
	PUSH R1
	MOV R0, estado_jogo
	MOV R1, 1						; começamos o jogo, logo temos de atualizar a flag
	MOVB [R0], R1					; atualiza a flag para 1
	;CALL paint_screen_begining
	CALL clean_pixelscreen			; limpa o ecra
	
	CALL gerador					; vai pintar os ninjas
	POP R1
	POP R0
	RET
	




	

	
