//
//  ff_ffutils.c
//  IJKMediaPlayer
//
//  Created by jinchu darwin on 16/5/21.
//  Copyright © 2016年 bilibili. All rights reserved.
//
#include "config.h"

#include <stdarg.h>
#include <stdint.h>

#include "ff_ffplay.h"

/**
 * @file
 * simple media player based on the FFmpeg libraries
 */

#include "ff_ffutils.h"
#include "config.h"
#include <inttypes.h>
#include <math.h>
#include <limits.h>
#include <signal.h>
#include <stdint.h>

#include "libavutil/avstring.h"
#include "libavutil/eval.h"
#include "libavutil/mathematics.h"
#include "libavutil/pixdesc.h"
#include "libavutil/imgutils.h"
#include "libavutil/dict.h"
#include "libavutil/parseutils.h"
#include "libavutil/samplefmt.h"
#include "libavutil/avassert.h"
#include "libavutil/time.h"

#if CONFIG_AVDEVICE
#include "libavdevice/avdevice.h"
#endif
#include "libswscale/swscale.h"
#include "libavutil/opt.h"
#include "libavcodec/avfft.h"
#include "libswresample/swresample.h"

#if CONFIG_AVFILTER
# include "libavfilter/avcodec.h"
# include "libavfilter/avfilter.h"
# include "libavfilter/buffersink.h"
# include "libavfilter/buffersrc.h"
#endif


#include "ijksdl/ijksdl_log.h"
#include "ijkavformat/ijkavformat.h"
#include "ff_cmdutils.h"
#include "ff_fferror.h"
#include "ff_ffpipeline.h"
#include "ff_ffpipenode.h"
#include "ff_ffplay_debug.h"
#include "version.h"
#include "ijkmeta.h"

#include "ff_ffplay_options.h"


#include "libavformat/avformat.h"

int ffutils_find_rtmp_info(FFPlayer *ffp, AVFormatContext *ic, AVDictionary **options){
    int ret = avformat_find_stream_info(ic, options);
    return ret;
}
