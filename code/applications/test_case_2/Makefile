.phony: generate-asm generate-initial-cap-tee add-checkap

CC=riscv64-unknown-elf-gcc

ASM_FLAGS= 

C_FLAGS=-mcmodel=medany -ffunction-sections

C_INCLUDES=-I$($OS_COMPARTMENTS_COURSE_PROJECT)/install_dir/freestanding-riscv/include -I. 

OBJS=hello_world.o

SRCS=hello_world.c

ASMS=hello_world.s

CAPS=hello_world.cap

# LINKER_PATH = $(OS_COMPARTMENTS_COURSE_PROJECT)/auto-linker-generator/strategy_$(COMPARTMENT_STRATEGY_CHOICE)

# $(OBJS):%.o: %.s
# 	$(CC) $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o $@ -c $<

# $(ASMS):%.s: %.c
# 	$(CC) $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o $@ -c $<

ls.dump: kernel
	riscv64-unknown-elf-objdump -D kernel > ls.dump

add-checkcap: $(ASMS)
	for f in $^; do postProcessing.py ./$$f; done

generate-asm: $(SRCS)
	$(CC) $(C_FLAGS) $(C_DEFINES) $(C_INCLUDES) $(SRCS) -S

generate-initial-cap-tee: generate-asm $(ASMS)
	initial_cap_file_generator c 254 $(ASMS)
# 	python postProcessing.py passParams.s passParams_out.s

kernel:: generate-asm add-checkcap $(OBJS)
	riscv64-unknown-elf-gcc  -mcmodel=medany $(ASMS) startup.S scall.s -o kernel

clean:
	rm -f *.o
	rm -f *.s
