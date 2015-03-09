//
//  Incidencias.h
//  Tracking
//
//  Created by Angel Rivas on 22/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
#import "SYXmlParser.h"

@interface Incidencias : UIViewController<UITextViewDelegate, UIPickerViewDelegate, SOAPToolDelegate, NSXMLParserDelegate, UIPickerViewDataSource>{
    
    IBOutlet UILabel     *lbl_detalle;
    IBOutlet UITextView  *txt_incidencia;
    IBOutlet UIButton    *btn_enviar;
    IBOutlet UIButton    *btn_atras;
    NSArray              *array_incidencias;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    IBOutlet UIActivityIndicatorView *actividad;

    
    
}

-(IBAction)enviar:(id)sender;
-(IBAction)detalle:(id)sender;


//

-(void)FillArray;
-(void)Mensaje;

-(void)Animacion:(int)Code;

-(IBAction)Ajustar:(id)sender;

//

@end
