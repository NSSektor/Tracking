//
//  Configuracion_Opciones.m
//  Tracking
//
//  Created by Angel Rivas on 25/02/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Configuracion_Opciones.h"
#import "Configuracion.h"

extern NSString* opcion;
extern NSString* mapas;
extern NSString* busqueda;
extern NSInteger index_sel;
extern NSString* limite_velocidad;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* tiempo_unidad_ociosa;
@interface Configuracion_Opciones ()

@end

@implementation Configuracion_Opciones

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
    if ([opcion isEqualToString:@"tiempo"]) {
        opciones = [[NSMutableArray alloc]initWithObjects:@"5 minutos", @"10 minutos", @"15 minutos", @"20 minutos", @"25 minutos", @"30 minutos", @"35 minutos", @"40 minutos", @"45 minutos", @"50 minutos", @"55 minutos", @"60 minutos", nil ];
        lbl_titulo.text = @"Frecuencia de Actualización de Datos";
        
        
        
    }
    else if([opcion isEqualToString:@"velocidad"]){
        opciones = [[NSMutableArray alloc]initWithObjects:@"20 km", @"30 km", @"40 km", @"50 km", @"60 km", @"70 km", @"80 km", @"90 km", @"100 km", @"110 km", @"120 km", @"130 km", @"140 km", @"150 km", @"160 km", @"170 km", @"180 km", nil];
            lbl_titulo.text = @"Límite de velocidad ";
    }
    else if ([opcion isEqualToString:@"busqueda"]){
        opciones = [[NSMutableArray alloc]initWithObjects:@"Ecónomico, Dirección", @"Ecónomico", @"Dirección", nil];
        lbl_titulo.text = @"Opciones de búsqueda";
    }
    else if ([opcion isEqualToString:@"ociosa"]){
        opciones = [[NSMutableArray alloc]initWithObjects:@"1 hora", @"2 horas", @"3 horas", @"4 horas", nil];
        lbl_titulo.text = @"Tiempo para considerar unidad sin reportar ";
    }
    else{
        opciones = [[NSMutableArray alloc]initWithObjects:@"Apple Maps", @"Google Maps", nil ];
        lbl_titulo.text = @"Tipo de mapas";
        if ([mapas isEqualToString:@"Detalle"]) {
            index_sel = 0;
        }
        else{
            index_sel = 1;
        }
    }
}

-(IBAction)atras:(id)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    if ([opcion isEqualToString:@"tiempo"]) {
        NSString* tiempo_configuracion = @"300";
        tiempo = [[NSArray alloc]initWithObjects:@"300",@"600", @"900", @"1200", @"1500", @"1800",@"2100", @"2400",@"2700", @"3000", @"3300", @"3600", nil];
        for (int x=0; x<[tiempo count]; x++) {
            if (index_sel ==x) {
                tiempo_configuracion = [tiempo objectAtIndex:x];
                break;
            }
        }
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
    }
    else if([opcion isEqualToString:@"velocidad"]){
        
        NSString* resultString = [opciones objectAtIndex:index_sel];
        limite_velocidad = resultString;
        resultString = [resultString stringByReplacingOccurrencesOfString:@" km" withString:@""];
        NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Velocidad.txt"];
        fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
         [resultString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];

        
    }
    else if ([opcion isEqualToString:@"busqueda"]){
        NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Busqueda.txt"];
        fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
        
        if (index_sel==0) {
            busqueda = @"Ecónomico, Dirección";
        }
        else if (index_sel==1){
            busqueda = @"Ecónomico";
        }
        else{
            busqueda = @"Dirección";
        }
        [busqueda writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    }
    else if ([opcion isEqualToString:@"ociosa"]){
        NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_tiempo_unidad_ociosa.txt"];
        fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
        
        if (index_sel==0) {
            tiempo_unidad_ociosa = @"60";
        }
        else if (index_sel==1){
            tiempo_unidad_ociosa = @"120";
        }
        else if (index_sel==2){
            tiempo_unidad_ociosa = @"180";
        }
        
        else{
            tiempo_unidad_ociosa = @"240";
        }
        [tiempo_unidad_ociosa writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    }
    else{
        NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Mapas.txt"];
        fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];

        if (index_sel==0) {
            mapas = @"Detalle";
            
        }
        else{
            mapas = @"Detalle_iOS";
        }
        [mapas writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    
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
    view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:view animated:YES completion:nil];
    
}

//Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [opciones count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell  = nil;
    cell  = [tableView dequeueReusableCellWithIdentifier:@"celda"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"celda"];
    }
    
    cell.textLabel.text = [opciones objectAtIndex:indexPath.row];
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (index_sel==indexPath.row) {
            cell.accessoryType =  UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType =  UITableViewCellAccessoryNone;
        
    }

    

    return cell;
    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    index_sel = indexPath.row;
    [tbl reloadData];
    
    return indexPath;
    
}




//Table View

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
