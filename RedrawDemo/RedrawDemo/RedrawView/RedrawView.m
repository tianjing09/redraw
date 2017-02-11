//
//  RedrawView.m
//  DrawWall
//
//  Created by tianjing on 13-1-2.
//  Copyright (c) 2013年 TJ. All rights reserved.
//

#import "RedrawView.h"

@interface RedrawView()
{
    //每次触摸结束前经过的点，形成线的点数组
    NSMutableArray *pointArray;
    //每次触摸结束后的线数组
    NSMutableArray *lineArray;
    //删除的线的数组，方便重做时取出来,重现的时候添加到point，line里面
    NSMutableArray *deleteArray;
    CGPoint myBeginPoint;
    NSTimer *timer;
    int pointIndex;
    int lineIndex;
}
@end

@implementation RedrawView

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        pointArray=[[NSMutableArray alloc]init];
        lineArray=[[NSMutableArray alloc]init];
        deleteArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //获取当前上下文，
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 8.0f);
    //线条拐角样式，设置为平滑
    CGContextSetLineJoin(context, kCGLineJoinRound);
    //线条开始样式，设置为平滑
    CGContextSetLineCap(context, kCGLineCapRound);
    //查看lineArray数组里是否有线条，有就将之前画的重绘，没有只画当前线条
    if ([lineArray count] > 0) {
        for (int i = 0; i < [lineArray count]; i++) {
            NSArray * array = [NSArray arrayWithArray:[lineArray objectAtIndex:i]];
            if ([array count] > 0) {
                CGContextBeginPath(context);
                CGPoint myStartPoint = CGPointFromString([array objectAtIndex:0]);
                CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
                
                for (int j = 0; j < [array count] - 1; j++) {
                    CGPoint myEndPoint = CGPointFromString([array objectAtIndex:j+1]);
                    CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
                }
                //设置线条的颜色，要取uicolor的CGColor
                CGContextSetStrokeColorWithColor(context,[[UIColor blackColor] CGColor]);
                //设置线条宽度
                CGContextSetLineWidth(context, 8.0);
                //保存自己画的
                CGContextStrokePath(context);
            }
        }
    }
    //画当前的线
    if ([pointArray count] > 0) {
        CGContextBeginPath(context);
        CGPoint myStartPoint = CGPointFromString([pointArray objectAtIndex:0]);
        CGContextMoveToPoint(context, myStartPoint.x, myStartPoint.y);
        
        for(int j = 0; j < [pointArray count]-1; j++){
            CGPoint myEndPoint = CGPointFromString([pointArray objectAtIndex:j + 1]);
            CGContextAddLineToPoint(context, myEndPoint.x,myEndPoint.y);
        }
        CGContextSetStrokeColorWithColor(context,[[UIColor blackColor] CGColor]);
        CGContextSetLineWidth(context, 8.0);
        CGContextStrokePath(context);
    }
}

//手指开始触屏开始
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
      NSLog(@"touchesBegan手指开始触屏开始");
}

//手指移动时候发出
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	myBeginPoint = [touch locationInView:self];
    NSString *sPoint = NSStringFromCGPoint(myBeginPoint);
    [pointArray addObject:sPoint];
    [self setNeedsDisplay];
}

//当手指离开屏幕时候
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *array = [NSArray arrayWithArray:pointArray];
    [lineArray addObject:array];
    pointArray = [[NSMutableArray alloc]init];
}

//电话呼入等事件取消时候发出
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"touches Canelled");
}

//撤销，将当前最后一条信息移动到删除数组里，方便恢复时调用
- (void)revocation
{
    if ([lineArray count]) {
        [lineArray removeLastObject];
    }
    [self setNeedsDisplay];
}

//将删除线条数组里的信息，移动到当前数组，在主界面重绘
- (void)repeat
{
    if ([deleteArray count] > 0) {
        [lineArray removeAllObjects];
        [pointArray removeAllObjects];
        lineIndex = 0;
        pointIndex = 0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    } else {
        if (lineArray.count) {
            [self clear];
            [self repeat];
        }
    }
}

-(void)play
{
    if(lineIndex < [deleteArray count]) {
        if (pointIndex < [[deleteArray objectAtIndex:lineIndex] count]) {
            [pointArray addObject:[[deleteArray objectAtIndex:lineIndex] objectAtIndex:pointIndex]];
            pointIndex = pointIndex + 1;
            [self setNeedsDisplay];
        } else {
            pointIndex = 0;
            lineIndex = lineIndex + 1;
            NSArray *array = [NSArray arrayWithArray:pointArray];
            [lineArray addObject:array];
            pointArray = [[NSMutableArray alloc]init];
            [self setNeedsDisplay];
        }
   } else {
        [self stopPlay];
   }
}

- (void)stopPlay
{
    [timer invalidate];
    timer = nil;
}

- (void)clear
{
    [self stopPlay];
    if(deleteArray.count == 0) {
      deleteArray = [NSMutableArray arrayWithArray:lineArray];
    }
    [lineArray removeAllObjects];
    [pointArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)destroyAll
{
    [self stopPlay];
    [deleteArray removeAllObjects];
    [lineArray removeAllObjects];
    [pointArray removeAllObjects];
    [self setNeedsDisplay];
}

@end
