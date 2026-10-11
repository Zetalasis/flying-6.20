### flying V6.20 - Makefile for modern Linux (g++ / clang++, X11)
###
### Requirements: a C++ compiler and the X11/Xext development headers
### (Debian/Ubuntu: libx11-dev libxext-dev, Fedora: libX11-devel libXext-devel).
###
### Overridable from the command line, e.g.
###   make X_INCLUDE=/opt/x11/include LIBS="-l:libX11.so.6 -lm"

### directory for writing temporary data and pixmap files
DATA_DIRECTORY = '"/tmp"'

### compiler section
### for debugging, there might be the additional flags -DDEBUG and -DSTATISTICS
CXX      ?= g++
CXXFLAGS ?= -O2 -Wall -Wno-unused -Wno-misleading-indentation -Wno-parentheses

### parameter type of select-parameters (empty on Linux)
FDS_TYPE = ''

### X11 include/lib directories. Use pkg-config when available, otherwise
### fall back to the standard system locations.
PKG_CONFIG ?= pkg-config
X_CFLAGS   := $(shell $(PKG_CONFIG) --cflags x11 xext 2>/dev/null)
X_LIBS     := $(shell $(PKG_CONFIG) --libs x11 xext 2>/dev/null)
ifeq ($(X_LIBS),)
X_LIBS := -lX11 -lXext
endif
ifdef X_INCLUDE
X_CFLAGS += -I$(X_INCLUDE)
endif
ifdef XLIB_DIR
LDFLAGS  += -L$(XLIB_DIR)
endif

###################################################################

CPPFLAGS += $(X_CFLAGS) -DDATA_DIRECTORY=$(DATA_DIRECTORY) -DFDS_TYPE=$(FDS_TYPE)
LIBS     ?= $(X_LIBS) -lm

.SUFFIXES: .C .o

.C.o:
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

OBJS	= arcs.o \
		ball.o \
		billard.o \
		cannon.o \
		carrom.o \
		curling.o \
		dynobj.o \
		game.o \
		global.o \
		goal.o \
		graph.o \
		hockey.o \
		keeper.o \
		logfile.o \
		main.o \
		mover.o \
		object.o \
		objtab.o \
		pball.o \
		pcon.o \
		pocket.o \
		pool.o \
		pool8.o \
		real.o \
		rgb.o \
		snooker.o \
		vec2.o \
		vec3.o \
		vector.o \
		wall.o \
		xbench.o \
		xsound.o

PROGRAM       = flying
LINKS         = xpool xsnooker xcarrom xhockey xcurling xcannon

all:		$(PROGRAM) $(LINKS)

$(PROGRAM): $(OBJS)
		$(CXX) $(LDFLAGS) $(OBJS) $(LIBS) -o $(PROGRAM)

$(LINKS): $(PROGRAM)
		ln -sf $(PROGRAM) $@

