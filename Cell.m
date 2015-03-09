//
//  Cell.m
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Cell.h"
#import <QuartzCore/QuartzCore.h> 

@implementation Cell




extern NSString* dispositivo;


- (id)init {
	
    if (self = [super init]) {
		
        
        if ([dispositivo isEqualToString:@"iPhone"])
            self.frame = CGRectMake(0, 0, 150 , 120);
        else  if ([dispositivo isEqualToString:@"iPhone5"])
            self.frame = CGRectMake(0, 0, 150 , 150);
        else  if ([dispositivo isEqualToString:@"iPad"])
            self.frame = CGRectMake(0, 0, 350 , 280);
        

		[[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
		
        [self addSubview:self.view];
	}
	
    return self;
	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/




@end
