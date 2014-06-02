#
# Caprice32 port on GP2X
#
# Copyright (C) 2006 Ludovic Jacomme (ludovic.jacomme@gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
CAP32_VERSION	=1.1.2

TARGET			= dingux-cap32
ZERODEV_PATH	= /opt/gcw0-toolchain/usr/mipsel-gcw0-linux-uclibc/sysroot/usr
BINARIES_PATH	= /opt/gcw0-toolchain/usr/bin
SDL_CONFIG		= $(ZERODEV_PATH)/bin/sdl-config

OBJS = 	gp2x_psp.o \
		cap32.o \
		crtc.o \
		fdc.o \
		psg.o \
		video.o \
		z80.o \
		psp_main.o \
		psp_sdl.o \
		psp_kbd.o \
		psp_joy.o \
		kbd.o \
		psp_font.o \
		psp_menu.o \
		psp_run.o \
		psp_menu_disk.o \
		psp_danzeff.o \
		psp_menu_set.o \
		psp_menu_help.o \
		psp_menu_joy.o \
		psp_menu_kbd.o \
		psp_menu_cheat.o \
		psp_menu_list.o \
		psp_editor.o \
		miniunz.o \
		unzip.o \
		psp_fmgr.o
#libcpccat/fs.o # new


CC		= $(BINARIES_PATH)/mipsel-linux-gcc
STRIP	= $(BINARIES_PATH)/mipsel-linux-strip

DEFAULT_CFLAGS = $(shell $(SDL_CONFIG) --cflags)

MORE_CFLAGS = -I. -I$(ZERODEV_PATH)/usr/include -DLSB_FIRST \
-I. -I$(ZERODEV_PATH)/usr/include \
 -DMPU_JZ4740 -mips32 -O3 -fomit-frame-pointer -fsigned-char -ffast-math \
 -DGCW0_MODE  \
 -DCAP32_VERSION=\"$(CAP32_VERSION)\" \
-DNO_STDIO_REDIRECT \
-DDOUBLEBUF
#-DTRIPLEBUF

# -fsigned-char -ffast-math -fomit-frame-pointer \
# -fexpensive-optimizations -fno-strength-reduce  \

#  -ffast-math -fomit-frame-pointer -fno-strength-reduce -fexpensive-optimizations \
# -msoft-float -O3  -G 0

CFLAGS = $(DEFAULT_CFLAGS) $(MORE_CFLAGS)
LDFLAGS = -s

LIBS += -L$(ZERODEV_PATH)/lib \
-lSDL \
-lSDL_image \
libcpccat/libcpccat.a  \
-lpng -lz -lm -lpthread  -ldl

#libcpccat/libcpccat.a  \ # old

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

all: $(OBJS)
	$(CC) $(LDFLAGS) $(CFLAGS) $(OBJS) $(LIBS) -o $(TARGET) && $(STRIP) $(TARGET)

install: $(TARGET)
	cp $< /media/dingux/local/emulators/dingux-cap32/

clean:
	rm -f $(OBJS) $(TARGET)

ctags:
	ctags *[ch]
