//
//  FaceOverlayView.m
//  CustomOverlayViewDemo
//
//  Created by songjian on 13-3-12.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "FaceOverlayView.h"

@implementation FaceOverlayView

#pragma mark - Override

- (void)createPath
{
    FaceOverlay *faceOverlay = (FaceOverlay *)self.overlay;
    
    if (faceOverlay == nil)
    {
        return;
    }
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    // Construct left circle path
    CGRect leftRect = [self rectForMapRect:[faceOverlay getLeftMapRect]];
    CGPathRef leftPath = NULL;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        leftPath = CGPathCreateWithEllipseInRect(leftRect, NULL);
    }else{
        leftPath = CGPathCreateMutable();
        CGPathAddEllipseInRect((CGMutablePathRef)leftPath,NULL,leftRect);
    }
    CGPathAddPath(thePath, NULL, leftPath);
    CGPathRelease(leftPath);
    
    // Construct right circle path
    CGRect rightRect = [self rectForMapRect:[faceOverlay getRightMapRect]];
    CGPathRef rightPath = NULL;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
        rightPath = CGPathCreateWithEllipseInRect(rightRect, NULL);
    }else{
        rightPath = CGPathCreateMutable();
        CGPathAddEllipseInRect((CGMutablePathRef)rightPath,NULL,rightRect);
    }
    CGPathAddPath(thePath, NULL, rightPath);
    CGPathRelease(rightPath);
    
    // Construct line path
    CGMutablePathRef line = CGPathCreateMutable();
    
    CGPoint lpoint = [self pointForMapPoint:[faceOverlay getLeftCenter]];
    CGPathMoveToPoint(line, NULL, lpoint.x,lpoint.y);
    CGPoint rpoint = [self pointForMapPoint:[faceOverlay getRightCenter]];
    CGPathAddLineToPoint(line, NULL, rpoint.x, rpoint.y);
    CGPathAddPath(thePath, NULL, line);
    CGPathRelease(line);
    
    self.path = thePath;
    
    CGPathRelease(thePath);
    thePath = NULL;
}

#pragma mark - Life Cycle

- (id)initWithFaceOverlay:(FaceOverlay *)faceOverlay;
{
    self = [super initWithOverlay:faceOverlay];
    if (self)
    {
        
    }
    
    return self;
}

- (FaceOverlay *)faceOverlay
{
    return (FaceOverlay*)self.overlay;
}

@end
