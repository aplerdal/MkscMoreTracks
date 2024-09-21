SECTIONS
{
    . = 0x08400000;        /* Set the start address */
    .text : { *(.text) }    /* Place all .text section code here */
    .data : { *(.data) }    /* Place all .data section code here */
    .bss : { *(.bss) }      /* Place all .bss section code here */
}
