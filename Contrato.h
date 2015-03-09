//
//  Contrato.h
//  Tracking
//
//  Created by Angel Rivas on 24/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Contrato : UIViewController{
    IBOutlet UIButton* btn_atras;
    UIButton* btn_aceptar;
    __weak IBOutlet UITextView *txt_texto_original;
}


-(IBAction)aceptar:(id)sender;

-(IBAction)atras:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView_;
@property (weak, nonatomic) IBOutlet UIView *ContentView_;


@end
