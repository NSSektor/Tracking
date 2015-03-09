//
//  StreetView.m
//  Tracking
//
//  Created by Angel Rivas on 28/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "StreetView.h"
#import "Detalle.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Detalle_iOS.h"


extern NSString* latitud_unidad;
extern NSString* longitud_unidad;
extern NSString* angulo_unidad;
extern NSString* detalle_unidad;

extern BOOL mostrar_street;

extern NSString* mapas;


@interface StreetView (){
     GMSPanoramaView *panoView_;
}

@end

@implementation StreetView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    mostrar_street = NO;
    CGRect frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frame = CGRectMake(0, 20, 320, 40.0);
    }
    else{
        frame = CGRectMake(0.0, 20, 768, 60);
    }
    
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:frame];
    scoreLabel.textAlignment =  NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor blackColor];
    scoreLabel.backgroundColor = [UIColor whiteColor];
    scoreLabel.numberOfLines = 2;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [scoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    }
    else{
        [scoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22.0]];
    }
    scoreLabel.text = detalle_unidad;
    
    [self.view addSubview:scoreLabel];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        frame = CGRectMake(10, 26, 30, 30);
    }
    else{
        frame = CGRectMake(10, 25, 50, 50);
    }
    
    UIButton *btn_atras = [ [UIButton alloc ] initWithFrame:frame];
    UIImage *btnImage = [UIImage imageNamed:@"btn_regresa.png"];
    [btn_atras setImage:btnImage forState:UIControlStateNormal];
    [btn_atras addTarget:self
                  action:@selector(atras:)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn_atras];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            frame = CGRectMake(0, 60, 320, 528);
        }
        else{
            frame = CGRectMake(0, 60, 320, 440);
        }
        
    }
    else{
        frame = CGRectMake(0, 80, 768, 954);
    }
    
    
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:frame];
    [self.view addSubview:panoView_];
    [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake([latitud_unidad doubleValue], [longitud_unidad doubleValue])];
    
    
    
    [actividad setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [actividad setColor:[UIColor orangeColor]];
    actividad.hidden = YES;
    [self.view addSubview:actividad];
    
    
    
    

}


-(IBAction)atras:(id)sender{
    NSString* view_name = mapas;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            view_name = [view_name stringByAppendingString:@"_iPhone5"];
        
    }
    else{
        view_name = [view_name stringByAppendingString:@"_iPad"];
    }
    
    if ([mapas isEqualToString:@"Detalle"]) {
        
        Detalle *view = [[Detalle alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
        
    }
    
    else{
        Detalle_iOS *view = [[Detalle_iOS alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];

    }
    

}

-(void)Animacion:(int)Code{
    
    if (Code==1) {
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
        
    }
    else {
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
