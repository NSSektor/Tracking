//
//  Resumen.h
//  Tracking
//
//  Created by Angel Rivas on 28/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
#import "UIGridViewDelegate.h"
#import "UIGridView.h"

@interface Resumen : UIViewController<UITableViewDataSource, UITableViewDelegate, SOAPToolDelegate, NSXMLParserDelegate,UIGridViewDelegate>{
    
    IBOutlet UIButton       *btn_menu;
    IBOutlet UITableView    *tbl_menu;
    IBOutlet UIView         *panel;
    IBOutlet UIImageView    *img_titulo;
    IBOutlet UILabel        *lbl_bienvenido;
    IBOutlet UIButton       *btn_actualizar;
    IBOutlet UILabel        *lbl_actualizar;
    IBOutlet UIActivityIndicatorView *actividad;

    
    
    NSArray*  array_menu;
    NSArray*  array_menu_img;
    
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
    
    NSTimer *contadorTimer;
    
    UIRefreshControl* refreshControl;
    __weak IBOutlet UIGridView *table;
   
}

-(void)actualizarxtimer:(id)sender;


-(IBAction)ShowMenu:(id)sender;

-(IBAction)actualizar:(id)sender;

-(void)ActualizandoTabla;


-(IBAction)EnMoviento:(id)sender;
-(IBAction)Detenidas:(id)sender;
-(IBAction)SinGps:(id)sender;
-(IBAction)Osciosas:(id)sender;
-(IBAction)SinReportar:(id)sender;
-(IBAction)ConExceso:(id)sender;

-(void)Unidades;

-(void)FillArray;
-(void)Animacion:(int)Code;



@end
