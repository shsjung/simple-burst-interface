#include "Vsbi_mem_top.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#define CLOCK_POS \
    top->bCLK = !top->bCLK; \
    top->eval()
#define CLOCK_NEG \
    top->eval(); \
    tfp->dump(local_time++); \
    top->bCLK = !top->bCLK; \
    top->eval(); \
    tfp->dump(local_time++)
#define CLOCK_DELAY(x) \
    for (int xx=0; xx < x; xx++) { \
        top->bCLK = !top->bCLK; \
        CLOCK_NEG; \
    }

int main(int argc, char **argv) {
    int i, local_time = 0;

    Verilated::commandArgs(argc, argv);
    Vsbi_mem_top* top = new Vsbi_mem_top;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("sbi_mem_top.vcd");

    CLOCK_POS;
    top->bRSTn = 0;
    top->bADDR = 0;
    top->bSTART = 0;
    top->bACCESS = 0;
    top->bWRITE = 0;
    top->bD = 0;
    CLOCK_NEG;

    CLOCK_DELAY(5);

    CLOCK_POS;
    top->bRSTn = 1;
    CLOCK_NEG;

    CLOCK_DELAY(10);
    printf("Test case 1 start\n");
    int bADDR[13] = {0x10, 0x10, 0};
    int bSTART[13] = {1, 1, 0};
    int bACCESS[13] = {0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0};
    int bWRITE[13] = {0, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0};
    int bD[13] = {0, 0, 0x03020100, 0, 0x07060504, 0, 0, 0, 0x0b0a0908, 0x0f0e0d0c, 0};

    for (i=0; i<13; i++) {
        CLOCK_POS;
        top->bADDR = bADDR[i];
        top->bSTART = bSTART[i];
        top->bACCESS = bACCESS[i];
        top->bWRITE = bWRITE[i];
        top->bD = bD[i];
        CLOCK_NEG;
    }

    CLOCK_DELAY(10);
    printf("Test case 2 start\n");

    CLOCK_POS;
    top->bADDR = 0x40;
    top->bSTART = 1;
    top->bWRITE = 0;
    CLOCK_NEG;

    CLOCK_POS;
    top->bSTART = 0;
    CLOCK_NEG;

    CLOCK_POS;
    top->bADDR = 0x40;
    top->bSTART = 1;
    top->bWRITE = 1;
    CLOCK_NEG;

    CLOCK_POS;
    top->bSTART = 0;
    top->bWRITE = 0;
    CLOCK_NEG;

    for (i=0; i<16; i++) {
        CLOCK_POS;
        top->bWRITE = 1;
        top->bACCESS = 1;
        top->bD = (i << 16) | (i+1);
        CLOCK_NEG;
    }

    CLOCK_POS;
    top->bACCESS = 0;
    CLOCK_NEG;

    for (i=0; i<16; i++) {
        CLOCK_POS;
        top->bWRITE = 0;
        top->bACCESS = 1;
        CLOCK_NEG;
    }

    CLOCK_POS;
    top->bACCESS = 0;
    CLOCK_NEG;

    CLOCK_DELAY(10);
    printf("Test finished\n");

    tfp->close();
    delete top;
    delete tfp;
    return 0;

}
