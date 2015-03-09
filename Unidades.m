//
//  Unidades.m
//  Tracking
//
//  Created by Angel Rivas on 29/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import "Unidades.h"
#import "Resumen.h"
#import "Detalle.h"
#import "SimpleTableCell.h"
#import "Reachability.h"
#import "Detalle_iOS.h"



BOOL Show;

extern BOOL mostrar_street;
extern NSString* tiempo_unidad_ociosa;
NSString* detalle_unidad;
NSString* latitud_unidad;
NSString* longitud_unidad;
NSString* angulo_unidad;
extern NSString* busqueda;
NSString* GlobalUsu;

NSString* Globalpass;

BOOL reachable;


extern NSString* texto_busqueda;

extern NSString* mapas;

extern NSIndexPath* index_seleccionado;
extern NSString* limite_velocidad;

//ARRAY

//ARRAY

extern NSString* GlobalString;

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

NSMutableArray* ArrayNombreFlotas;
NSMutableArray * ArregloFLotas;
NSMutableArray* ArrayNombreFlotasSearch;
NSMutableArray * ArregloFLotasSearch;

//ARRAY

extern NSString* filtro;

NSMutableArray* alGrupos;

NSMutableArray* array_detalle_unidad;

extern NSString* ocultar;

@interface Unidades (){
    
    SYSoapTool *soapTool;
    
}


@end



