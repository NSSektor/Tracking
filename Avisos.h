//
//  Avisos.h
//  Tracking
//
//  Created by Angel Rivas on 12/15/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYSoapTool.h"

@interface Avisos : UIViewController<SOAPToolDelegate, NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>{
    __weak IBOutlet UITableView *tbl_avisos;
    __weak IBOutlet UIButton   *btn_atras;
    UIRefreshControl* refreshControl;
    
    ////xml///
    NSString* currentElement;
    NSMutableDictionary* currentElementData;
    NSMutableString* currentElementString;
    NSString *StringCode;
    NSString *StringMsg;
}

-(IBAction)Resumen:(id)sender;
-(void)FillArray;
-(void)Animacion:(int)Code;
-(IBAction)MarcarLeidas:(id)sender;


@end
