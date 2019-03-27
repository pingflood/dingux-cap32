#
# Port for the RetroGame by pingflood; 2018-2019
#

CHAINPREFIX := /opt/mipsel-linux-uclibc
CROSS_COMPILE := $(CHAINPREFIX)/usr/bin/mipsel-linux-

CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
STRIP = $(CROSS_COMPILE)strip
AR = $(CROSS_COMPILE)ar
RANLIB = $(CROSS_COMPILE)ranlib

SYSROOT := $(shell $(CC) --print-sysroot)
SDL_CONFIG = $(SYSROOT)/usr/bin/sdl-config

CAP32_VERSION = 1.1.2

TARGET = dingux-cap32/dingux-cap32.dge

OBJS = 	./src/gp2x_psp.o \
		./src/cap32.o \
		./src/crtc.o \
		./src/fdc.o \
		./src/psg.o \
		./src/video.o \
		./src/z80.o \
		./src/psp_main.o \
		./src/psp_sdl.o \
		./src/psp_kbd.o \
		./src/psp_joy.o \
		./src/kbd.o \
		./src/psp_font.o \
		./src/psp_menu.o \
		./src/psp_run.o \
		./src/psp_menu_disk.o \
		./src/psp_danzeff.o \
		./src/psp_menu_set.o \
		./src/psp_menu_help.o \
		./src/psp_menu_joy.o \
		./src/psp_menu_kbd.o \
		./src/psp_menu_cheat.o \
		./src/psp_menu_list.o \
		./src/psp_editor.o \
		./src/miniunz.o \
		./src/unzip.o \
		./src/psp_fmgr.o \
		./src/libcpccat/fs.o # new

DEFAULT_CFLAGS = $(shell $(SDL_CONFIG) --cflags)

MORE_CFLAGS = -DLSB_FIRST
MORE_CFLAGS += -I. -I$(SYSROOT)/usr/include  -I$(SYSROOT)/usr/lib  -I$(SYSROOT)/lib
MORE_CFLAGS += -DMPU_JZ4740 -mips32 -O3 -fomit-frame-pointer -fsigned-char -ffast-math
MORE_CFLAGS += -DGCW0_MODE
MORE_CFLAGS += -DCAP32_VERSION=\"$(CAP32_VERSION)\"
# MORE_CFLAGS += -DNO_STDIO_REDIRECT
MORE_CFLAGS += -DDOUBLEBUF
# MORE_CFLAGS += -DTRIPLEBUF

# -fsigned-char -ffast-math -fomit-frame-pointer \
# -fexpensive-optimizations -fno-strength-reduce  \

#  -ffast-math -fomit-frame-pointer -fno-strength-reduce -fexpensive-optimizations \
# -msoft-float -O3  -G 0

CFLAGS = $(DEFAULT_CFLAGS) $(MORE_CFLAGS)
LDFLAGS = -s

LIBS += -B$(SYSROOT)/lib
LIBS += -lSDL
LIBS += -lSDL_image
LIBS += ./src/libcpccat/libcpccat.a 
LIBS += -lpng -lz -lm -lpthread  -ldl

#libcpccat/libcpccat.a  \ # old


.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

all : $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJS) $(LIBS) -o $(TARGET) && $(STRIP) $(TARGET)

./src/libcpccat/libcpccat.a: ./src/libcpccat/fs.o
	$(AR) cru $@ $?
	$(RANLIB) $@

ipk: $(TARGET)
	@rm -rf /tmp/.dingux-cap32-ipk/bios && mkdir -p /tmp/.dingux-cap32-ipk/root/home/retrofw/emus/dingux-cap32 /tmp/.dingux-cap32-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators /tmp/.dingux-cap32-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators.systems
	@cp -r dingux-cap32/dingux-cap32.dge dingux-cap32/dingux-cap32.man.txt dingux-cap32/dingux-cap32.png dingux-cap32/splash.png dingux-cap32/thumb.png dingux-cap32/background.png dingux-cap32/graphics dingux-cap32/bios /tmp/.dingux-cap32-ipk/root/home/retrofw/emus/dingux-cap32
	@cp dingux-cap32/dingux-cap32.lnk /tmp/.dingux-cap32-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators
	@cp dingux-cap32/amstrad.dingux-cap32.lnk /tmp/.dingux-cap32-ipk/root/home/retrofw/apps/gmenu2x/sections/emulators.systems
	@sed "s/^Version:.*/Version: $$(date +%Y%m%d)/" dingux-cap32/control > /tmp/.dingux-cap32-ipk/control
	@cp dingux-cap32/conffiles /tmp/.dingux-cap32-ipk/
	@tar --owner=0 --group=0 -czvf /tmp/.dingux-cap32-ipk/control.tar.gz -C /tmp/.dingux-cap32-ipk/ control conffiles
	@tar --owner=0 --group=0 -czvf /tmp/.dingux-cap32-ipk/data.tar.gz -C /tmp/.dingux-cap32-ipk/root/ .
	@echo 2.0 > /tmp/.dingux-cap32-ipk/debian-binary
	@ar r dingux-cap32/dingux-cap32.ipk /tmp/.dingux-cap32-ipk/control.tar.gz /tmp/.dingux-cap32-ipk/data.tar.gz /tmp/.dingux-cap32-ipk/debian-binary

clean:
	rm -f $(OBJS) $(TARGET)

ctags:
	ctags *[ch]

# install: $(TARGET)
# 	cp $< /media/dingux/local/emulators/dingux-cap32/

