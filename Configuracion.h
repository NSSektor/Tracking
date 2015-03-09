//
//  Configuracion.h
//  Tracking
//
//  Created by Angel Rivas on 30/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Configuracion : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
    NSArray                      *array_configuracion2;
    NSArray                      *array_configuracionvelocidad;
    NSMutableArray *array_configuracion;
    NSMutableArray *array_configuracion_img;
    
    __weak IBOutlet UITableView* tbl_opciones;
    __weak IBOutlet UIButton*      btn_regresar_opciones;
    __weak IBOutlet UIView*         contenedor_opciones;
    
}

-(IBAction)atras:(id)sender;

-(IBAction)contrato:(id)sender;

-(IBAction)CierraOpciones:(id)sender;

@end
