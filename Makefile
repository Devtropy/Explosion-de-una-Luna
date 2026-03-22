##
## Makefile
##  
## Made by Dupret Alberto Santana Bejarano
## Login   <dupretRhapsody>
##
## Started on  Tue Mar  6 01:01:51 2018 Dupret Alberto Santana Bejarano
## Last update Time-stamp: <25-abr-2025 15:45:05 hiah>
##
#
# This makefile is intended for the program 
#
#      MassFuntion
#===============================================
# Fortran Parameters
#===============================================
FC = gfortran #Compiler
FFLAGS = -O3  #Optimization Flags (maybe tinker with these?)
FSRC = module.f90 main.f90
FOBJECTS = $(FSRC:.f90=.o) #Objets

#===============================================
# C Parameters
#===============================================
CC = gcc #Compiler
CFLAGS = -O   #-ffixed-line-length-132 #Optimization Flags (maybe tinker with these?)
CSRC = 
COBJECTS = $(CSRC:.c=.u) # C Objets 
CHEAD = 

#===============================================
# General Parameters.  
#===============================================
OBJECTS =	$(FOBJECTS) $(COBJECTS)
EXEC = EXPLOSION

#===============================================
# Compilation rules
#===============================================
default: $(EXEC)

clean:	
	rm -f *~ $(OBJECTS)

spotless:	
	rm -f *~ $(OBJECTS) $(EXEC)

$(EXEC): $(OBJECTS)
	$(FC) $(FFLAGS) $(FLFLAGS) -o $(EXEC) \
		 $(OBJECTS) -lm

%.o:  %.f90
	$(FC) $(FFLAGS) -c $< -o $@

%.u:	%.c $(CHEAD)	
	$(CC) $(CFLAGS) -c $< -o $@ 
