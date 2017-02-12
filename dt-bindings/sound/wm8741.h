/*
 * Device Tree binding constants for Wolfson Microelectronics WM8741 codec
 *
 * Author: Sergej Sawazki <ce3a@gmx.de>
 */

#ifndef __DT_BINDINGS_SOUND_WM8741_H
#define __DT_BINDINGS_SOUND_WM8741_H

/* Differential output mode */
#define WM8741_DIFF_MODE_STEREO          0  /* stereo normal */
#define WM8741_DIFF_MODE_STEREO_REVERSED 2  /* stereo reversed */
#define WM8741_DIFF_MODE_MONO_LEFT       1  /* mono left */
#define WM8741_DIFF_MODE_MONO_RIGHT      3  /* mono right */

#endif /* __DT_BINDINGS_SOUND_WM8741_H */
