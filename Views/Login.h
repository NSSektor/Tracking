//
//  Login.h
//  Tracking
//
//  Created by Angel Rivas on 29/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"

@interface Login : UIViewController <UITextFieldDelegate, SOAPToolDelegate, NSXMLParserDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITextField *txt_usuario;
    IBOutlet UITextField *txt_pass;
    IBOutlet UIButton    *check_button;
    IBOutlet UIButton    *btn_enviar;
    IBOutlet UIButton    *btn_ayuda;
    IBOutlet UIButton    *btn_olvide;
    BOOL checked;
    NSMutableData *_responseData;
    IBOutlet UIActivityIndicatorView *actividad;
    IBOutlet UITableView* autocompleteTableView;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    //Arreglos//
    
    //Arreglos//

    
}

-(IBAction)iniciar:(id)sender;
-(IBAction)ayuda:(id)sender;
-(IBAction)olvidar:(id)sender;
-(IBAction)check:(id)sender;
-(void)Resumen;
-(void)FillArray;
-(void)Animacion:(int)Code;
-(NSString*)ReadFileRecordar;
-(void)EscribirArchivos;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;

@end

