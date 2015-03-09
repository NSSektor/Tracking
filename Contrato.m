//
//  Contrato.m
//  Tracking
//
//  Created by Angel Rivas on 24/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Contrato.h"
#import "Login.h"
#import "Reachability.h"
#import "Configuracion.h"

BOOL reachable;
extern NSString* configuracion;
extern NSString* dispositivo;

@interface Contrato (){
    int contador;
    
}

@end

@implementation Contrato

#pragma mark -
#pragma mark Notification Handling
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
        reachable = YES;
    } else {
        NSLog(@"Unreachable");
        reachable = NO;
    }
}

#pragma mark -
#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Add Observer
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    contador = 0;
     [btn_atras addTarget:self action:@selector(atras:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.ScrollView_ layoutIfNeeded];
    
    if (contador==0) {
        
        NSString* string = txt_texto_original.text;
        
        txt_texto_original.hidden = YES;
        
        UIFont *font = [UIFont fontWithName:@"Helvetica" size:12];
        CGSize constraint = CGSizeMake(300,NSUIntegerMax);
        
        NSDictionary *attributes = @{NSFontAttributeName: font};
        
        CGRect rect = [string boundingRectWithSize:constraint
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:attributes
                                           context:nil];
        
        rect.size.width = self.view.frame.size.width - 20;
        rect.origin.x = 10.0;
        
        // Construct your label
        
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, rect.size.height)];
        
        
        
        [label setText:string];
        [label setTextAlignment:NSTextAlignmentCenter];
        label.lineBreakMode = NSLineBreakByWordWrapping;
        if ([dispositivo isEqualToString:@"iPad"]) {
            font = [UIFont fontWithName:@"Helvetica" size:19];
        }
        
        [label setFont:font];
        
        
        
        label.numberOfLines = FLT_MAX;
        
        [self.ContentView_ addSubview:label];
        
        
        btn_aceptar =  [[UIButton alloc]initWithFrame:CGRectMake(10, label.frame.size.height + 10, self.view.frame.size.width - 20, 30)];
        btn_aceptar.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:123.0/255.0 blue:32.0/255.0 alpha:1.0];
        btn_aceptar.titleLabel.textColor = [UIColor whiteColor];
        [btn_aceptar setTitle:@"Aceptar Términos y Condiciones" forState:UIControlStateNormal];
        [btn_aceptar addTarget:self action:@selector(aceptar:) forControlEvents:UIControlEventTouchUpInside];
        [self.ContentView_ addSubview:btn_aceptar];
        
        CGRect newFrame = self.ContentView_.frame;
        newFrame.size.height = label.frame.size.height + 60.0;
        self.ContentView_.frame = newFrame;
        self.ScrollView_ .contentSize = self.ContentView_.bounds.size;
        
     //   [self.ScrollView_ scrollRectToVisible:newFrame animated:YES];
        if ([configuracion isEqualToString:@"YES"]) {
            btn_atras.hidden = NO;
            btn_aceptar.hidden = YES;
        }
        else{
            btn_atras.hidden = YES;
            btn_aceptar.hidden = NO;
        }
        contador++;
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)aceptar:(id)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@/Aceptar.txt", documentsDirectory];
    [@"Si" writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    NSString* view_name = @"Login";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            view_name = @"Login_iPhone5";
    }
    else{
        view_name = @"Login_iPad";
    }
    
    
    Login *view = [[Login alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];

    
    
}

-(IBAction)atras:(id)sender{
    NSString* view_name = @"Configuracion";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            view_name = @"Cofiguracion_iPhone5";
    }
    else{
        view_name = @"Cofiguracion_iPad";
    }
    
    
    Configuracion *view = [[Configuracion alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
