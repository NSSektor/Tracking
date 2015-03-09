//
//  Detalle_iOS.m
//  Tracking
//
//  Created by Angel Rivas on 24/02/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Detalle_iOS.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Annotation.h"
#import "Detalle.h"
#import "Unidades.h"
#import "Incidencias.h"
#import "Reachability.h"
#import "StreetView.h"
#import "Historico.h"

BOOL reachable;
BOOL cancelar;
extern NSString* detalle_unidad;
extern NSString* latitud_unidad;
extern NSString* longitud_unidad;
extern NSString* angulo_unidad;
extern NSString* GlobalString;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* limite_velocidad;
NSString*imagenunidad;
extern NSString* IP_unidad;
BOOL dame_incidencia;
extern NSMutableArray* descripcion_incidencias;
float Zoom = 15;

extern NSMutableArray* array_detalle_unidad;
BOOL cabina;
NSString* telefono;
extern NSString* ocultar;

@interface Detalle_iOS (){
    SYSoapTool *soapTool;
    NSArray* Arreglo_menu;
    NSMutableArray* Arreglo_menu_tem;
    UIActionSheet *actionSheet;

}

@property (nonatomic, strong) UIActivityViewController *activityViewController;

@end

@implementation Detalle_iOS

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

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    if (cancelar==NO) {
        [self Mensaje];
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
    // Do any additional setup after loading the view from its nib.
    
    mapView.mapType = kGMSTypeNormal;
  

    dame_incidencia = false;
    cancelar = NO;
    IP_unidad = @"";
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    detalle_unidad = [array_detalle_unidad objectAtIndex:1];
    detalle_unidad = [detalle_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    lbl_titulo.text = detalle_unidad;
    IP_unidad = [array_detalle_unidad objectAtIndex:3];
    IP_unidad = [IP_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger mensajes = [[[array_detalle_unidad objectAtIndex:15]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    
    
    if (mensajes==0) {
       // [_btn_mensajes setImage:[UIImage imageNamed:@"sin_mensajes.png"] forState:UIControlStateNormal];
    }
    NSString* telefono = [array_detalle_unidad objectAtIndex:14];
    telefono = [telefono stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    imagenunidad = [array_detalle_unidad objectAtIndex:16];
    imagenunidad = [imagenunidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    latitud_unidad = [latitud_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    longitud_unidad = [longitud_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[latitud_unidad doubleValue]
                                                            longitude:[longitud_unidad doubleValue]
                                                                 zoom:Zoom];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    

    CGRect frame_alerta;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height < 481.0f) {
            /*Do iPhone 5 stuff here.*/
            //vista secundaria
            frame_alerta = CGRectMake(26, 226, 268, 115);
 
        }
        else{
            frame_alerta = CGRectMake(26, 182, 268, 115);
        }
    } else {
        /*Do iPad stuff here.*/
        frame_alerta = CGRectMake(250, 444, 268, 115);
    }
    
    mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, panel_mapa.frame.size.width, panel_mapa.frame.size.height) camera:camera];

    
    mapView.delegate = self;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([latitud_unidad doubleValue], [longitud_unidad doubleValue]);
    marker.icon = [UIImage imageNamed:imagenunidad];
    marker.map = mapView;
    
    [panel_mapa addSubview:mapView];
    
    //vista secundaria
    alerta = [[UIView alloc]initWithFrame:frame_alerta];
    alerta.backgroundColor = [UIColor whiteColor];
    alerta.hidden = YES;
    [self.view addSubview:alerta];
    actividad = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    //  CGFloat colors[4] = {3, 2, 2, 0,1}; // CMYK+Alpha
    // CGColorRef cgColor = CGColorCreate(CGColorSpaceCreateDeviceCMYK(), colors);
    actividad.color = [UIColor orangeColor];
    actividad.center = CGPointMake(50, 40);
    [actividad startAnimating];
    [alerta addSubview: actividad];
    
    alerta_cancelar = [[UIButton alloc]initWithFrame:CGRectMake(20, 65, 228, 30)];
    [alerta_cancelar setTitle: @"Cancelar" forState: UIControlStateNormal];
    [alerta_cancelar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
   // [alerta_cancelar setBackgroundColor:[UIColor colorWithRed:(240/255.0) green:(240/255.0) blue:(240/255.0) alpha:1]];
    [alerta_cancelar setBackgroundColor:[UIColor orangeColor]];
    
    [alerta_cancelar addTarget:self
                    action:@selector(cancelar_actualizacion:)
          forControlEvents:UIControlEventTouchUpInside];
    [alerta addSubview:alerta_cancelar];
    
    lbl_alerta = [[UILabel alloc]initWithFrame:CGRectMake(62, 20, 189, 52)];
    lbl_alerta.text = @"Enviando solicitud de posición...";
    lbl_alerta.numberOfLines = 2;
    lbl_alerta.textColor = [UIColor orangeColor];
    lbl_alerta.textAlignment = NSTextAlignmentCenter;
    [alerta addSubview:lbl_alerta];
    
    if ([telefono length] !=10) {
        Arreglo_menu = [NSArray arrayWithObjects: @"Pedir posición", @"Histórico", @"Generar incidencia",@"Compartir posición", nil];
    }
    else{
        Arreglo_menu = [NSArray arrayWithObjects: @"Pedir posición", @"Histórico", @"Llamar a cabina", @"Generar incidencia",@"Compartir posición", nil];
        cabina = YES;
    }
    
    Arreglo_menu_tem = [[NSMutableArray alloc]init];
    actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                              delegate: self
                                     cancelButtonTitle: nil
                                destructiveButtonTitle: nil
                                     otherButtonTitles: nil];
    
    NSInteger ocultar_int = [ocultar integerValue];
    for (int i=0; i<[Arreglo_menu count]; i++) {
        if (ocultar_int!=i) {
            [actionSheet addButtonWithTitle:[Arreglo_menu objectAtIndex:i]];
            [Arreglo_menu_tem addObject:[Arreglo_menu objectAtIndex:i]];
        }
    }
    [actionSheet addButtonWithTitle:@"Cancelar"];
}

-(IBAction)ShowMenu:(id)sender{
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex  < [Arreglo_menu_tem count]) {
        NSString* funcion = [Arreglo_menu_tem objectAtIndex:buttonIndex];
        if ([funcion isEqualToString:@"Pedir posición"])
            [self actualizar:self];
        else if ([funcion isEqualToString:@"Histórico"]){
            NSString* view_name = @"Historico";
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (screenSize.height > 480.0f)
                    view_name = @"Historico_iPhone5";
            }
            else{
                view_name = @"Historico_iPad";
            }
            
            
            Historico *view = [[Historico alloc] initWithNibName:view_name bundle:nil];
            view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:view animated:YES completion:nil];
        }
        else if ([funcion isEqualToString:@"Llamar a cabina"])
            [self cabina:self];
        else if ([funcion isEqualToString:@"Generar incidencia"])
            [self incidencias:self];
        else if ([funcion isEqualToString:@"Compartir posición"])
            [self compartir:self];
        
    }
    
}



