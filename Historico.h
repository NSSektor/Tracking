//
//  Historico.h
//  Tracking
//
//  Created by Angel Rivas on 6/19/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"
#import <GoogleMaps/GoogleMaps.h>


@interface Historico : UIViewController<GMSMapViewDelegate,SOAPToolDelegate, NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>{
    
    __weak IBOutlet UIButton   *btn_atras;
    __weak IBOutlet UILabel     *lbl_mapa;
    __weak IBOutlet UIActivityIndicatorView *actividad;
    __weak IBOutlet UIView *panel_mapa;
    __weak IBOutlet UIView *panel_street;
    IBOutlet UIStepper*                    steperCode;
    IBOutlet UISegmentedControl* sg_tipo_mapa;
    __weak IBOutlet UISegmentedControl* sg_Actualizar;
    __weak IBOutlet UISegmentedControl* sg_Vista;
    __weak IBOutlet UITableView* tbl_historico;
    GMSMapView *mapView_;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    
}

-(IBAction)ActualizaHistorico:(id)sender;
-(void)FillArray;
-(IBAction)Cerrar:(id)sender;
-(IBAction)setMap:(id)sender;
-(IBAction)SetViews:(id)sender;
-(void)Animacion:(int)Code;
-(IBAction)Atras:(id)sender;
-(IBAction)valueChanged:(id)sender;

@end
