//
//  Annotation.m
//  Tracking
//
//  Created by Angel Rivas on 21/02/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"Entre");
    }
    return self;
}

-(IBAction)test:(id)sender{
    NSLog(@"hice algo");
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
