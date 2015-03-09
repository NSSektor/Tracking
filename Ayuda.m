//
//  Ayuda.m
//  Tracking
//
//  Created by Angel Rivas on 21/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import "Ayuda.h"
#import "Login.h"
#import "Resumen.h"


extern NSString* form;

@interface Ayuda ()

@end

@implementation Ayuda

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
    actividad.hidden = YES;
    [self Animacion:1];
    // Do any additional setup after loading the view from its nib.
    //1
    NSString *urlString = @"http://help.tecnologiza.me/main/main/index/appName/trackingSystem/";
    
    //2
    NSURL *url = [NSURL URLWithString:urlString];
    
    //3
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //4
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    //5
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil) [myWebView loadRequest:request];
         else if (error != nil) {
             NSLog(@"Error: %@", error);
             UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Tracking" message:@"No esta conectado a internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [Notpermitted show];
             [self Animacion:2];
         }
     }];
}


-(IBAction)llamar:(id)sender{
    
 //   NSLog(@"check %@", [[UIDevice currentDevice] model]);
    
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        UIAlertView *permitted=[[UIAlertView alloc] initWithTitle:@"Tracking" message:@"Esta llamada puede incrementar la renta mensual de la línea telefónica. ¿Desea realizarla?" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Cancelar",nil];
        [permitted setTag:1];
        [permitted show];
    } else {
        UIAlertView *Notpermitted=[[UIAlertView alloc] initWithTitle:@"Tracking" message:@"Este dispositivo no puede realizar llamadas telefónicas" delegate:nil cancelButtonTitle:@"Aceptar" otherButtonTitles:nil];
        [Notpermitted show];
    }
    
    
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:+525553749335"]]];
        }
    }
    
}

-(IBAction)atras:(id)sender{
    
    if ([form isEqualToString:@"Login"]) {
        
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
    
    else{
        
        NSString* view_name = @"Resumen";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Resumen_iPhone5";
        }
        else{
            view_name = @"Resumen_iPad";
        }
        
        Resumen *view = [[Resumen alloc] initWithNibName:view_name bundle:nil];
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


- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self Animacion:1];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self Animacion:2];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
[self Animacion:2];
}


//-(void)webview:(

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
