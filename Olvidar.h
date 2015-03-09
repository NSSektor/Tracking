//
//  Olvidar.h
//  Tracking
//
//  Created by Angel Rivas on 21/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
#import <CommonCrypto/CommonDigest.h>


#import "SYXmlParser.h"

@interface Olvidar : UIViewController<UITextFieldDelegate, SOAPToolDelegate, NSXMLParserDelegate>{
    
    IBOutlet UITextField*   txt_correo;
    IBOutlet UIButton    *btn_enviar;
    IBOutlet UIButton    *btn_atras;
    
    ////xml///
    
    NSString* currentElement;
    
    NSMutableDictionary* currentElementData;
    
    NSMutableString* currentElementString;
    
    NSString *StringCode;
    
    NSString *StringMsg;
    
    
    
    IBOutlet UIActivityIndicatorView *actividad;
    
}




-(IBAction)enviar:(id)sender;
-(IBAction)atras:(id)sender;


-(void)Mensaje;



-(void)Animacion:(int)Code;


- (BOOL)validateEmail:(NSString *)emailStr;


@end
