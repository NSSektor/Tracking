//
//  Detalle_iOS.h
//  Tracking
//
//  Created by Angel Rivas on 24/02/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "SYSoapTool.h"
#import "SYXmlParser.h"



@interface Detalle_iOS : UIViewController <GMSMapViewDelegate,SOAPToolDelegate,NSXMLParserDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
    
    IBOutlet UILabel* lbl_titulo;
    GMSMapView *mapView;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    IBOutlet UIActivityIndicatorView *actividad;
    
    //Vista secundaria
    
    IBOutlet UIView* alerta;
    IBOutlet UIView* panel_mapa;
    IBOutlet UIButton* alerta_cancelar;
    IBOutlet UILabel*  lbl_alerta;
    IBOutlet UIButton* btn_atras;
    IBOutlet UIButton* btn_menu;
}

-(IBAction)Unidades:(id)sender;
-(IBAction)actualizar:(id)sender;
-(IBAction)incidencias:(id)sender;
-(IBAction)compartir:(id)sender;
-(void)FillArray;
-(void)Mensaje;
-(void)Animacion:(int)Code;
-(IBAction)cancelar_actualizacion:(id)sender;
-(IBAction)ZoomIn:(id)sender;
-(IBAction)ZoomOut:(id)sender;
-(IBAction)setMap:(id)sender;
-(IBAction)ShowMenu:(id)sender;

@end
