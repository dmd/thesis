// phaseshift.cpp
// shifts phases for retinotopy
// by Daniel M. Drucker

// from the original IDL:
// a=Readfile()
// b=where(a ne 0)
// PhaseFix=0
// a(b)= ((a(b)+360*(a(b) lt 0))) -180
//  a(b)=a(b)+PhaseFix
//  a(b)= (a(b)-360*(a(b) gt 180))
// writefile,a

using namespace std;

#include <stdio.h>
#include <string.h>
#include "vbutil.h"
#include "vbio.h"

void phaseshift_help();
void shiftcube(Cube &cub,double PhaseFixValue);

int
main(int argc,char *argv[])
{
  tokenlist args;
  Cube *cub;
  double PhaseFixValue;


  args.Transfer(argc-1,argv+1);

  if (args.size() != 3) {
    phaseshift_help();
    exit(0);
  }

  PhaseFixValue = strtod(args[2]);
  cub = new Cube;
  if (cub->ReadFile(args[0])) {
    printf("phaseshift: couldn't read cub file %s\n",args[0].c_str());
    exit(109);
  }
  if (!cub->data_valid) {
    printf("phaseshift: couldn't validate cub file %s\n",args[0].c_str());
    exit(100);
  }

  shiftcube(*cub,PhaseFixValue);
  cub->SetFileName(args[1]);
  if (cub->WriteFile()) {
    printf("[E] phaseshift: error writing file %s\n",args[1].c_str());
    exit(110);
  }
  else
    printf("[I] phaseshift: done.\n");
  exit(0);
}

void
shiftcube(Cube &cub,double PhaseFixValue)
{
	double v;
	for (int i=0; i<cub.dimx; i++) {	
		for (int j=0; j<cub.dimy; j++) {
			for (int k=0; k<cub.dimz; k++) {
				v = cub.GetValue(i,j,k);
				if (v) {
					v = ((v+360*(v<0)))-180;
					v = v + PhaseFixValue;
					v = (v-360*(v>180));
					cub.SetValue(i,j,k,v);
				}
			}
		}
	}
}




void
phaseshift_help()
{
  printf("\nVoxBo phaseshift (v%s)\n",vbversion.c_str());
  printf("summary: phaseshift a retinotopy cub\n");
  printf("usage:\n");
  printf("  phaseshift <incubename> <outcubename> PhaseFixValue\n");
  printf("\n");
}