@implementation Unidades

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
    mostrar_street = NO;
    
      contadorTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(actualizarxtimer2:) userInfo:nil repeats:YES];
    soapTool = [[SYSoapTool alloc]init];
    
    soapTool.delegate = self;
    
    
    // Do any additional setup after loading the view from its nib.
    self->searchBar.autocorrectionType = NO;

       NSMutableArray* arreglo_arreglounidades = [[NSMutableArray alloc]init];
    ArrayNombreFlotas = [[NSMutableArray alloc]init];
    ArregloFLotas = [[NSMutableArray alloc]init];
    ArrayNombreFlotasSearch = [[NSMutableArray alloc]init];
    ArregloFLotasSearch = [[NSMutableArray alloc]init];
    NSUInteger iIndex_grupo=-1;
    
    for (int i = 0; i < [MArrayID count]; i++) {
        
        NSMutableArray* arreglo_unidad = [[NSMutableArray alloc]init];
        //= [dirtyString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [arreglo_unidad addObject:[[MArrayFlota objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayEco objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayID objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayIP objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayLatitud objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayLongitud objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayAngulo objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayVelocidad objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayFecha objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayEvento objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayEstatus objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayIcono objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayUbicacion objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayMotor objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayTelefono objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayMensajes objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [arreglo_unidad addObject:[[MArrayIcono_Mapa objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
 
        if ([filtro isEqualToString:[[MArrayEstatus objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]] || [filtro isEqualToString:@"TODAS"]) {
            
            //iIndex_grupo=alGrupos.indexOf(sGrupo.trim());
            NSString* stringenIndex = [[MArrayFlota objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            iIndex_grupo = [ArrayNombreFlotas indexOfObject:stringenIndex];
            //si el grupo no exsite lo creo
            if (iIndex_grupo == NSNotFound) {
                [ArrayNombreFlotas addObject:[[MArrayFlota objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                [ArrayNombreFlotasSearch addObject:[[MArrayFlota objectAtIndex:i]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                iIndex_grupo=[ArregloFLotas count]-1;
            }
            //si el arreglo de grupos= al de flotas
            if([ArregloFLotas count]==[ArrayNombreFlotas count]){
                
                [[ArregloFLotas objectAtIndex:iIndex_grupo] addObject:arreglo_unidad];
                
            }
            else{
                [arreglo_arreglounidades addObject:arreglo_unidad];
                [ArregloFLotas addObject:arreglo_arreglounidades];
                [ArregloFLotasSearch addObject:arreglo_arreglounidades];
                arreglo_arreglounidades = [[NSMutableArray alloc]init];
            }
            
            
        }//
        
        
        
        
    }
    
    if (![texto_busqueda isEqualToString:@""]) {
        self->searchBar.text = texto_busqueda;
        
        ArrayNombreFlotasSearch = [[NSMutableArray alloc]init];
        ArregloFLotasSearch = [[NSMutableArray alloc]init];
        for (int i = 0; i<[ArrayNombreFlotas count]; i++) {
            

            
            NSMutableArray* temporal = [[NSMutableArray alloc]init];
            temporal = [ArregloFLotas objectAtIndex:i];
            for (int j = 0; j<[temporal count]; j++) {
                //for (int j = 0; j<[temporal count]; j++) {
                NSMutableArray * datos = [[NSMutableArray alloc]init];
                datos = [temporal objectAtIndex:j];
                
                NSRange r = [[datos objectAtIndex:1] rangeOfString: texto_busqueda options:NSCaseInsensitiveSearch];
                NSRange r1 = [[datos objectAtIndex:12] rangeOfString: texto_busqueda options:NSCaseInsensitiveSearch];
                
                
                if (r.length>0 || r1.length>0) {
                    NSInteger iIndex_grupo = -1;
                    NSMutableArray* arreglo_arreglounidades = [[NSMutableArray alloc]init];
                    NSMutableArray* arreglo_unidad = [[NSMutableArray alloc]init];
                    arreglo_unidad = datos;
                    NSString* stringenIndex = [[arreglo_unidad objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    iIndex_grupo = [ArrayNombreFlotasSearch indexOfObject:stringenIndex];
                    //si el grupo no exsite lo creo
                    if (iIndex_grupo == NSNotFound) {
                        [ArrayNombreFlotasSearch addObject:[[arreglo_unidad objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                        iIndex_grupo=[ArregloFLotasSearch count]-1;
                    }
                    //si el arreglo de grupos= al de flotas
                    if([ArregloFLotasSearch count]==[ArrayNombreFlotasSearch count]){
                        
                        [[ArregloFLotasSearch objectAtIndex:iIndex_grupo] addObject:arreglo_unidad];
                        
                    }
                    else{
                        [arreglo_arreglounidades addObject:arreglo_unidad];
                        [ArregloFLotasSearch addObject:arreglo_arreglounidades];
                        arreglo_arreglounidades = [[NSMutableArray alloc]init];
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                //}
                
                
                
            }
            
            
            texto_busqueda = self->searchBar.text;
            
        }
        
    }
    

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        array_menu = [[NSArray alloc]initWithObjects:@"tbl_inicio.png", @"tbl_ayuda.png", @"tcl_configuracion.png", @"tbl_notificaciones.png", @"tbl_cerrar.png", nil ];
    }
    else{
        
        array_menu = [[NSArray alloc]initWithObjects:@"tbl_inicio2.png", @"tbl_ayuda2.png", @"tcl_configuracion2.png", @"tbl_notificaciones2.png", @"tbl_cerrar2.png", nil ];
    }
    
    
    
    
    Show = NO;
    
    [tbl_unidades scrollToRowAtIndexPath:index_seleccionado
                        atScrollPosition:UITableViewScrollPositionBottom
                                animated:YES];
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)actualizarxtimer2:(id)sender{
    
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

-(IBAction)actualizar:(id)sender{
    
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
        
        
        
        
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usVelocidad",@"usMinSinReporte",nil];
        
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, limite_velocidad, tiempo_unidad_ociosa,nil];
        
        
        
        [soapTool callSoapServiceWithParameters__functionName:@"GetPositions" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];
        
    }
    
}



-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    

    [self Mensaje];
    
    
}



-(void)Mensaje{
    
    
    
    StringCode = @"";
    
    StringMsg = @"";
    
    StringCode = @"-10";
    
    StringMsg = @"Error en la conexión";

    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    
    [parser setDelegate:self];
    
    
    
    [parser setShouldProcessNamespaces:NO];
    
    [parser setShouldReportNamespacePrefixes:NO];
    
    [parser setShouldResolveExternalEntities:NO];
    
    [parser parse];
    
  
    
}



//xml

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"The XML document is now being parsed.");
    
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
    
    
    NSInteger code = [StringCode intValue];
    
    
    if (code >0) {
        
        NSString* view_name = @"Unidades";
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            
            if (screenSize.height > 480.0f)
                
                view_name = @"Unidades_iPhone5";
            
        }
        
        else{
            
            view_name = @"Unidades_iPad";
            
        }
        
        texto_busqueda = @"";
        
        Unidades *view = [[Unidades alloc] initWithNibName:view_name bundle:nil];
        
        view.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:view animated:YES completion:nil];
   
        
    }
    
}

//xml



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [ArregloFLotasSearch count];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger retorno = 0;
    
    for (int i = 0; i<[ArrayNombreFlotasSearch count]; i++) {
        
        if (section== i) {
            
            NSMutableArray* temporal = [[NSMutableArray alloc]init];
            temporal = [ArregloFLotasSearch objectAtIndex:i];
            for (int j = 0; j<[temporal count]; j++) {
                return [temporal count];
            }
            
            
        }
        
    }
    
    return retorno;
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	
    NSString* retorno = @"";
    
    for (int i = 0; i<[ArrayNombreFlotasSearch count]; i++) {
        
        if (section== i) {
            
            retorno = [ArrayNombreFlotasSearch objectAtIndex:i];
            
            
        }
        
    }
    return retorno;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TableCell";
    SimpleTableCell *cell;
    
    if (tableView == tbl_unidades) {
        
        
        
        cell = (SimpleTableCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            NSString* NibName = @"SimpleTableCell";
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                NibName = @"TableCell_Ipad";
            }

            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NibName owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.img_motor.image = [UIImage imageNamed:@"motor_off.png"];
        
        for (int i = 0; i<[ArrayNombreFlotasSearch count]; i++) {
            
            if (i == indexPath.section) {
                NSMutableArray* temporal = [[NSMutableArray alloc]init];
                temporal = [ArregloFLotasSearch objectAtIndex:i];
                for (int j = 0; j<[temporal count]; j++) {
                    
                    
                    NSMutableArray * datos = [[NSMutableArray alloc]init];
                    
                    
                    datos = [temporal objectAtIndex:indexPath.row];
                    
                    //cell.textLabel.text = [datos objectAtIndex:1];
                    
                    NSString* i_motor = [datos objectAtIndex:13];
                    
                    if ([i_motor isEqualToString:@"ON"]) {
                        cell.img_motor.image = [UIImage imageNamed:@"motor_on.png"];
                    }
                    else if ([i_motor isEqualToString:@"OFF"]) {
                        cell.img_motor.image = [UIImage imageNamed:@"motor_off.png"];
                    }
                    else{
                        cell.img_motor.image = [UIImage imageNamed:@"sin_motor.png"];
                    }
                    cell.lbl_eco.text = [datos objectAtIndex:1];
                    cell.lbl_evento.text = [datos objectAtIndex:9];
                    cell.lbl_fecha.text = [datos objectAtIndex:8];
                    cell.lbl_ubicacion.text = [datos objectAtIndex:12];
                    NSString* velocidad = [datos objectAtIndex:7];
                    velocidad = [velocidad stringByAppendingString:@" km/h"];
                    cell.lbl_velocidad.text = velocidad;
                    cell.img_icono.image = [UIImage imageNamed:[datos objectAtIndex:11]];
                    cell.img_angulo.image = [UIImage imageNamed:[datos objectAtIndex:6]];
                
                    
                    
                }
            }
            
            
            
        }
       


    }
    


    
    

    
    
   
    
    return cell;

    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    for (int i = 0; i<[ArrayNombreFlotasSearch count]; i++) {
        
        if (i == indexPath.section) {
            NSMutableArray* temporal = [[NSMutableArray alloc]init];
            temporal = [ArregloFLotasSearch objectAtIndex:i];
            array_detalle_unidad = [[NSMutableArray alloc]init];
            
            index_seleccionado = indexPath;
            
            array_detalle_unidad = [temporal objectAtIndex:indexPath.row];
            
            detalle_unidad = [array_detalle_unidad objectAtIndex:1];
            latitud_unidad = [array_detalle_unidad objectAtIndex:4];
            longitud_unidad = [array_detalle_unidad objectAtIndex:5];
            angulo_unidad = [array_detalle_unidad objectAtIndex:6];
            
            [contadorTimer invalidate];
            contadorTimer = nil;
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
        
        
        
    }
    
 	
    
    return indexPath;
    
}


-(IBAction)ShowMenu:(id)sender{
    
    [contadorTimer invalidate];
    contadorTimer = nil;
    
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // This method has been called when u enter some text on search or Cancel the search.
    // so make some condition for example:
    NSString* texto = self->searchBar.text;
    if([searchText isEqualToString:@""] || searchText==nil) {
        
        ArrayNombreFlotasSearch = ArrayNombreFlotas;
        ArregloFLotasSearch = ArregloFLotas;
        texto_busqueda = @"";


        // [self.searchBar resignFirstResponder];
    }
    else {
        
        ArrayNombreFlotasSearch = [[NSMutableArray alloc]init];
        ArregloFLotasSearch = [[NSMutableArray alloc]init];
        
        
        for (int i = 0; i<[ArrayNombreFlotas count]; i++) {
            

            NSMutableArray* temporal = [[NSMutableArray alloc]init];
            temporal = [ArregloFLotas objectAtIndex:i];
            for (int j = 0; j<[temporal count]; j++) {
                //for (int j = 0; j<[temporal count]; j++) {
                NSMutableArray * datos = [[NSMutableArray alloc]init];
                datos = [temporal objectAtIndex:j];
                
                NSRange r = [[datos objectAtIndex:1] rangeOfString: texto options:NSCaseInsensitiveSearch];
                NSRange r1 = [[datos objectAtIndex:12] rangeOfString: texto options:NSCaseInsensitiveSearch];
                BOOL entra_busqueda = NO;
                
                if ([busqueda isEqualToString:@"Ecónomico, Dirección"]) {
                    if (r.length>0 || r1.length>0) {
                        entra_busqueda = YES;
                    }
                }
                else if ([busqueda isEqualToString:@"Ecónomico"]){
                    if (r.length>0) {
                        entra_busqueda = YES;
                    }
                    
                }
                else if ([busqueda isEqualToString:@"Dirección"]){
                    if (r1.length>0) {
                        entra_busqueda = YES;
                    }
                }
                
                
                if (entra_busqueda == YES) {
                    NSInteger iIndex_grupo = -1;
                    NSMutableArray* arreglo_arreglounidades = [[NSMutableArray alloc]init];
                    NSMutableArray* arreglo_unidad = [[NSMutableArray alloc]init];
                    arreglo_unidad = datos;
                    NSString* stringenIndex = [[arreglo_unidad objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    iIndex_grupo = [ArrayNombreFlotasSearch indexOfObject:stringenIndex];
                    //si el grupo no exsite lo creo
                    if (iIndex_grupo == NSNotFound) {
                        [ArrayNombreFlotasSearch addObject:[[arreglo_unidad objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                        iIndex_grupo=[ArregloFLotasSearch count]-1;
                    }
                    //si el arreglo de grupos= al de flotas
                    if([ArregloFLotasSearch count]==[ArrayNombreFlotasSearch count]){
                        
                        [[ArregloFLotasSearch objectAtIndex:iIndex_grupo] addObject:arreglo_unidad];
                        
                    }
                    else{
                        [arreglo_arreglounidades addObject:arreglo_unidad];
                        [ArregloFLotasSearch addObject:arreglo_arreglounidades];
                        arreglo_arreglounidades = [[NSMutableArray alloc]init];
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
                //}
                
                
                
            }
            
            
            texto_busqueda = self->searchBar.text;
            
        }

    }//
   
    [tbl_unidades reloadData];

}



-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self->searchBar.text = @"";
    texto_busqueda = @"";
    ArrayNombreFlotasSearch = ArrayNombreFlotas;
    ArregloFLotasSearch = ArregloFLotas;
    [tbl_unidades reloadData];
    [self->searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    ArrayNombreFlotasSearch = [[NSMutableArray alloc]init];
    ArregloFLotasSearch = [[NSMutableArray alloc]init];
    
    
    for (int i = 0; i<[ArrayNombreFlotas count]; i++) {
        
        
        NSMutableArray* temporal = [[NSMutableArray alloc]init];
        temporal = [ArregloFLotas objectAtIndex:i];
        for (int j = 0; j<[temporal count]; j++) {
            //for (int j = 0; j<[temporal count]; j++) {
            NSMutableArray * datos = [[NSMutableArray alloc]init];
            datos = [temporal objectAtIndex:j];
            
            NSRange r = [[datos objectAtIndex:1] rangeOfString: texto_busqueda options:NSCaseInsensitiveSearch];
            NSRange r1 = [[datos objectAtIndex:12] rangeOfString: texto_busqueda options:NSCaseInsensitiveSearch];
            BOOL entra_busqueda = NO;
            
            if ([busqueda isEqualToString:@"Ecónomico, Dirección"]) {
                if (r.length>0 || r1.length>0) {
                    entra_busqueda = YES;
                }
            }
            else if ([busqueda isEqualToString:@"Ecónomico"]){
                if (r.length>0) {
                    entra_busqueda = YES;
                }
                
            }
            else if ([busqueda isEqualToString:@"Dirección"]){
                if (r1.length>0) {
                    entra_busqueda = YES;
                }
            }
            
            if (entra_busqueda == YES) {
                NSInteger iIndex_grupo = -1;
                NSMutableArray* arreglo_arreglounidades = [[NSMutableArray alloc]init];
                NSMutableArray* arreglo_unidad = [[NSMutableArray alloc]init];
                arreglo_unidad = datos;
                NSString* stringenIndex = [[arreglo_unidad objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                iIndex_grupo = [ArrayNombreFlotasSearch indexOfObject:stringenIndex];
                //si el grupo no exsite lo creo
                if (iIndex_grupo == NSNotFound) {
                    [ArrayNombreFlotasSearch addObject:[[arreglo_unidad objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
                    iIndex_grupo=[ArregloFLotasSearch count]-1;
                }
                //si el arreglo de grupos= al de flotas
                if([ArregloFLotasSearch count]==[ArrayNombreFlotasSearch count]){
                    
                    [[ArregloFLotasSearch objectAtIndex:iIndex_grupo] addObject:arreglo_unidad];
                    
                }
                else{
                    [arreglo_arreglounidades addObject:arreglo_unidad];
                    [ArregloFLotasSearch addObject:arreglo_arreglounidades];
                    arreglo_arreglounidades = [[NSMutableArray alloc]init];
                }
                
                
                
                
                
                
            }
            
        }
        
        
        texto_busqueda = self->searchBar.text;
        
    }

    [tbl_unidades reloadData];
    
    [self->searchBar resignFirstResponder];
}


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}


@end
