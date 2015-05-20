.data

.text
.globl _main
_main:
    call is_support_cpuid
    cmpq $0x01, %rax
    jnz done

    call get_basic_max_number
    int3
    xorq %rax, %rax

    call get_extend_max_number
    int3
    xorq %rax, %rax
done:
    ret

.globl get_extend_max_number
get_extend_max_number:
    push %rbp
    movq %rsp, %rbp

    movq $0x80000000, %rax
    cpuid

    movq %rbp, %rsp
    popq %rbp
    ret

/* 
    get cpuid basic number
    return value is rax
*/
.globl get_basic_max_number
get_basic_max_number:
    pushq %rbp
    movq %rsp, %rbp

    movq $0, %rax
    cpuid

    movq %rbp, %rsp
    popq %rbp
    ret

.globl is_support_cpuid
is_support_cpuid:
    pushq %rbp
    movq %rsp, %rbp

    pushfq
    movq (%rsp), %rax
    movq (%rsp), %rbx
    xorq $0x200000, %rbx
    movq %rbx,(%rsp)
    popfq

    pushfq
    pop %rbx
    cmpq %rbx, %rax
    setnz %al
    movzx %al, %rax

    movq %rbp, %rsp
    popq %rbp
    ret

