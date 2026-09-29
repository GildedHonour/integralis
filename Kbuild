obj-m := integralis.o

integralis-y := src/main.o src/meta.o

quiet_cmd_zig = ZIG     $@
      cmd_zig = zig build-obj \
	-target x86_64-linux \
	-O ReleaseSmall \
	-mcmodel=kernel \
	-fno-stack-check \
	-fno-stack-protector \
	-fno-unwind-tables \
	src/main.zig \
	-femit-bin=$@

$(obj)/src/main.o: $(src)/src/main.zig FORCE
	$(call if_changed,zig)

FORCE:
