//
//  Historico.m
//  Tracking
//
//  Created by Angel Rivas on 6/19/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

#import "Historico.h"
#import "SimpleTableCell.h"
#import "Detalle.h"
#import "Detalle_iOS.h"
#import "Annotation.h"

extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* limite_velocidad;
extern NSString* IP_unidad;
extern NSString* GlobalString;
extern NSString* mapas;
extern NSString* latitud_unidad;
extern NSString* longitud_unidad;

NSMutableArray* MAids;
NSMutableArray* MArrayFlota_h;
NSMutableArray* MArrayEco_h;
NSMutableArray* MArrayID_h;
NSMutableArray* MArrayIP_h;
NSMutableArray* MArrayLatitud_h;
NSMutableArray* MArrayLongitud_h;
NSMutableArray* MArrayAngulo_h;
NSMutableArray* MArrayVelocidad_h;
NSMutableArray* MArrayFecha_h;
NSMutableArray* MArrayEvento_h;
NSMutableArray* MArrayEstatus_h;
NSMutableArray* MArrayIcono_h;
NSMutableArray* MArrayUbicacion_h;
NSMutableArray* MArrayMotor_h;
NSMutableArray* MArrayTelefono_h;
NSMutableArray* MArrayMensajes_h;
NSMutableArray* MArrayIcono_mapa_h;
int id_;
float Zoom;
GMSCoordinateBounds* bounds;
@interface Historico (){
    SYSoapTool *soapTool;
    GMSPanoramaView *panoView_;
}


@end

