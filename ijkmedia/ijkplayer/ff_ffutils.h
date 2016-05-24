//
//  ff_ffutils.h
//  IJKMediaPlayer
//
//  Created by jinchu darwin on 16/5/21.
//  Copyright © 2016年 bilibili. All rights reserved.
//

#ifndef ff_ffutils_h
#define ff_ffutils_h

#include "ff_ffplay_def.h"
#include "ff_fferror.h"
#include "ff_ffmsg.h"

int ffutils_find_rtmp_info(FFPlayer *ffp, AVFormatContext *ic, AVDictionary **options);

#endif /* ff_ffutils_h */
