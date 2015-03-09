//
//  Configuracion.m
//  Tracking
//
//  Created by Angel Rivas on 30/01/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Configuracion.h"
#import "Resumen.h"
#import "Reachability.h"
#import "Contrato.h"
#import "ConfiguracionMenu.h"
#import "Configuracion_Opciones.h"
NSString* tiempo_configuracion;
NSString* tiempo_configuracion_old;
extern NSString* configuracion;
extern NSString* mapas;
extern NSString* busqueda;
extern NSString* tiempo_unidad_ociosa;
NSString* opcion;
NSInteger index_sel;
NSInteger index_velocidad;
NSString* velocidad_maxima;
extern NSString*limite_velocidad;
extern NSString* GlobalUsu;
extern NSString* Globalpass;

@interface Configuracion (){
    BOOL Show_Opciones;
}

@end

@implementation Configuracion

#pragma mark -
#pragma mark Notification Handling
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
    } else {
        NSLog(@"Unreachable");
    }
}

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
    configuracion = @"YES";
    // Do any additional setup after loading the view from its nib.
  //  array_configuracion = [[NSArray alloc]initWithObjects:@"5 min.", @"10 min.", @"15 min.", @"20 min.", @"25 min.", @"30 min.", @"35 min.", @"40 min.", @"45 min.", @"50 min", @"55 min.", @"60 min", nil ];
     array_configuracion2 = [[NSArray alloc]initWithObjects:@"5", @"10", @"15", @"20", @"25", @"30", @"35", @"40", @"45", @"50", @"55", @"60", nil ];

    array_configuracionvelocidad = [[NSArray alloc]initWithObjects:@"20", @"30", @"40", @"50", @"60", @"70", @"80", @"90", @"100", @"110", @"120", @"130", @"140", @"150", @"160", @"170", @"180", nil ];

    Show_Opciones = NO;
    
    [btn_regresar_opciones addTarget:self action:@selector(CierraOpciones:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Tiempo.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil || [contents isEqualToString:@""]) {
        
        tiempo_configuracion = @"300";
    }
    else{
        NSArray* arraytiempo = [contents componentsSeparatedByString:@","];
         tiempo_configuracion = [arraytiempo objectAtIndex:1];
    }
    
    tiempo_configuracion_old = tiempo_configuracion;
    
    for (int i =0; i <[array_configuracion2 count]; i++) {
        
        int j = 0;
        j = [[array_configuracion2 objectAtIndex:i] intValue];
        j = j * 60;
        
        

        tiempo_configuracion = [NSString stringWithFormat: @"%d", (int)j];
        
        if ([tiempo_configuracion_old isEqualToString:tiempo_configuracion]) {
            j = j / 60;
            tiempo_configuracion = [NSString stringWithFormat: @"%d", (int)j];
            tiempo_configuracion = [tiempo_configuracion stringByAppendingString:@" min."];
            tiempo_configuracion = [@"Frecuencia de actualización - " stringByAppendingString:tiempo_configuracion];
            index_sel = i;
            break;
            

        }

    }
    
    //velocidad

    fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Velocidad.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil || [contents isEqualToString:@""]) {
        
        velocidad_maxima = @"Límite de velocidad - 90 km";
        index_velocidad = 7;
        limite_velocidad = @"90";
    }
    else{
        
        for (int i=0; i<[array_configuracionvelocidad count]; i++) {
            
            if ([contents isEqualToString:[array_configuracionvelocidad objectAtIndex:i]]) {
                index_velocidad = i;
                limite_velocidad = contents;
            }
            
        }
        velocidad_maxima = @"Límite de velocidad  - ";
        velocidad_maxima = [velocidad_maxima stringByAppendingString:contents];
        velocidad_maxima = [velocidad_maxima stringByAppendingString:@" km."];
    }
    
    if (![mapas isEqualToString:@"Detalle"]) {
    //    array_configuracion_img = nsmu
        array_configuracion_img = [[NSMutableArray alloc]initWithObjects:@"googlemaps.png", @"reloj.pnj", @"speed.png", @"searching.png", @"clock.png", nil];
        array_configuracion = [[NSMutableArray alloc]initWithObjects:@"Mapas-Google Maps", tiempo_configuracion, velocidad_maxima, [[NSString stringWithFormat:@"Búsqueda -%@", busqueda] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], [NSString stringWithFormat:@"Unidad ociosa tiempo-%d%@",[tiempo_unidad_ociosa intValue] / 60, @"hrs"],nil];
    }
    else{
        array_configuracion_img = [[NSMutableArray alloc]initWithObjects:@"iosmaps.png", @"reloj.pnj", @"speed.png", @"searching.png", @"clock.png",nil];
        array_configuracion = [[NSMutableArray alloc]initWithObjects:@"Mapas - Apple Maps", tiempo_configuracion,  velocidad_maxima,[[NSString stringWithFormat:@"Búsqueda -%@", busqueda] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]], [NSString stringWithFormat:@"Unidad sin reportar-%d%@",[tiempo_unidad_ociosa intValue] / 60, @"hrs"],nil];
    }
    
    
}