@implementation Historico


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
    NSLog(@"%@", GlobalString);
    MAids = [[NSMutableArray alloc]init];
    MArrayFlota_h = [[NSMutableArray alloc]init];
    MArrayEco_h = [[NSMutableArray alloc]init];
    MArrayID_h = [[NSMutableArray alloc] init];
    MArrayIP_h = [[NSMutableArray alloc]init];
    MArrayLatitud_h = [[NSMutableArray alloc]init];
    MArrayLongitud_h = [[NSMutableArray alloc]init];
    MArrayAngulo_h = [[NSMutableArray alloc]init];
    MArrayVelocidad_h = [[NSMutableArray alloc]init];
    MArrayFecha_h = [[NSMutableArray alloc]init];
    MArrayEvento_h = [[NSMutableArray alloc]init];
    MArrayEstatus_h = [[NSMutableArray alloc]init];
    MArrayIcono_h = [[NSMutableArray alloc]init];
    MArrayUbicacion_h = [[NSMutableArray alloc]init];
    MArrayMotor_h = [[NSMutableArray alloc]init];
    MArrayTelefono_h = [[NSMutableArray alloc]init];
    MArrayMensajes_h = [[NSMutableArray alloc]init];
    MArrayIcono_mapa_h = [[NSMutableArray alloc]init];
    id_ = 0;
    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    if(![parser parse]){
        NSLog(@"Error al parsear");
    }
    
    
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
    if ([elementName isEqualToString:@"response"]) {
        [currentElementData removeAllObjects];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"code"])
        StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"msg"])
        StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"Flota"]){
        [MArrayFlota_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [MAids addObject:[NSString stringWithFormat:@"%d", id_]];
        id_++;
    }
    if ([elementName isEqualToString:@"Eco"])
        [MArrayEco_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"ID"])
        [MArrayID_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"IP"])
        [MArrayIP_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Latitud"])
        [MArrayLatitud_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Longitud"])
        [MArrayLongitud_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Velocidad"])
        [MArrayVelocidad_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Fecha"])
        [MArrayFecha_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Evento"])
        [MArrayEvento_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Estatus"])
        [MArrayEstatus_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Icono"])
        [MArrayIcono_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Ubicacion"])
        [MArrayUbicacion_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Motor"])
        [MArrayMotor_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Mensajes"])
        [MArrayMensajes_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Icono_mapa"])
        [MArrayIcono_mapa_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"Angulo"])
        [MArrayAngulo_h addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    NSString* mensajeAlerta = StringMsg;
    NSInteger code = [StringCode intValue];
    if (code <0) {
        //  [message show];
        [MAids addObject:@""];
        [MArrayFlota_h addObject:@""];
        [MArrayEco_h addObject:@""];
        [MArrayID_h addObject:@""];
        [MArrayIP_h addObject:@""];
        [MArrayLatitud_h addObject:@""];
        [MArrayLongitud_h addObject:@""];
        [MArrayAngulo_h addObject:@""];
        [MArrayVelocidad_h addObject:@""];
        [MArrayFecha_h addObject:@""];
        [MArrayEvento_h addObject:mensajeAlerta];
        [MArrayEstatus_h addObject:@""];
        [MArrayIcono_h addObject:@""];
        [MArrayUbicacion_h addObject:@""];
        [MArrayMotor_h addObject:@""];
        [MArrayTelefono_h addObject:@""];
        [MArrayMensajes_h addObject:@""];
        [MArrayIcono_mapa_h addObject:@""];
    }
    
    bounds = [[GMSCoordinateBounds alloc] init];
    for (int i = 0; i<[MArrayLatitud_h count]; i++) {
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:i] doubleValue], [[MArrayLongitud_h objectAtIndex:i] doubleValue]);
        marker.icon = [UIImage imageNamed:[MArrayIcono_mapa_h objectAtIndex:i]];
        marker.snippet = [MAids objectAtIndex:i];
        //  [MAmarkers addObject:marker];
        marker.map = mapView_;
        CLLocationCoordinate2D circleCenter = CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:i] doubleValue], [[MArrayLongitud_h objectAtIndex:i] doubleValue]);
        if (i==0) {
            bounds =
            [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:0] doubleValue], [[MArrayLongitud_h objectAtIndex:0] doubleValue]) coordinate:CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:0] doubleValue], [[MArrayLongitud_h objectAtIndex:0] doubleValue])];
            
        }
        
        if (i==1) {
            bounds =
            [[GMSCoordinateBounds alloc] initWithCoordinate:CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:0] doubleValue], [[MArrayLongitud_h objectAtIndex:0] doubleValue]) coordinate:CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:i] doubleValue], [[MArrayLongitud_h objectAtIndex:i] doubleValue])];
        }
        else if (i>1)
            [bounds includingCoordinate:circleCenter];
        if ([bounds includingCoordinate:circleCenter]) {
            NSLog(@" Latitud: %f, Longitud: %f ",circleCenter.latitude, circleCenter.longitude );
            NSLog(@"Si la incluyo %d", i);
        }
    }
    
    NSLog(@"final bounds: (%f,%f) - (%f,%f)",
          bounds.southWest.latitude, bounds.southWest.longitude,
          bounds.northEast.latitude, bounds.northEast.longitude);
    
    // [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    [mapView_ moveCamera:[GMSCameraUpdate fitBounds:bounds]];
    
    [self Animacion:2];
    [tbl_historico reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Zoom = 15;
    mapView_.mapType = kGMSTypeNormal;
    CGRect frame;
    /*StreetView*/
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        frame = CGRectMake(0, 20, 320, 40.0);
    else
        frame = CGRectMake(0.0, 20, 768, 60);
    UILabel *scoreLabel = [ [UILabel alloc ] initWithFrame:frame];
    scoreLabel.textAlignment =  NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor orangeColor];
    scoreLabel.numberOfLines = 2;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [scoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    else
        [scoreLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:22.0]];
    scoreLabel.text = @"StreetView";
    [panel_street addSubview:scoreLabel];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            frame = CGRectMake(0, 60, 320, 528);
        else
            frame = CGRectMake(0, 60, 320, 440);
    }
    else
        frame = CGRectMake(0, 80, 768, 954);
    panoView_ = [[GMSPanoramaView alloc] initWithFrame:frame];
    [panel_street addSubview:panoView_];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        frame = CGRectMake(20, 20, 30, 30);
    else
        frame = CGRectMake(20, 20, 50, 50);
    UIButton *btn_cerrar = [ [UIButton alloc ] initWithFrame:frame];
    UIImage *btnImage = [UIImage imageNamed:@"btn_regresa.png"];
    [btn_cerrar setImage:btnImage forState:UIControlStateNormal];
    [btn_cerrar addTarget:self
                   action:@selector(Cerrar:)
         forControlEvents:UIControlEventTouchUpInside];
    [panel_street addSubview:btn_cerrar];
    GMSCameraPosition *camera;
    camera = [GMSCameraPosition cameraWithLatitude:[latitud_unidad doubleValue]
                                         longitude:[longitud_unidad doubleValue]
                                              zoom:Zoom];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, panel_mapa.frame.size.width, panel_mapa.frame.size.height) camera:camera];
    mapView_.delegate = self;
    [panel_mapa addSubview:mapView_];
    steperCode = [[UIStepper alloc] initWithFrame:CGRectMake(panel_mapa.frame.size.width - 104, panel_mapa.frame.size.height - 39, 94, 29)];
    [steperCode addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    Zoom = 15;
    steperCode.minimumValue = 0;
    steperCode.value = 15;
    steperCode.stepValue=1.0;
    steperCode.tintColor = [UIColor darkGrayColor];
    steperCode.backgroundColor = [UIColor whiteColor];
    [panel_mapa addSubview:steperCode];
    NSArray *itemArray = [NSArray arrayWithObjects: @"Normal", @"Híbrido", nil];
    sg_tipo_mapa = [[UISegmentedControl alloc] initWithItems:itemArray];
    sg_tipo_mapa.frame = CGRectMake(10, panel_mapa.frame.size.height - 39 , 100, 30);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        sg_tipo_mapa.frame = CGRectMake(10, panel_mapa.frame.size.height - 39 , 150, 30);
    }
    //  sg_tipo_mapa.segmentedControlStyle = UISegmentedControlStyleBar;
    [sg_tipo_mapa addTarget:self action:@selector(setMap:) forControlEvents: UIControlEventValueChanged];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    sg_tipo_mapa.tintColor = [UIColor darkGrayColor];
    sg_tipo_mapa.backgroundColor = [UIColor whiteColor];
    sg_tipo_mapa.selectedSegmentIndex = 0;
    [panel_mapa addSubview:sg_tipo_mapa];
    panel_mapa.hidden = YES;
    panel_street.hidden = YES;
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    MAids = [[NSMutableArray alloc]init];
    MArrayFlota_h = [[NSMutableArray alloc]init];
    MArrayEco_h = [[NSMutableArray alloc]init];
    MArrayID_h = [[NSMutableArray alloc] init];
    MArrayIP_h = [[NSMutableArray alloc]init];
    MArrayLatitud_h = [[NSMutableArray alloc]init];
    MArrayLongitud_h = [[NSMutableArray alloc]init];
    MArrayAngulo_h = [[NSMutableArray alloc]init];
    MArrayVelocidad_h = [[NSMutableArray alloc]init];
    MArrayFecha_h = [[NSMutableArray alloc]init];
    MArrayEvento_h = [[NSMutableArray alloc]init];
    MArrayEstatus_h = [[NSMutableArray alloc]init];
    MArrayIcono_h = [[NSMutableArray alloc]init];
    MArrayUbicacion_h = [[NSMutableArray alloc]init];
    MArrayMotor_h = [[NSMutableArray alloc]init];
    MArrayTelefono_h = [[NSMutableArray alloc]init];
    MArrayMensajes_h = [[NSMutableArray alloc]init];
    MArrayIcono_mapa_h = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
     [self Animacion:1];
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usIP", @"rango", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu ,Globalpass, IP_unidad, @"0", nil];
    [soapTool callSoapServiceWithParameters__functionName:@"DameHistorico" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Animacion:(int)Code{
    if (Code==1) {
        sg_Actualizar.enabled = NO;
        sg_Vista.enabled = NO;
        btn_atras.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
    }
    
    else {
        sg_Actualizar.enabled = YES;
        sg_Vista.enabled = YES;
        btn_atras.enabled = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
    }
}
-(IBAction)Atras:(id)sender{
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

-(IBAction)ActualizaHistorico:(id)sender{
    NSString* rango;
    [self Animacion:1];
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    {
        case 0:{
            rango = @"0";
        }
            break;
        case 1:{
            rango = @"-1";
        }
            break;
        default:
            break;
    }
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"usIP", @"rango", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu ,Globalpass, IP_unidad, rango, nil];
    [soapTool callSoapServiceWithParameters__functionName:@"DameHistorico" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];

}

-(IBAction)Cerrar:(id)sender{
    panel_street.hidden = YES;
}
- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    Zoom = (int)value;
    [mapView_ animateToZoom:Zoom];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([latitud_unidad doubleValue], [longitud_unidad doubleValue]);
    [mapView_ animateToLocation:coordinate];
}

