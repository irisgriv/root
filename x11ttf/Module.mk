# Module.mk for x11ttf module
# Copyright (c) 2000 Rene Brun and Fons Rademakers
#
# Author: Fons Rademakers, 29/2/2000

MODDIR       := x11ttf
MODDIRS      := $(MODDIR)/src
MODDIRI      := $(MODDIR)/inc

X11TTFDIR    := $(MODDIR)
X11TTFDIRS   := $(X11TTFDIR)/src
X11TTFDIRI   := $(X11TTFDIR)/inc

##### libGX11TTF #####
X11TTFL      := $(MODDIRI)/LinkDef.h
X11TTFDS     := $(MODDIRS)/G__X11TTF.cxx
X11TTFDO     := $(X11TTFDS:.cxx=.o)
X11TTFDH     := $(X11TTFDS:.cxx=.h)

X11TTFH      := $(filter-out $(MODDIRI)/LinkDef%,$(wildcard $(MODDIRI)/*.h))
X11TTFS      := $(filter-out $(MODDIRS)/G__%,$(wildcard $(MODDIRS)/*.cxx))
X11TTFO      := $(X11TTFS:.cxx=.o)

X11TTFDEP    := $(X11TTFO:.o=.d) $(X11TTFDO:.o=.d)

X11TTFLIB    := $(LPATH)/libGX11TTF.$(SOEXT)

# used in the main Makefile
ALLHDRS     += $(patsubst $(MODDIRI)/%.h,include/%.h,$(X11TTFH))
ALLLIBS     += $(X11TTFLIB)

# include all dependency files
INCLUDEFILES += $(X11TTFDEP)

##### local rules #####
include/%.h:    $(X11TTFDIRI)/%.h
		cp $< $@

$(X11TTFLIB):   $(X11TTFO) $(X11TTFDO) $(FREETYPELIB) $(MAINLIBS) $(X11TTFLIBDEP)
		@$(MAKELIB) $(PLATFORM) $(LD) "$(LDFLAGS)" \
		   "$(SOFLAGS)" libGX11TTF.$(SOEXT) $@ \
		   "$(X11TTFO) $(X11TTFDO)" "$(FREETYPELIB) $(X11TTFLIBEXTRA)"

$(X11TTFDS):    $(X11TTFH) $(X11TTFL) $(ROOTCINTTMP)
		@echo "Generating dictionary $@..."
		$(ROOTCINTTMP) -f $@ -c -p $(X11TTFH) $(X11TTFL)

$(X11TTFDO):    $(X11TTFDS) $(FREETYPELIB)
		$(CXX) $(NOOPT) -I$(FREETYPEDIRI) $(CXXFLAGS) -I. -o $@ -c $<

all-x11ttf:     $(X11TTFLIB)

clean-x11ttf:
		@rm -f $(X11TTFO) $(X11TTFDO)

clean::         clean-x11ttf

distclean-x11ttf: clean-x11ttf
		@rm -f $(X11TTFDEP) $(X11TTFDS) $(X11TTFDH) $(X11TTFLIB)

distclean::     distclean-x11ttf

##### extra rules ######
$(X11TTFO): %.o: %.cxx $(FREETYPELIB)
	$(CXX) $(OPT) -I$(FREETYPEDIRI) $(CXXFLAGS) -o $@ -c $<
