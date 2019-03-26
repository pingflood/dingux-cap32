CC=/opt/mipsel-linux-uclibc/usr/bin/mipsel-linux-gcc
AR=/opt/mipsel-linux-uclibc/usr/bin/mipsel-linux-ar
RANLIB=/opt/mipsel-linux-uclibc/usr/bin/mipsel-linux-ranlib

CFLAGS=-O2 -Wall -DDINGUX_MODE

OBJS=fs.o
TARGET=libcpccat.a

all: $(TARGET)

$(TARGET): $(OBJS)
	$(AR) cru $@ $?
	$(RANLIB) $@

clean:
	-@rm -f $(OBJS) $(TARGET)


.c.o :
	$(CC) $(CFLAGS) -c -o $@ $<