-(IBAction)setMap:(id)sender{
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    
    {
        case 0:{
            mapView_.mapType = kGMSTypeNormal;
        }
            break;
        case 1:{
            mapView_.mapType = kGMSTypeHybrid;
        }
            break;
        default:
            break;
    }
}

-(IBAction)SetViews:(id)sender{
    switch(((UISegmentedControl*)sender).selectedSegmentIndex)
    
    {
        case 0:{
            panel_mapa.hidden = YES;
            tbl_historico.hidden = NO;
        }
            break;
        case 1:{
            panel_mapa.hidden = NO;
            tbl_historico.hidden = YES;
        }
            break;
        default:
            break;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MArrayEvento_h count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"TableCell";
    SimpleTableCell *cell;
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
    NSString* i_motor = [MArrayMotor_h objectAtIndex:indexPath.row];
    
    if ([i_motor isEqualToString:@"ON"]) {
        cell.img_motor.image = [UIImage imageNamed:@"motor_on.png"];
    }
    else if ([i_motor isEqualToString:@"OFF"]) {
        cell.img_motor.image = [UIImage imageNamed:@"motor_off.png"];
    }
    else{
        cell.img_motor.image = [UIImage imageNamed:@"sin_motor.png"];
    }
    cell.lbl_eco.text = [MArrayEco_h objectAtIndex:indexPath.row];
    cell.lbl_evento.text = [MArrayEvento_h objectAtIndex:indexPath.row];
    cell.lbl_fecha.text = [MArrayFecha_h objectAtIndex:indexPath.row];
    cell.lbl_ubicacion.text = [MArrayUbicacion_h objectAtIndex:indexPath.row];
    NSString* velocidad = [MArrayVelocidad_h objectAtIndex:indexPath.row];
    velocidad = [velocidad stringByAppendingString:@" km/h"];
    cell.lbl_velocidad.text = velocidad;
    cell.img_icono.image = [UIImage imageNamed:[MArrayIcono_h objectAtIndex:indexPath.row]];
    cell.img_angulo.image = [UIImage imageNamed:[MArrayAngulo_h objectAtIndex:indexPath.row]];
    

    return cell;
    
    
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i<[MAids count]; i++) {
        
        if (![[MAids objectAtIndex:0] isEqualToString:@""]) {
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.position = CLLocationCoordinate2DMake([[MArrayLatitud_h objectAtIndex:i] doubleValue], [[MArrayLongitud_h objectAtIndex:i] doubleValue]);
            marker.icon = [UIImage imageNamed:[MArrayIcono_mapa_h objectAtIndex:i]];
            marker.snippet = [MAids objectAtIndex:i];
            marker.map = mapView_;
            if (indexPath.row==i) {
                [mapView_ setSelectedMarker:marker];
            }
        }
    }
    panel_mapa.hidden = NO;
    tbl_historico.hidden = YES;
    sg_Vista.selectedSegmentIndex = 1;
    
    return indexPath;
    
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
    NSString* i_motor = [MArrayMotor_h objectAtIndex:[marker.snippet intValue]];
    
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
    annotation.lbl_eco.text = [[MArrayEco_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    annotation.lbl_evento.text = [[MArrayEvento_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    annotation.lbl_fecha.text = [[MArrayFecha_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    annotation.lbl_ubicacion.text = [[MArrayUbicacion_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* velocidad = [[MArrayVelocidad_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    velocidad = [velocidad stringByAppendingString:@" km/h"];
    annotation.lbl_velocidad.text = velocidad;
    annotation.img_icono.image = [UIImage imageNamed:[[MArrayIcono_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    annotation.img_angulo.image = [UIImage imageNamed:[[MArrayAngulo_h objectAtIndex:[marker.snippet intValue]]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    return annotation;
}

- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker{
    if (![[MArrayEvento_h objectAtIndex:[marker.snippet intValue]] isEqualToString:StringMsg]) {
        [panoView_ moveNearCoordinate:CLLocationCoordinate2DMake([latitud_unidad doubleValue], [longitud_unidad doubleValue])];
        panel_street.hidden = NO;
    }
}



- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
