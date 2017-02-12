/*
 * Device Tree binding constants for Silicon Labs Si5351 clock generator
 *
 * Author: Sergej Sawazki <ce3a@gmx.de>
 */

#ifndef __DT_BINDINGS_CLOCK_SI5351_H
#define __DT_BINDINGS_CLOCK_SI5351_H

/* PLLs */
#define SI5351_PLL_A                  0
#define SI5351_PLL_B                  1

/* PLL source */
#define SI5351_PLL_SRC_XTAL           0
#define SI5351_PLL_SRC_CLKIN          1

/* Multisynth divider source */
#define SI5351_MULTISYNTH_SRC_VCOA    0
#define SI5351_MULTISYNTH_SRC_VCOB    1

/* Output divider source */
#define SI5351_CLKOUT_SRC_MSYNTH_N    0
#define SI5351_CLKOUT_SRC_MSYNTH_0_4  1
#define SI5351_CLKOUT_SRC_XTAL        2
#define SI5351_CLKOUT_SRC_CLKIN       3

/* Output drive strength */
#define SI5351_DRIVE_2MA              2
#define SI5351_DRIVE_4MA              4
#define SI5351_DRIVE_6MA              6
#define SI5351_DRIVE_8MA              8

/* Output disable state */
#define SI5351_DISABLE_LOW            0
#define SI5351_DISABLE_HIGH           1
#define SI5351_DISABLE_FLOATING       2
#define SI5351_DISABLE_NEVER          3

#endif /* __DT_BINDINGS_CLOCK_SI5351_H */
