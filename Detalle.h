//
//  Detalle.h
//  Tracking
//
//  Created by Angel Rivas on 22/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SYSoapTool.h"
#import "SYXmlParser.h"
#import "CalloutMapAnnotation.h"
#import "BasicMapAnnotation.h"


@interface Detalle : UIViewController <SOAPToolDelegate, NSXMLParserDelegate,MKMapViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>{
	MKMapView *_mapView;
	CalloutMapAnnotation *_calloutAnnotation;
	MKAnnotationView *_selectedAnnotationView;
    
	BasicMapAnnotation *_customAnnotation;
    BasicMapAnnotation *_customAnnotation1;
    
	BasicMapAnnotation *_normalAnnotation;
    IBOutlet UIButton* btn_actualizar;
    IBOutlet UIButton* btn_atras;
    IBOutlet UIButton* btn_menu;
    
    
    //Vista secundaria
    
    IBOutlet UIView* alerta;
    IBOutlet UIButton* alerta_cancelar;
    IBOutlet UILabel*  lbl_alerta;

    
    
    ////xml///
    
    NSString* currentElement;
    
    NSMutableDictionary* currentElementData;
    
    NSMutableString* currentElementString;
    
    NSString *StringCode;
    
    NSString *StringMsg;
    
    
    
    IBOutlet UIActivityIndicatorView *actividad;
    

}

-(IBAction)setMap:(id)sender;

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKAnnotationView *selectedAnnotationView;


@property (nonatomic, retain) CalloutMapAnnotation *calloutAnnotation;
@property (nonatomic, retain) BasicMapAnnotation *customAnnotation;

@property (nonatomic, retain) BasicMapAnnotation *customAnnotation1;



@property (nonatomic, retain) BasicMapAnnotation *normalAnnotation;

@property (nonatomic, weak) IBOutlet UILabel        *lbl_titulo;


@property (nonatomic, weak) IBOutlet UIButton       *btn_mensajes;
@property (nonatomic, weak) IBOutlet UIButton       *btn_cabina;





-(IBAction)Unidades:(id)sender;

-(IBAction)actualizar:(id)sender;

-(IBAction)incidencias:(id)sender;

-(IBAction)compartir:(id)sender;

-(void)FillArray;

-(void)Mensaje;

-(void)Animacion:(int)Code;

-(IBAction)cabina:(id)sender;

-(IBAction)GoToStreetView:(id)sender;

-(IBAction)cancelar_actualizacion:(id)sender;

-(IBAction)ShowMenu:(id)sender;

@end
