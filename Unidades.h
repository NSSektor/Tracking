//
//  Unidades.h
//  Tracking
//
//  Created by Angel Rivas on 29/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleTableCell.h"
#import "SYSoapTool.h"

@interface Unidades : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SOAPToolDelegate, NSXMLParserDelegate>{
    
    IBOutlet UITableView* tbl_unidades;
    IBOutlet UISearchBar* searchBar;
    
    NSArray*  array_menu;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
    NSTimer *contadorTimer;
    
}

-(IBAction)ShowMenu:(id)sender;


-(void)actualizarxtimer2:(id)sender;


-(void)Mensaje;

-(void)FillArray;



@end