clean:
		-rm -f core *.o $(PROGRAM)
		-rm -f fly.dta/*.*

.PHONY: all clean

### dependencies ###


arcs.o: global.h   \
	  arcs.h object.h real.h \
	vec2.h vector.h ball.h dynobj.h objtab.h game.h keeper.h
ball.o: global.h   \
	  ball.h arcs.h object.h \
	real.h vec2.h vector.h dynobj.h objtab.h game.h keeper.h mover.h \
	graph.h xgraph.h  \
	xsound.h    \
	xmover.h  pball.h xpball.h 
billard.o: global.h   \
	 billard.h real.h game.h vec2.h \
	 vector.h keeper.h wall.h object.h graph.h \
	xgraph.h   \
	 xsound.h  \
	  mover.h xmover.h
cannon.o: global.h   \
	 cannon.h real.h billard.h game.h vec2.h \
	 vector.h keeper.h ball.h arcs.h object.h dynobj.h \
	objtab.h wall.h graph.h xgraph.h  \
	xsound.h    \
	mover.h xmover.h 
carrom.o: global.h   \
	 carrom.h real.h vec2.h  \
	vector.h game.h keeper.h wall.h object.h graph.h xgraph.h \
	 xsound.h  \
	  mover.h xmover.h \
	 arcs.h pocket.h ball.h dynobj.h objtab.h
curling.o: global.h   \
	 curling.h vec2.h  real.h \
	vector.h game.h keeper.h arcs.h object.h ball.h dynobj.h objtab.h \
	goal.h wall.h graph.h xgraph.h  \
	xsound.h    \
	mover.h xmover.h 
dynobj.o: global.h   \
	 dynobj.h real.h objtab.h object.h ball.h arcs.h \
	vec2.h  vector.h
game.o: global.h   \
	 game.h vec2.h  real.h \
	vector.h keeper.h wall.h object.h ball.h arcs.h dynobj.h objtab.h \
	graph.h xgraph.h  \
	xsound.h   
global.o: global.h   \
	  real.h cannon.h billard.h \
	game.h vec2.h  vector.h keeper.h carrom.h goal.h \
	wall.h object.h hockey.h curling.h pball.h xpball.h  pool.h \
	pool8.h snooker.h pocket.h ball.h arcs.h dynobj.h objtab.h
goal.o: global.h   \
	 goal.h wall.h object.h real.h vec2.h \
	 vector.h ball.h arcs.h dynobj.h objtab.h game.h \
	keeper.h
graph.o: global.h   \
	 object.h real.h graph.h vec2.h \
	 vector.h xgraph.h  \
	xsound.h    \
	pball.h xpball.h  xgraph.C pointer.h stipple.h game.h \
	keeper.h \
	rgb.h
hockey.o: global.h   \
	 hockey.h vec2.h  real.h \
	vector.h game.h keeper.h arcs.h object.h ball.h dynobj.h objtab.h \
	goal.h wall.h graph.h xgraph.h  \
	xsound.h    \
	mover.h xmover.h 
keeper.o: global.h   \
	 ball.h arcs.h object.h real.h vec2.h \
	 vector.h dynobj.h objtab.h wall.h keeper.h game.h \
	graph.h xgraph.h  \
	xsound.h   
logfile.o:   \
	  global.h \
	logfile.h
main.o: global.h   \
	  dynobj.h real.h objtab.h \
	object.h graph.h vec2.h vector.h xgraph.h \
	 xsound.h  \
	  mover.h xmover.h \
	 game.h keeper.h snooker.h pool.h billard.h cannon.h \
	pool8.h carrom.h hockey.h curling.h pball.h xpball.h 
mover.o: global.h   \
	 mover.h real.h graph.h object.h vec2.h \
	 vector.h xgraph.h  \
	xsound.h    \
	xmover.h  xmover.C vec3.h
object.o: global.h   \
	 object.h real.h ball.h arcs.h vec2.h \
	 vector.h dynobj.h objtab.h graph.h xgraph.h \
	 xsound.h
objtab.o: global.h   \
	 objtab.h real.h object.h
pball.o: global.h   \
	 pball.h vec2.h  real.h \
	vector.h xpball.h  ball.h arcs.h object.h dynobj.h objtab.h \
	graph.h xgraph.h  \
	xsound.h    \
	game.h keeper.h xpball.C cursor.h
pcon.o: global.h   \
	 pcon.h real.h pocket.h ball.h arcs.h object.h \
	vec2.h  vector.h dynobj.h objtab.h keeper.h wall.h \
	graph.h xgraph.h  \
	xsound.h   
pocket.o: global.h   \
	 pocket.h ball.h arcs.h object.h real.h vec2.h \
	 vector.h dynobj.h objtab.h keeper.h game.h
pool.o: global.h   \
	 pool.h real.h billard.h game.h vec2.h \
	 vector.h keeper.h pcon.h pocket.h ball.h arcs.h \
	object.h dynobj.h objtab.h wall.h graph.h xgraph.h \
	 xsound.h  \
	  mover.h xmover.h
pool8.o: global.h   \
	 pool8.h pool.h real.h billard.h game.h vec2.h \
	 vector.h keeper.h graph.h object.h xgraph.h \
	 xsound.h  \
	  mover.h xmover.h \
	 ball.h arcs.h dynobj.h objtab.h wall.h
real.o: global.h   \
	 real.h 
rgb.o: rgb.h 
snooker.o: global.h   \
	 snooker.h vec2.h  real.h \
	vector.h pool.h billard.h game.h keeper.h pocket.h ball.h arcs.h \
	object.h dynobj.h objtab.h graph.h xgraph.h \
	 xsound.h  \
	  mover.h xmover.h
vec2.o: global.h   \
	 vec2.h  real.h vector.h
vec3.o: global.h   \
	 vec3.h  real.h vector.h
vector.o: global.h   \
	 vector.h  real.h \
	  vec2.h vec3.h
wall.o: global.h   \
	 wall.h object.h real.h vec2.h \
	 vector.h ball.h arcs.h dynobj.h objtab.h game.h \
	keeper.h
