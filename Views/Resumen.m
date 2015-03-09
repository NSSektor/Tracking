//
//  Resumen.m
//  Tracking
//
//  Created by Angel Rivas on 28/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import "Resumen.h"
#import "Unidades.h"
#import "Login.h"
#import "Ayuda.h"
#import "TableCellResumen.h"
#import "Reachability.h"
#import "Configuracion.h"
#import "Cell.h"


CGFloat LayerPosition;
BOOL Show;
extern NSString* form;
extern NSString* limite_velocidad;
extern NSString* tiempo_unidad_ociosa;
extern NSString* GlobalString;
NSString* GlobalUsu;
NSString* Globalpass;
BOOL reachable;
BOOL utilizar_animacion;
//ARRAY

extern NSMutableArray*  MArrayFlota;
extern NSMutableArray*  MArrayEco;
extern NSMutableArray*  MArrayID;
extern NSMutableArray*  MArrayIP;
extern NSMutableArray*  MArrayLatitud;
extern NSMutableArray*  MArrayLongitud;
extern NSMutableArray*  MArrayAngulo;
extern NSMutableArray*  MArrayVelocidad;
extern NSMutableArray*  MArrayFecha;
extern NSMutableArray*  MArrayEvento;
extern NSMutableArray*  MArrayEstatus;
extern NSMutableArray*  MArrayIcono;
extern NSMutableArray*  MArrayUbicacion;
extern NSMutableArray*  MArrayMotor;
extern NSMutableArray*  MArrayTelefono;
extern NSMutableArray*  MArrayMensajes;
extern NSMutableArray*  MArrayIcono_Mapa;
//ARRAY

NSString* filtro;
NSInteger enmovimiento;
NSInteger detenidas;
NSInteger singps;
NSInteger osciosas;
NSInteger sinreportar;
NSInteger conexceso;

NSString* texto_busqueda;

extern NSIndexPath *index_seleccionado;

extern NSString* ocultar;

extern NSString* dispositivo;

@interface Resumen (){
    SYSoapTool *soapTool;
    
}


@end

@implementation Resumen

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
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    index_seleccionado = [NSIndexPath indexPathForRow:0 inSection:0];
    lbl_actualizar.text = @"";
    utilizar_animacion = YES;
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm:ss"];
    NSString *resultString = [dateFormatter stringFromDate: currentTime];
    NSString *resultString1 = [dateFormatter1 stringFromDate: currentTime];
    lbl_actualizar.text = [NSString stringWithFormat:@"%@ %@ %@ %@", @"Actualizado el: ", resultString, @"a las ", resultString1];
    [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
    
   
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Tiempo.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    resultString = [dateFormatter stringFromDate: currentTime];
    if (contents == nil || [contents isEqualToString:@""]) {
        
        resultString = [resultString stringByAppendingString:@",300"];
    }
    else{
        NSArray* arraytiempo = [contents componentsSeparatedByString:@","];
        resultString = [resultString stringByAppendingString:@","];
        resultString = [resultString stringByAppendingString:[arraytiempo objectAtIndex:1]];
        
    }

    
    [resultString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    
    
    contadorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actualizarxtimer:) userInfo:nil repeats:YES];
    
    
    actividad.hidden = YES;
    
    
    
    texto_busqueda = @"";
    
    form = @"Resumen";
    filtro = @"TODAS";

    
     array_menu = [[NSArray alloc]initWithObjects:@"Inicio", @"Unidades", @"Ayuda", @"Configuración", @"Cerrar sesión", nil ];
    
     array_menu_img = [[NSArray alloc]initWithObjects:@"inicio.png", @"mis_unidades.png", @"ayuda.png", @"configuracion.png", @"cerrar_sesion.png", nil ];
    

    Show = NO;
    
    enmovimiento = 0;
    detenidas    = 0;
    singps       = 0;
    osciosas     = 0;
    sinreportar  = 0;
    conexceso    = 0;
    
    
    for (int i = 0; i < [MArrayEstatus count]; i++) {
        

        

        if ([[[MArrayEstatus objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"MOVIMIENTO"]) {
            enmovimiento++;
        }
        else if ([[[MArrayEstatus objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"DETENIDA"]) {
            detenidas++;
        }
        else if ([[[MArrayEstatus objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]isEqualToString:@"SIN GPS"]) {
            singps++;
        }
        else if ([[[MArrayEstatus objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"OSCIOSA"]) {
            osciosas++;
        }
        else if ([[[MArrayEstatus objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"SIN REPORTAR"]) {
            sinreportar++;
        }
        else{
            conexceso++;
        }
        
    }
    
    refreshControl = [[UIRefreshControl alloc]init];
    [table addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(ActualizandoTabla) forControlEvents:UIControlEventValueChanged];
    table.uiGridViewDelegate = self;
    
}

- (CGFloat) gridView:(UIGridView *)grid widthForColumnAt:(int)columnIndex
{
    CGFloat retorno = 0;
    if ([dispositivo isEqualToString:@"iPhone"])
        retorno = 150;
    else  if ([dispositivo isEqualToString:@"iPhone5"])
        retorno = 150;
    else  if ([dispositivo isEqualToString:@"iPad"])
        retorno = 350;
    return retorno;
}

- (CGFloat) gridView:(UIGridView *)grid heightForRowAt:(int)rowIndex
{
    CGFloat retorno = 0;
    if ([dispositivo isEqualToString:@"iPhone"])
        retorno = 120;
    else  if ([dispositivo isEqualToString:@"iPhone5"])
        retorno = 150;
    else  if ([dispositivo isEqualToString:@"iPad"])
        retorno = 280;
    return retorno;
}

- (NSInteger) numberOfColumnsOfGridView:(UIGridView *) grid
{
    return 2;
}


- (NSInteger) numberOfCellsOfGridView:(UIGridView *) grid
{
    return 6;
}

- (UIGridViewCell *) gridView:(UIGridView *)grid cellForRowAt:(int)rowIndex AndColumnAt:(int)columnIndex
{
    Cell *cell = (Cell *)[grid dequeueReusableCell];
    
    if (cell == nil) {
        cell = [[Cell alloc] init];
    }
    
    if ([dispositivo isEqualToString:@"iPhone"])
        cell.contenedor_iphone_pequeño.hidden = NO;
    else  if ([dispositivo isEqualToString:@"iPhone5"])
        cell.contenedor_iphone.hidden = NO;
    else  if ([dispositivo isEqualToString:@"iPad"])
        cell.contenedor_ipad.hidden = NO;
    

        
    
    if (rowIndex == 0 && columnIndex == 0) {
        cell.lbl_numero.text = [NSString stringWithFormat:@"%ld", (long)enmovimiento];
        cell.lbl_numero.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1.0];
        cell.lbl_titulo.text = @"Unidades en movimiento";
        CGRect rect = cell.lbl_titulo.frame;
        NSLog(@"CFDictionaryRef: %@", CGRectCreateDictionaryRepresentation(rect));
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)enmovimiento];
        cell.lbl_numero_1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1.0];
        cell.lbl_titulo_1.text = @"Unidades en movimiento";
        
        cell.lbl_numero_2.text = [NSString stringWithFormat:@"%ld", (long)enmovimiento];
        cell.lbl_numero_2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:57.0/255.0 alpha:1.0];
        cell.lbl_titulo_2.text = @"Unidades en movimiento";
    }
    else if (rowIndex == 0 && columnIndex == 1) {
        
        cell.lbl_numero_2.text = [NSString stringWithFormat:@"%ld", (long)detenidas];
        cell.lbl_numero_2.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:118.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.lbl_titulo_2.text = @"Unidades detenidas";
        
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)detenidas];
        cell.lbl_numero_1.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:118.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.lbl_titulo_1.text = @"Unidades detenidas";
        
        cell.lbl_numero.text = [NSString stringWithFormat:@"%ld", (long)detenidas];
        cell.lbl_numero.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:118.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.lbl_titulo.text = @"Unidades detenidas";
    }
    else if (rowIndex == 1 && columnIndex == 0) {
        
        cell.lbl_numero_2.text = [NSString stringWithFormat:@"%ld", (long)singps];
        cell.lbl_numero_2.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:100.0/255.0 blue:33.0/255.0 alpha:1.0];
        cell.lbl_titulo_2.text = @"Unidades sin GPS";
        
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)singps];
        cell.lbl_numero_1.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:100.0/255.0 blue:33.0/255.0 alpha:1.0];
        cell.lbl_titulo_1.text = @"Unidades sin GPS";
        
        cell.lbl_numero.text = [NSString stringWithFormat:@"%ld", (long)singps];
        cell.lbl_numero.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:100.0/255.0 blue:33.0/255.0 alpha:1.0];
        cell.lbl_titulo.text = @"Unidades sin GPS";
    }
    else if (rowIndex == 1 && columnIndex == 1) {
        
        cell.lbl_numero_2.text = [NSString stringWithFormat:@"%ld", (long)osciosas];
        cell.lbl_numero_2.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:68.0/255.0 blue:99.0/255.0 alpha:1.0];
        cell.lbl_titulo_2.text = @"Unidades ociosas";
        
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)osciosas];
        cell.lbl_numero_1.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:68.0/255.0 blue:99.0/255.0 alpha:1.0];
        cell.lbl_titulo_1.text = @"Unidades ociosas";
        
        cell.lbl_numero.text = [NSString stringWithFormat:@"%ld", (long)osciosas];
        cell.lbl_numero.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:68.0/255.0 blue:99.0/255.0 alpha:1.0];
        cell.lbl_titulo.text = @"Unidades ociosas";
    }
    else if (rowIndex == 2 && columnIndex == 0) {
        
        cell.lbl_numero_2.text = [NSString stringWithFormat:@"%ld", (long)sinreportar];
        cell.lbl_numero_2.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:61.0/255.0 blue:60.0/255.0 alpha:1.0];
        cell.lbl_titulo_2.text = @"Unidades sin reportar";
        
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)sinreportar];
        cell.lbl_numero_1.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:61.0/255.0 blue:60.0/255.0 alpha:1.0];
        cell.lbl_titulo_1.text = @"Unidades sin reportar";
        
        cell.lbl_numero.text = [NSString stringWithFormat:@"%ld", (long)sinreportar];
        cell.lbl_numero.backgroundColor = [UIColor colorWithRed:60.0/255.0 green:61.0/255.0 blue:60.0/255.0 alpha:1.0];
        cell.lbl_titulo.text = @"Unidades sin reportar";
    }
    else if (rowIndex == 2 && columnIndex == 1) {
        
        cell.lbl_numero_2.text = [NSString stringWithFormat:@"%ld", (long)conexceso];
        cell.lbl_numero_2.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:160.0/255.0 blue:26.0/255.0 alpha:1.0];
        cell.lbl_titulo_2.text = @"Unidades con exceso de velocidad";
        
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)conexceso];
        cell.lbl_numero_1.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:160.0/255.0 blue:26.0/255.0 alpha:1.0];
        cell.lbl_titulo_1.text = @"Unidades con exceso de velocidad";
        
        cell.lbl_numero_1.text = [NSString stringWithFormat:@"%ld", (long)conexceso];
        cell.lbl_numero.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:160.0/255.0 blue:26.0/255.0 alpha:1.0];
        cell.lbl_titulo.text = @"Unidades con exceso de velocidad";
    }
    
    
    return cell;
}

- (void) gridView:(UIGridView *)grid didSelectRowAt:(int)rowIndex AndColumnAt:(int)colIndex
{
    if (rowIndex == 0 && colIndex == 0)
        [self EnMoviento:self];
    else if (rowIndex == 0 && colIndex == 1)
        [self Detenidas:self];
    else if (rowIndex == 1 && colIndex == 0)
        [self SinGps:self];
    else if (rowIndex == 1 && colIndex == 1)
        [self Osciosas:self];
    else if (rowIndex == 2 && colIndex == 0)
        [self SinReportar:self];
    else if (rowIndex == 2 && colIndex == 1)
        [self ConExceso:self];
    
}




-(IBAction)EnMoviento:(id)sender{
    if (enmovimiento>0) {
         filtro = @"MOVIMIENTO";
        [self Unidades];
    }
    
}

-(IBAction)Detenidas:(id)sender{
    
    if (detenidas>0) {
        filtro=@"DETENIDA";
        [self Unidades];
    }
    
}

-(IBAction)SinGps:(id)sender{
    
    if (singps>0) {
        filtro = @"SIN GPS";
        [self Unidades];
    }
    
}

-(IBAction)Osciosas:(id)sender{
    
    if (osciosas>0) {
        filtro = @"OSCIOSA";
        [self Unidades];
    }
    
}

-(IBAction)SinReportar:(id)sender{
    
    if (sinreportar>0) {
        filtro = @"SIN REPORTAR";
        [self Unidades];
    }
}

-(IBAction)ConExceso:(id)sender{
    
    if (conexceso>0) {
        filtro = @"EXCESO VELOCIDAD";
        [self Unidades];
    }
    
}

-(void)Unidades{
    NSString* view_name = @"Unidades";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            view_name = @"Unidades_iPhone5";
    }
    else{
        view_name = @"Unidades_iPad";
    }
    
    
    Unidades *view = [[Unidades alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}


-(void)actualizarxtimer:(id)sender{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Tiempo.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil || [contents isEqualToString:@""]) {
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        resultString = [resultString stringByAppendingString:@",300"];
        [resultString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
   
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"dd-MM-yyyy hh:mm:ss"];
        NSDate *dateArchivo = [[NSDate alloc] init];
        
        NSArray* tiempo = [contents componentsSeparatedByString:@","];
        
        dateArchivo = [dateFormatter dateFromString:[tiempo objectAtIndex:0]];
        
        NSDate *currentTime = [NSDate date];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        currentTime = [dateFormatter dateFromString:resultString];
        
        NSTimeInterval diff = [currentTime timeIntervalSinceDate:dateArchivo];
        

        
        if (diff>[[tiempo objectAtIndex:1] intValue]) {
            resultString = [resultString stringByAppendingString:@","];
            resultString = [resultString stringByAppendingString:[tiempo objectAtIndex:1]];
            [resultString writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
            [self actualizar:self];
        }

    }
    
    
    

}

-(void)ActualizandoTabla{
    utilizar_animacion = NO;
    [self actualizar:self];
}

-(IBAction)actualizar:(id)sender{
    
    //  NSInteger r = arc4random()%5;
    
    [self Animacion:1];
    
    if (reachable) {
        
        MArrayFlota = [[NSMutableArray alloc]init];
        MArrayEco = [[NSMutableArray alloc]init];
        MArrayID = [[NSMutableArray alloc]init];
        MArrayIP = [[NSMutableArray alloc]init];
        MArrayLatitud = [[NSMutableArray alloc]init];
        MArrayLongitud = [[NSMutableArray alloc]init];
        MArrayAngulo = [[NSMutableArray alloc]init];
        MArrayVelocidad = [[NSMutableArray alloc]init];
        MArrayFecha = [[NSMutableArray alloc]init];
        MArrayEvento = [[NSMutableArray alloc]init];
        MArrayEstatus = [[NSMutableArray alloc]init];
        MArrayIcono = [[NSMutableArray alloc]init];
        MArrayUbicacion = [[NSMutableArray alloc]init];
        MArrayMotor = [[NSMutableArray alloc]init];
        MArrayTelefono = [[NSMutableArray alloc]init];
        MArrayMensajes = [[NSMutableArray alloc]init];
        MArrayIcono_Mapa = [[NSMutableArray alloc]init];

        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usVelocidad", @"usMinSinReporte",nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, limite_velocidad, tiempo_unidad_ociosa, nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"GetPositions" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];
    }
    else{
        [self Animacion:2];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
                                                          message:@"Sin conexión con el servidor"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
    }
    
}




-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión";
    
    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    if(![parser parse]){
        NSLog(@"Error al parsear");
        
        
    }
    else{
        NSLog(@"OK Parsing");
        
        
    }
    
    
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];

    
    
}


