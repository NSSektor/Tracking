//
//  SimpleTableCell.m
//  Tracking
//
//  Created by Angel Rivas on 21/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "SimpleTableCell.h"
#import "StreetView.h"

extern BOOL mostrar_street;

@implementation SimpleTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}



-(IBAction)test:(id)sender{
    NSLog(@"seleccionaron el boton");
}



@end
