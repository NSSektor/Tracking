//
//  Annotation.h
//  Tracking
//
//  Created by Angel Rivas on 21/02/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Annotation : UIView

@property (nonatomic, weak) IBOutlet UIImageView *img_motor;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_eco;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_evento;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_fecha;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_ubicacion;
@property (nonatomic, weak) IBOutlet UILabel     *lbl_velocidad;
@property (nonatomic, weak) IBOutlet UIImageView *img_icono;
@property (nonatomic, weak) IBOutlet UIImageView *img_angulo;
@property (nonatomic, weak) IBOutlet UIButton *street;


-(IBAction)test:(id)sender;



@end
