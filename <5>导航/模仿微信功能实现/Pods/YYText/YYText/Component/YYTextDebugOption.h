//
//  YYTextDebugOption.h
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/4/8.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

@class YYTextDebugOption;

/**
 The YYTextDebugTarget protocol defines the method a debug target should implement.
 A debug target can be add to the global container to receive the shared debug
 option changed notification.
 */
@protocol YYTextDebugTarget <NSObject>

@required
/**
 When the shared debug option changed, this method would be called on main thread.
 It should return as quickly as possible. The option's property should not be changed
 in this method.
 
 @param option  The shared debug option.
 */
- (void)setDebugOption:(YYTextDebugOption *)option;
@end



/**
 The debug option for YYText.
 */
@interface YYTextDebugOption : NSObject <NSCopying>
@property (nonatomic, strong) UIColor *baselineColor;      ///< baseline color
@property (nonatomic, strong) UIColor *CTFrameBorderColor; ///< CTFrame path border color
@property (nonatomic, strong) UIColor *CTFrameFillColor;   ///< CTFrame path fill color
@property (nonatomic, strong) UIColor *CTLineBorderColor;  ///< CTLine bounds border color
@property (nonatomic, strong) UIColor *CTLineFillColor;    ///< CTLine bounds fill color
@property (nonatomic, strong) UIColor *CTLineNumberColor;  ///< CTLine line number color
@property (nonatomic, strong) UIColor *CTRunBorderColor;   ///< CTRun bounds border color
@property (nonatomic, strong) UIColor *CTRunFillColor;     ///< CTRun bounds fill color
@property (nonatomic, strong) UIColor *CTRunNumberColor;   ///< CTRun number color
@property (nonatomic, strong) UIColor *CGGlyphBorderColor; ///< CGGlyph bounds border color
@property (nonatomic, strong) UIColor *CGGlyphFillColor;   ///< CGGlyph bounds fill color

- (BOOL)needDrawDebug; ///< `YES`: at least one debug color is visible. `NO`: all debug color is invisible/nil.
- (void)clear; ///< Set all debug color to nil.

/**
 Add a debug target.
 
 @discussion When `setSharedDebugOption:` is called, all added debug target will 
 receive `setDebugOption:` in main thread. It maintains an unsafe_unretained
 reference to this target. The target must to removed before dealloc.
 
 @param target A debug target.
 */
+ (void)addDebugTarget:(id<YYTextDebugTarget>)target;

/**
 Remove a debug target which is added by `addDebugTarget:`.
 
 @param target A debug target.
 */
+ (void)removeDebugTarget:(id<YYTextDebugTarget>)target;

/**
 Returns the shared debug option.
 
 @return The shared debug option, default is nil.
 */
+ (YYTextDebugOption *)sharedDebugOption;

/**
 Set a debug option as shared debug option.
 This method must be called on main thread.
 
 @discussion When call this method, the new option will set to all debug target
 which is added by `addDebugTarget:`.
 
 @param option  A new debug option (nil is valid).
 */
+ (void)setSharedDebugOption:(YYTextDebugOption *)option;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com