-(IBAction)CierraOpciones:(id)sender{
    CGRect frame_panel_vista = contenedor_opciones.frame;
    if (Show_Opciones) {
        Show_Opciones = NO;
        frame_panel_vista.origin.y = 480;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                frame_panel_vista.origin.y = 568;
            }
        }
        else{
            frame_panel_vista.origin.y = 1024;
        }

    }
    else{
        Show_Opciones = YES;
        frame_panel_vista.origin.y = 0;
    }
    
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.2];
    contenedor_opciones.frame = frame_panel_vista;
    [UIView commitAnimations];
}

-(IBAction)atras:(id)sender{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Tiempo.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents != nil || ![contents isEqualToString:@""]) {
        NSArray* arraytiempo = [contents componentsSeparatedByString:@","];
        NSString* resultString = [arraytiempo objectAtIndex:0];
        resultString = [resultString stringByAppendingString:@","];
        resultString = [resultString stringByAppendingString:tiempo_configuracion];
        [resultString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    
    
    //Mapas
    fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Mapas.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    [mapas writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    

    
    //Mapas

    
    
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
    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:view animated:YES completion:nil];

}

-(IBAction)contrato:(id)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Tiempo.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents != nil || ![contents isEqualToString:@""]) {
        NSArray* arraytiempo = [contents componentsSeparatedByString:@","];
        NSString* resultString = [arraytiempo objectAtIndex:0];
        resultString = [resultString stringByAppendingString:@","];
        resultString = [resultString stringByAppendingString:tiempo_configuracion];
        [resultString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    Contrato *viewController = [[Contrato alloc] initWithNibName:@"Contrato_" bundle:nil];
    viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:viewController animated:YES completion:nil];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [array_configuracion count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"ConfiguracionMenu";
    ConfiguracionMenu *cell;
    
    cell = (ConfiguracionMenu *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSString* NibName = @"Configuracion_Menu";
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        else{
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
    }
    
   // cell.lbl_menu.text = [array_menu objectAtIndex:indexPath.row];
    cell.img_menu.image = [UIImage imageNamed:[array_configuracion_img objectAtIndex:indexPath.row]];
    NSArray* array_ = [[array_configuracion objectAtIndex:indexPath.row] componentsSeparatedByString:@"-"];
    cell.lbl_menu.text = [array_ objectAtIndex:0];
    cell.lbl_opcion.text = [array_ objectAtIndex:1];
    
   
    
    
    return cell;
    
    
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        
        opcion = @"mapas";
    }
    
    if (indexPath.row == 1) {
        
        opcion = @"tiempo";
    }
    
    if (indexPath.row == 2) {
        
        opcion = @"velocidad";
        index_sel = index_velocidad;
    }
    
    if (indexPath.row == 3) {
        opcion = @"busqueda";
        if ([busqueda isEqualToString:@"Ecónomico, Dirección"])
            index_sel = 0;
        else if ([busqueda isEqualToString:@"Ecónomico"])
            index_sel = 1;
        else if ([busqueda isEqualToString:@"Dirección"])
            index_sel = 2;
    }
    if (indexPath.row == 4) {
        opcion = @"ociosa";
        if ([tiempo_unidad_ociosa isEqualToString:@"60"]) {
            index_sel = 0;
        }
        else if ([tiempo_unidad_ociosa isEqualToString:@"120"]) {
            index_sel = 1;
        }
        else if ([tiempo_unidad_ociosa isEqualToString:@"180"]) {
            index_sel = 2;
        }
        else if ([tiempo_unidad_ociosa isEqualToString:@"240"]) {
            index_sel = 0;
        }
    }
    
    NSString* view_name = @"Configuracion_Opciones";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            view_name = @"Configuracion_Opciones_iPhone5";
    }
    else{
        view_name = @"Configuracion_Opciones_iPad";
    }
    
    Configuracion_Opciones *view = [[Configuracion_Opciones alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:view animated:YES completion:nil];
    
    return indexPath;
    
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