-(IBAction)ZoomIn:(id)sender{
    Zoom = Zoom + 1;
    [mapView animateToZoom:Zoom];
    
    NSString* temporal = [NSString stringWithFormat:@"%@",latitud_unidad];
     NSString* temporal1 = [NSString stringWithFormat:@"%@",longitud_unidad];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([temporal doubleValue], [temporal1 doubleValue]);
    [mapView animateToLocation:coordinate];
    
    //animateToLocation
}

-(IBAction)ZoomOut:(id)sender{
        Zoom = Zoom - 1;
    [mapView animateToZoom:Zoom];
    NSString* temporal = [NSString stringWithFormat:@"%@",latitud_unidad];
    NSString* temporal1 = [NSString stringWithFormat:@"%@",longitud_unidad];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([temporal doubleValue], [temporal1 doubleValue]);
    [mapView animateToLocation:coordinate];
}

//MapView

-(UIView*)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker{
 
    Annotation* annotation;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
      annotation = [[[NSBundle mainBundle]loadNibNamed:@"AnnotationView" owner:self options:nil ]objectAtIndex:0];
    } else {
        /*Do iPad stuff here.*/
        annotation = [[[NSBundle mainBundle]loadNibNamed:@"AnnotationView" owner:self options:nil ]objectAtIndex:1];
    }
    

    annotation.backgroundColor = [UIColor colorWithRed:.0001 green:.0001 blue:.0001 alpha:.0001];
    NSString* i_motor = [array_detalle_unidad objectAtIndex:13];
    
    i_motor = [i_motor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([i_motor isEqualToString:@"ON"]) {
        annotation.img_motor.image = [UIImage imageNamed:@"motor_on.png"];
    }
    else if ([i_motor isEqualToString:@"OFF"]) {
        annotation.img_motor.image = [UIImage imageNamed:@"motor_off.png"];
    }
    else{
        annotation.img_motor.image = [UIImage imageNamed:@"sin_motor.png"];
    }
    annotation.lbl_eco.text = [[array_detalle_unidad objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    annotation.lbl_evento.text = [[array_detalle_unidad objectAtIndex:9]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    annotation.lbl_fecha.text = [[array_detalle_unidad objectAtIndex:8]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    annotation.lbl_ubicacion.text = [[array_detalle_unidad objectAtIndex:12]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* velocidad = [[array_detalle_unidad objectAtIndex:7]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    velocidad = [velocidad stringByAppendingString:@" km/h"];
    annotation.lbl_velocidad.text = velocidad;
    annotation.img_icono.image = [UIImage imageNamed:[[array_detalle_unidad objectAtIndex:11]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    annotation.img_angulo.image = [UIImage imageNamed:[[array_detalle_unidad objectAtIndex:6]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];


    return annotation;
    
    
}

- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    StreetView *view = [[StreetView alloc] initWithNibName:@"StreetView" bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
}



//MapView

-(IBAction)setMap:(id)sender{
    
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    {
        case 0:{
            mapView.mapType = kGMSTypeNormal;
        }
            break;
        case 1:{
            mapView.mapType = kGMSTypeSatellite;
        }
            
            break;
        case 2:{
            mapView.mapType = kGMSTypeHybrid;
        }
            break;
        case 3:
            mapView.mapType = kGMSTypeTerrain;
            break;
        default:
            break;
    }
}

//Compartir

-(IBAction)compartir:(id)sender
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[capturedScreen]
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
    
//    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[capturedScreen] applicationActivities:nil];
 //   [self presentViewController:self.activityViewController animated:YES completion:nil];
}

//Compartir


//Actualizar

-(IBAction)actualizar:(id)sender{
    cancelar = NO;
    [self Animacion:1];
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"identificador_unidad", @"comando", @"velocidad", nil];
    
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, IP_unidad, @"gps_now", limite_velocidad, nil];
    
    
    
    [soapTool callSoapServiceWithParameters__functionName:@"SendCommand" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];
}

-(IBAction)cancelar_actualizacion:(id)sender{
    cancelar = YES;
    [self Animacion:2];
}

-(void)Mensaje{
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:SendCommandResponse xmlns:ns1=\"http://tempuri.org/\"><return xsi:type=\"xsd:string\">" withString:@""];
    
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"</return></ns1:SendCommandResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>" withString:@""];
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:DameIncidenciasResponse xmlns:ns1=\"http://tempuri.org/\"><return xsi:type=\"xsd:string\">" withString:@""];
    
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"</return></ns1:DameIncidenciasResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>" withString:@""];
    
    
    
    
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

-(void)Animacion:(int)Code{

   
    if (Code==1) {
        
        btn_atras.enabled = NO;
        btn_menu.enabled = NO;
        //actividad.hidesWhenStopped = TRUE;
        
        //[actividad startAnimating];
        alerta.hidden = NO;
        

        
    }
    
    else {
        
        btn_atras.enabled = YES;
        btn_menu.enabled = YES;
        alerta.hidden = YES;
        
   //     [actividad stopAnimating];
        
     //   [actividad hidesWhenStopped];
        
        
        
        
    }
    
    
    
}




//xml

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    
    NSLog(@"The XML document is now being parsed.");
    if (dame_incidencia==false) {
            array_detalle_unidad = [[NSMutableArray alloc]init];
    }

}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSLog(@"Parse error: %ld", (long)[parseError code]);
    
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
    
    if ([elementName isEqualToString:@"Latitud"]) {
        
        latitud_unidad = currentElementString;
        
    }
    
    if ([elementName isEqualToString:@"Longitud"]) {
        
        longitud_unidad = currentElementString;
        
    }
    
    if ([elementName isEqualToString:@"Angulo"]) {
        
        angulo_unidad = currentElementString;
        
    }
    
    if ([elementName isEqualToString:@"Flota"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Eco"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"ID"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"IP"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Latitud"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Longitud"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Angulo"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Velocidad"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Fecha"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Evento"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Estatus"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Icono"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Ubicacion"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Motor"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Telefono"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Mensajes"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"Icono_mapa"]) {
        [array_detalle_unidad addObject:currentElementString];
    }
    
    if ([elementName isEqualToString:@"descripcion"]) {
        [descripcion_incidencias addObject:currentElementString];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    
    [self Animacion:2];
    
    if (dame_incidencia) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString* documentsDirectory = [paths objectAtIndex:0];
        NSString* fileName = [NSString stringWithFormat:@"%@/Incidencias.txt", documentsDirectory];
        [descripcion_incidencias writeToFile:fileName atomically:NO ];
        NSString* view_name = @"Incidencias";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Incidencias_Iphone5";
        }
        else{
            view_name = @"Incidencias_iPad";
        }
        
        Incidencias *view = [[Incidencias alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }
    else{
        NSString* view_name = @"Detalle_iOS";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Detalle_iOS_iPhone5";
        }
        else{
            view_name = @"Detalle_iOS_iPad";
        }
        
        
        Detalle_iOS *view = [[Detalle_iOS alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:NO completion:nil];
    }
  
}

-(IBAction)Unidades:(id)sender{
    
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

-(IBAction)cabina:(id)sender{
    
    
    UIDevice *device = [UIDevice currentDevice];
    
    if ([[device model] isEqualToString:@"iPhone"] ) {
        
        UIAlertView *permitted=[[UIAlertView alloc] initWithTitle:@"Tracking" message:@"Para realizar la llamada a cabina es necesario que su unidad cuente con un kit de audio.Esta llamada generá cargos adicionales en la renta mensual del servicio de monitoreo de su GPS. ¿Desea realizarla?" delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:@"Cancelar",nil];
        
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
            NSString* tel = @"tel:";
            tel = [tel stringByAppendingString:[array_detalle_unidad objectAtIndex:14]];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
            
        }
    }
    else{
        if (buttonIndex==0) {
        
            [self Animacion:2];
            cancelar = YES;
            
        }
    }
    
}


-(IBAction)incidencias:(id)sender{
    
    if (reachable) {
        dame_incidencia = true;
        descripcion_incidencias = [[NSMutableArray alloc]init];
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", nil];
        
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, nil];
        
        
        
        [soapTool callSoapServiceWithParameters__functionName:@"DameIncidencias" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];
    }
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
