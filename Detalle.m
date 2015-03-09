//
//  Detalle.m
//  Tracking
//
//  Created by Angel Rivas on 22/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import "Detalle.h"
#import "Unidades.h"
#import "Incidencias.h"
#import "BasicMapAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CalloutMapAnnotationView.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "SimpleTableCell.h"
#import "Reachability.h"
#import "StreetView.h"
#import "Annotation.h"
#import "Historico.h"

BOOL reachable;
BOOL cancelar;
extern BOOL mostrar_street;

BOOL mostrar_annotation;

 SimpleTableCell  *cell;

Annotation* annotation;

extern NSString* detalle_unidad;
extern NSString* latitud_unidad;
extern NSString* longitud_unidad;
extern NSString* angulo_unidad;
extern NSString* limite_velocidad;

NSString*imagenunidad;

extern NSString* IP_unidad;


extern NSString* GlobalString;
extern NSString* GlobalUsu;
extern NSString* Globalpass;


extern NSMutableArray* array_detalle_unidad;

BOOL dame_incidencia;
extern NSMutableArray* descripcion_incidencias;
BOOL cabina;
NSString* telefono;
extern NSString* ocultar;
@interface Detalle(){
    SYSoapTool *soapTool;
    NSArray* Arreglo_menu;
    NSMutableArray* Arreglo_menu_tem;
    UIActionSheet *actionSheet;
}


@property (nonatomic, strong) UIActivityViewController *activityViewController;
@end


@implementation Detalle



@synthesize mapView = _mapView;
@synthesize selectedAnnotationView = _selectedAnnotationView;


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
    dame_incidencia = false;
    IP_unidad = @"";
    actividad.hidden = YES;
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    detalle_unidad = [array_detalle_unidad objectAtIndex:1];
    detalle_unidad = [detalle_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _lbl_titulo.text = detalle_unidad;
    
    IP_unidad = [array_detalle_unidad objectAtIndex:3];
    IP_unidad = [IP_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger mensajes = [[[array_detalle_unidad objectAtIndex:15]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] intValue];
    
    cabina = FALSE;
    
    if (mensajes==0) {
        [_btn_mensajes setImage:[UIImage imageNamed:@"sin_mensajes.png"] forState:UIControlStateNormal];
    }
    telefono = [array_detalle_unidad objectAtIndex:14];
    telefono = [telefono stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    imagenunidad = [array_detalle_unidad objectAtIndex:16];
    imagenunidad = [imagenunidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    latitud_unidad = [latitud_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    longitud_unidad = [longitud_unidad stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    double latdouble = [latitud_unidad doubleValue];
    double londouble = [longitud_unidad doubleValue];
    
    self.customAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:latdouble andLongitude:londouble];
	[self.mapView addAnnotation:self.customAnnotation];
    
 //   self.normalAnnotation = [[BasicMapAnnotation alloc] initWithLatitude:latdouble andLongitude:londouble];
//	[self.mapView addAnnotation:self.normalAnnotation];
    
    mostrar_annotation = YES;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame_alerta;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height < 480.0f) {
            /*Do iPhone 5 stuff here.*/

            //vista secundaria
            frame_alerta = CGRectMake(26, 226, 268, 115);
            
        }
        else{
            //vista secundaria
            frame_alerta = CGRectMake(26, 182, 268, 115);
        }
    } else {
        /*Do iPad stuff here.*/
        //vista secundaria
        frame_alerta = CGRectMake(250, 444, 268, 115);
    }
    
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

-(void)viewDidAppear:(BOOL)animated{
    CLLocationCoordinate2D location;
    location.latitude  = [latitud_unidad doubleValue];
    location.longitude = [longitud_unidad doubleValue];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location, 1800, 1800);
    [_mapView setRegion:region animated:YES];
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
    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[capturedScreen] applicationActivities:nil];
    [self presentViewController:self.activityViewController animated:YES completion:nil];
}

//Compartir


//Actualizar

-(IBAction)actualizar:(id)sender{
       [self Animacion:1];
    cancelar = NO;
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"identificador_unidad", @"comando", @"velocidad", nil];
    
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, IP_unidad, @"gps_now", limite_velocidad,nil];
    
    
    
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
        alerta.hidden = NO;
        
        
       // actividad.hidesWhenStopped = TRUE;
        
       // [actividad startAnimating];
        
        
        
    }
    
    else {
        
        btn_atras.enabled = YES;
        btn_menu.enabled = YES;
        btn_actualizar.enabled = YES;
        alerta.hidden = YES;
        
      //  [actividad stopAnimating];
        
      //  [actividad hidesWhenStopped];
        
        
        
    }
    
    
    
}

-(IBAction)setMap:(id)sender{
    
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    {
        case 0:{
            _mapView.mapType = MKMapTypeStandard;
        }
            break;
        case 1:{
            _mapView.mapType = MKMapTypeSatellite;
        }
            
            break;
        case 2:{
            _mapView.mapType = MKMapTypeHybrid;
        }
            break;
        default:
            break;
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
        NSString* view_name = @"Detalle";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f)
                view_name = @"Detalle_iPhone5";
        }
        else{
            view_name = @"Detalle_iPad";
        }
        
        
        Detalle *view = [[Detalle alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:NO completion:nil];
    }
    
}

