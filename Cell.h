//
//  Cell.h
//  naivegrid
//
//  Created by Apirom Na Nakorn on 3/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIGridViewCell.h"

@interface Cell : UIGridViewCell {
    
}
@property (nonatomic, retain) IBOutlet UIView* contenedor_ipad;
@property (nonatomic, retain) IBOutlet UILabel *lbl_titulo;
@property (nonatomic, retain) IBOutlet UILabel *lbl_numero;

@property (nonatomic, retain) IBOutlet UIView* contenedor_iphone;
@property (nonatomic,retain) NSString* posicion;
@property (nonatomic, retain) IBOutlet UILabel *lbl_titulo_1;
@property (nonatomic, retain) IBOutlet UILabel *lbl_numero_1;

@property (nonatomic, retain) IBOutlet UIView* contenedor_iphone_pequeño;
@property (nonatomic, retain) IBOutlet UILabel *lbl_titulo_2;
@property (nonatomic, retain) IBOutlet UILabel *lbl_numero_2;

@end
