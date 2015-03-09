//
//  Ayuda.h
//  Tracking
//
//  Created by Angel Rivas on 21/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Ayuda : UIViewController<UIWebViewDelegate,UIAlertViewDelegate> {
    
    IBOutlet UIButton*    btn_atras;
    IBOutlet UIWebView *myWebView;
    IBOutlet UIActivityIndicatorView *actividad;



}

-(IBAction)atras:(id)sender;

-(IBAction)llamar:(id)sender;


@end