//xml
-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"The XML document is now being parsed.");
    
    MArrayFlota = [[NSMutableArray alloc]init];
    MArrayEco = [[NSMutableArray alloc]init];
    MArrayID = [[NSMutableArray alloc]init];
    MArrayIP = [[NSMutableArray alloc]init];
    MArrayLatitud = [[NSMutableArray alloc]init];
    MArrayLongitud = [[NSMutableArray alloc]init];
    MArrayAngulo = [[NSMutableArray alloc]init];
    MArrayVelocidad = [[NSMutableArray alloc]init];
    MArrayFecha = [[NSMutableArray alloc]init];
    MArrayEvento = [[NSMutableArray alloc]init];
    MArrayEstatus = [[NSMutableArray alloc]init];
    MArrayIcono = [[NSMutableArray alloc]init];
    MArrayUbicacion = [[NSMutableArray alloc]init];
    MArrayMotor = [[NSMutableArray alloc]init];
    MArrayTelefono = [[NSMutableArray alloc]init];
    MArrayMensajes = [[NSMutableArray alloc]init];
    MArrayIcono_Mapa = [[NSMutableArray alloc]init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %ld", (long)[parseError code]);
    [self FillArray];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    //Store the name of the element currently being parsed.
    currentElement = [elementName copy];
    
    //Create an empty mutable string to hold the contents of elements
    currentElementString = [NSMutableString stringWithString:@""];
    
    //Empty the dictionary if we're parsing a new status element
    if ([elementName isEqualToString:@"Response"]) {
        [currentElementData removeAllObjects];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    //If we've hit the </status> tag, store the data in the statuses array
    if ([elementName isEqualToString:@"code"]) {
        StringCode = currentElementString;
    }
    
    if ([elementName isEqualToString:@"msg"]) {
        StringMsg = currentElementString;
        
    }
    if ([elementName isEqualToString:@"ocultar"]) {
        ocultar = currentElementString;
    }
    if ([elementName isEqualToString:@"Flota"]) {
        [MArrayFlota addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Eco"]) {
        [MArrayEco addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"ID"]) {
        [MArrayID addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"IP"]) {
        [MArrayIP addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Latitud"]) {
        [MArrayLatitud addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Longitud"]) {
        [MArrayLongitud addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Angulo"]) {
        [MArrayAngulo addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Velocidad"]) {
        [MArrayVelocidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Fecha"]) {
        [MArrayFecha addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Evento"]) {
        [MArrayEvento addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Estatus"]) {
        [MArrayEstatus addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Icono"]) {
        [MArrayIcono addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Ubicacion"]) {
        [MArrayUbicacion addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Motor"]) {
        [MArrayMotor addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Telefono"]) {
        [MArrayTelefono addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Mensajes"]) {
        [MArrayMensajes addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Icono_mapa"]) {
        [MArrayIcono_Mapa addObject:currentElementString];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    
    [self FillArray];
    
}


-(void)FillArray{
    
    //Array
    
    
    NSString* mensajeAlerta = StringMsg;
    
    NSInteger code = [StringCode intValue];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
                                                      message:mensajeAlerta
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    if (code <0) {
        
        
        [self Animacion:2];
        
        [message show];
        
    }
    else if (code == 0){
        
        mensajeAlerta = @"El usuario no tiene unidades asignadas";
        [message show];
    }
    else{
        

        
        [self Animacion:2];
     /*   [table reloadData];*/
        
        //Aqui mando a llamar a la misma pantalla
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
    
    
    
    
    
    
}

-(void)Animacion:(int)Code{
    
    if (Code==1) {
        table.userInteractionEnabled = NO;
        btn_actualizar.enabled = NO;
        btn_menu.enabled = NO;
        if (utilizar_animacion) {
            actividad.hidesWhenStopped = TRUE;
            [actividad startAnimating];
        }
    }
    else {
        table.userInteractionEnabled = YES;
        btn_actualizar.enabled = YES;
        btn_menu.enabled = YES;
        utilizar_animacion = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
        
    }
    
}


//xml




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [array_menu count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"TableCell";
    TableCellResumen *cell;
    
    cell = (TableCellResumen *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSString* NibName = @"TableCellResumen";
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            NibName = @"TableCellResumen_iPad";
        }
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
    }
    
    cell.lbl_menu.text = [array_menu objectAtIndex:indexPath.row];
    cell.img_menu.image = [UIImage imageNamed:[array_menu_img objectAtIndex:indexPath.row]];

    return cell;

    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == 0) {
        
        [self ShowMenu:self];
        
    }
    
    if (indexPath.row == 1) {
        
        [contadorTimer invalidate];
        contadorTimer = nil;
        NSString* view_name = @"Unidades";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Unidades_iPhone5";
        }
        else{
            view_name = @"Unidades_iPad";
        }
        
        
        Unidades *view = [[Unidades alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];

        
    }
    
    if (indexPath.row == 2) {
        
        [contadorTimer invalidate];
        contadorTimer = nil;
        NSString* view_name = @"Ayuda";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Ayuda_iPhone5";
        }
        else{
            view_name = @"Ayuda_iPad";
        }
        
        
        Ayuda *view = [[Ayuda alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];

        
    }
    
    if (indexPath.row == 3) {
        [contadorTimer invalidate];
        contadorTimer = nil;
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
    if (indexPath.row == 4) {
        [contadorTimer invalidate];
        contadorTimer = nil;
        NSString* view_name = @"Login";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Login_iPhone5";
        }
        else{
            view_name = @"Login_iPad";
        }
        
        MArrayFlota = [[NSMutableArray alloc]init];
        MArrayEco = [[NSMutableArray alloc]init];
        MArrayID = [[NSMutableArray alloc]init];
        MArrayIP = [[NSMutableArray alloc]init];
        MArrayLatitud = [[NSMutableArray alloc]init];
        MArrayLongitud = [[NSMutableArray alloc]init];
        MArrayAngulo = [[NSMutableArray alloc]init];
        MArrayVelocidad = [[NSMutableArray alloc]init];
        MArrayFecha = [[NSMutableArray alloc]init];
        MArrayEvento = [[NSMutableArray alloc]init];
        MArrayEstatus = [[NSMutableArray alloc]init];
        MArrayIcono = [[NSMutableArray alloc]init];
        MArrayUbicacion = [[NSMutableArray alloc]init];
        MArrayMotor = [[NSMutableArray alloc]init];
        MArrayTelefono = [[NSMutableArray alloc]init];
        MArrayMensajes = [[NSMutableArray alloc]init];
        MArrayIcono_Mapa = [[NSMutableArray alloc]init];
        
        
        Login *view = [[Login alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
        //Aqui tengo que poner de cerrar sesión
        
        /*   NSArray *paths = NSSearchPathForDirectoriesInDomains
         (NSDocumentDirectory, NSUserDomainMask, YES);
         NSString* documentsDirectory = [paths objectAtIndex:0];
         NSString* fileName = [NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory];
         NSString* DataMobileUser = @"Error";
         [DataMobileUser writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];*/
        
        
    }
    
    
    
    return indexPath;
    
}


-(IBAction)ShowMenu:(id)sender{
  
    if (Show) {
        
        Show = NO;
        CGRect frame = btn_menu.frame;
        frame.origin.x = -300;
        
        CGRect frame_tbl_menu = tbl_menu.frame;
        frame_tbl_menu.origin.x = -300;
        
        CGRect frame_img_titulo= img_titulo.frame;
        frame_img_titulo.origin.x = -300;
        
        
        CGRect frame_panel = panel.frame;
        frame_panel.origin.x = 0;
        
        table.userInteractionEnabled = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            frame.origin.x = -270;
            frame_tbl_menu.origin.x = -653;
            frame_img_titulo.origin.x = -653;
            frame_panel.origin.x = 0;
        }

        
        
        [UIView beginAnimations:Nil context:nil];
        [UIView setAnimationDuration:0.9];
        btn_menu.frame = frame;
        tbl_menu.frame = frame_tbl_menu;
        img_titulo.frame = frame_img_titulo;
        panel.frame = frame_panel;
        [UIView commitAnimations];
        
    }
    else{
        
        Show = YES;
        CGRect frame = btn_menu.frame;
        CGRect frame_tbl_menu = tbl_menu.frame;
        CGRect frame_img_titulo= img_titulo.frame;
        CGRect frame_panel = panel.frame;
        
        table.userInteractionEnabled = NO;


        
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            frame.origin.x = 280;
            frame_img_titulo.origin.x = 12;
            frame_tbl_menu.origin.x = 0;
            frame_panel.origin.x = 280;
        }
        else{
            

            frame_panel.origin.x = 700;
            frame.origin.x = 700;
            frame_img_titulo.origin.x = 100;
            
            frame_tbl_menu.origin.x = 10;
        }
        
        
       
        
        
        [UIView beginAnimations:Nil context:nil];
        [UIView setAnimationDuration:0.9];
        btn_menu.frame = frame;
        img_titulo.frame = frame_img_titulo;
        tbl_menu.frame = frame_tbl_menu;
        panel.frame = frame_panel;
        [UIView commitAnimations];

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