/*

// When a map annotation point is added, zoom to it (1500 range)
- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    MKAnnotationView *annotationView = [views objectAtIndex:0];
    annotationView.image = [UIImage imageNamed:imagenunidad];

    
    
    NSString* nimName = @"SimpleTableCell";
   
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        nimName = @"TableCell_Ipad";
        
    }
    
    SimpleTableCell  *cell = [[[NSBundle mainBundle] loadNibNamed:nimName owner:self options:nil] objectAtIndex:1];
    NSString* i_motor = [array_detalle_unidad objectAtIndex:13];
    
    i_motor = [i_motor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([i_motor isEqualToString:@"ON"]) {
        cell.img_motor.image = [UIImage imageNamed:@"motor_on.png"];
    }
    else if ([i_motor isEqualToString:@"OFF"]) {
        cell.img_motor.image = [UIImage imageNamed:@"motor_off.png"];
    }
    else{
        cell.img_motor.image = [UIImage imageNamed:@"sin_motor.png"];
    }
    cell.lbl_eco.text = [[array_detalle_unidad objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.lbl_evento.text = [[array_detalle_unidad objectAtIndex:9]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.lbl_fecha.text = [[array_detalle_unidad objectAtIndex:8]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.lbl_ubicacion.text = [[array_detalle_unidad objectAtIndex:12]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* velocidad = [[array_detalle_unidad objectAtIndex:7]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    velocidad = [velocidad stringByAppendingString:@" km/h"];
    cell.lbl_velocidad.text = velocidad;
    cell.img_icono.image = [UIImage imageNamed:[[array_detalle_unidad objectAtIndex:11]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
   
    annotationView.leftCalloutAccessoryView = cell;
    
    

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(0, 0, 35, 35);
    [button setBackgroundImage:[UIImage imageNamed:@"street.png"] forState:UIControlStateNormal];
    
    annotationView.rightCalloutAccessoryView = button;
    
    
    
    
    annotationView.canShowCallout = YES;
    id <MKAnnotation> mp = [annotationView annotation];
	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1600, 1600);
	[mv setRegion:region animated:YES];
	[mv selectAnnotation:mp animated:YES];

    
}*/

//

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
	if (view.annotation == self.customAnnotation) {
		if (self.calloutAnnotation == nil) {
			self.calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
																	   andLongitude:view.annotation.coordinate.longitude];
		} else {
			self.calloutAnnotation.latitude = view.annotation.coordinate.latitude;
			self.calloutAnnotation.longitude = view.annotation.coordinate.longitude;
		}
		[self.mapView addAnnotation:self.calloutAnnotation];
		self.selectedAnnotationView = view;
	}
}



- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
	if (self.calloutAnnotation && view.annotation == self.customAnnotation) {
		[self.mapView removeAnnotation: self.calloutAnnotation];
	}
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	if (annotation == self.calloutAnnotation) {
		CalloutMapAnnotationView *calloutMapAnnotationView = (CalloutMapAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:@"CalloutAnnotation"];
        calloutMapAnnotationView.tintColor = [UIColor blueColor];
        
		if (!calloutMapAnnotationView) {
			calloutMapAnnotationView = [[CalloutMapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CalloutAnnotation"];

            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil] objectAtIndex:2];
                [calloutMapAnnotationView.contentView addSubview:cell];
                calloutMapAnnotationView.contentHeight = 190;
                calloutMapAnnotationView.contentWidth= 460;
             
            }
            else{
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SimpleTableCell" owner:self options:nil] objectAtIndex:1];
                [calloutMapAnnotationView.contentView addSubview:cell];
                calloutMapAnnotationView.contentHeight = 130;
                calloutMapAnnotationView.contentWidth= 310;
                
            }
            
            NSString* i_motor = [array_detalle_unidad objectAtIndex:13];
            
            i_motor = [i_motor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            if ([i_motor isEqualToString:@"ON"]) {
                cell.img_motor.image = [UIImage imageNamed:@"motor_on.png"];
            }
            else if ([i_motor isEqualToString:@"OFF"]) {
                cell.img_motor.image = [UIImage imageNamed:@"motor_off.png"];
            }
            else{
                cell.img_motor.image = [UIImage imageNamed:@"sin_motor.png"];
            }
            cell.lbl_eco.text = [[array_detalle_unidad objectAtIndex:1]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.lbl_evento.text = [[array_detalle_unidad objectAtIndex:9]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.lbl_fecha.text = [[array_detalle_unidad objectAtIndex:8]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            cell.lbl_ubicacion.text = [[array_detalle_unidad objectAtIndex:12]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString* velocidad = [[array_detalle_unidad objectAtIndex:7]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            velocidad = [velocidad stringByAppendingString:@" km/h"];
            cell.lbl_velocidad.text = velocidad;
            cell.img_icono.image = [UIImage imageNamed:[[array_detalle_unidad objectAtIndex:11]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            cell.img_angulo.image = [UIImage imageNamed:[[array_detalle_unidad objectAtIndex:6]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
            
           [cell.street addTarget:self
                            action:@selector(GoToStreetView:)
                  forControlEvents:UIControlEventTouchUpInside];
          
		}
        
        calloutMapAnnotationView.parentAnnotationView = self.selectedAnnotationView;
        calloutMapAnnotationView.tintColor =[UIColor greenColor];
        calloutMapAnnotationView.image = [UIImage imageNamed:imagenunidad];
        
        


		calloutMapAnnotationView.mapView = self.mapView;
		return calloutMapAnnotationView;
	}

	
	
	return nil;
}


-(IBAction)GoToStreetView:(id)sender{
    StreetView *view = [[StreetView alloc] initWithNibName:@"StreetView" bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
