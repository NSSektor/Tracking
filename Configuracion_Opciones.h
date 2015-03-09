//
//  Configuracion_Opciones.h
//  Tracking
//
//  Created by Angel Rivas on 25/02/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Configuracion_Opciones : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray* opciones;
    IBOutlet UILabel* lbl_titulo;
    IBOutlet UITableView* tbl;
    NSArray* tiempo;
}

-(IBAction)atras:(id)sender;

@end
