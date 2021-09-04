ORG 0x7c00                          ;location where this should be placed in disk
BITS 16                             ;using 16 bits archtecture

start:
    mov si, message                 ;si register will point to the first byte of 'message' identifier
    call print                      ;call print
    jmp $                           ;infitine loop


print:
    mov bx, 0                       ;Page number (note BL = foreground colour, BH = page number)
.loop:
    lodsb                           ;loads what 'si' register is pointing to and then loads it into 'al' register
    cmp al,0                        ;is 'al' = 0? (end of string)
    je .done                        ;if the previous condition is true, we are done printing, jump to label 'done'
    call print_char                 ;the previous condition was not met, therefore we are not done printing, call 'print_char'
    jmp .loop                       ;jump to 'loop' label
.done:
    ret                             ;return


print_char:
    mov ah, 0eh                     ;Setting BIOS interrupt - setting teletype output
    int 0x10                        ;Calling BIOS interrupt
    ret                             ;return

message: db 'Hello World!', 0       ;zero ending

times 510-($ - $$) db 0             ;padding the first 510 bytes with zeros - it fits this the first bytes of the program 
                                    ; until this point and then fills it zeroes ensuring the next line will be true
dw 0xAA55                           ;dw = Assembly word - this last two bytes (511 and 512) need to be '55AA' to indicate this 
                                    ;   is a bootable media but since x86 uses little endian notation we need to write 'AA55'

                                    ;Assembly instructions:
                                    ;   On Linux: nasm -f bin ./boot.asm -o ./boot.bin
                                    ;   Check assembly (if you want to): ndisasm ./boot.bin
                                    ;Execute:
                                    ;   qemu-system-x86_64 -hda ./boot.bin
