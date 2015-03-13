//
//  Login.m
//  Tracking
//
//  Created by Angel Rivas on 29/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import "Login.h"
#import "Resumen.h"
#import "Ayuda.h"
#import "Olvidar.h"
#import "Reachability.h"


extern NSString* form;
extern NSString* mapas;
BOOL reachable;
extern NSString* GlobalString;
extern NSString* limite_velocidad;
extern NSString* busqueda;
extern NSString* tiempo_unidad_ociosa;
extern NSString* documentsDirectory;
extern NSString* ocultar;
NSString* GlobalUsu;
NSString* Globalpass;

NSMutableArray*  MArrayFlota;
NSMutableArray*  MArrayEco;
NSMutableArray*  MArrayID;
NSMutableArray*  MArrayIP;
NSMutableArray*  MArrayLatitud;
NSMutableArray*  MArrayLongitud;
NSMutableArray*  MArrayAngulo;
NSMutableArray*  MArrayVelocidad;
NSMutableArray*  MArrayFecha;
NSMutableArray*  MArrayEvento;
NSMutableArray*  MArrayEstatus;
NSMutableArray*  MArrayIcono;
NSMutableArray*  MArrayUbicacion;
NSMutableArray*  MArrayMotor;
NSMutableArray*  MArrayTelefono;
NSMutableArray*  MArrayMensajes;
NSMutableArray*  MArrayIcono_Mapa;

@interface Login (){
    SYSoapTool *soapTool;
    NSMutableArray* MAUsuarios;
    NSString* fileName_Cookies;
    NSMutableArray* autocompletar_usuarios;
}



@end

@implementation Login


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

-(NSString*)ReadFileRecordar{
    NSString* fileName = [NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil && [contents isEqualToString:@""]) {
        contents = @"Error";
    }
    
    return contents;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    autocompletar_usuarios = [[NSMutableArray alloc]init];
    form = @"Ayuda";
    actividad.hidden = YES;
    txt_usuario.delegate = self;
    txt_usuario.clearButtonMode = UITextFieldViewModeWhileEditing;
    txt_pass.delegate = self;
    txt_pass.clearButtonMode = UITextFieldViewModeWhileEditing;
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    GlobalString = @"";
    
    [btn_ayuda addTarget:self action:@selector(ayuda:) forControlEvents:UIControlEventTouchUpInside];
    [btn_olvide addTarget:self action:@selector(olvidar:) forControlEvents:UIControlEventTouchUpInside];
    [btn_enviar addTarget:self action:@selector(enviar:) forControlEvents:UIControlEventTouchUpInside];
    [check_button addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];

    
   
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
   
    
    NSString* datos_usuario = [self ReadFileRecordar];

    if (![datos_usuario isEqualToString:@"Error"]) {
        NSArray *chunks2 = [datos_usuario componentsSeparatedByString: @"|"];
        if ([chunks2 count]==2){
            
            txt_usuario.text  = [NSString stringWithFormat:@"%@", [chunks2 objectAtIndex:0]];
            txt_pass.text  = [NSString stringWithFormat:@"%@", [chunks2 objectAtIndex:1]];
            [check_button setImage:[UIImage imageNamed:@"checkbox-checked-gray-md.png"] forState:UIControlStateNormal];
            checked = YES;
        }
    }
    
   /* NSError *error = nil;
    NSArray  *yourFolderContents = [[NSFileManager defaultManager]
                                    contentsOfDirectoryAtPath:documentsDirectory error:&error];
    NSLog(@"%@", yourFolderContents);*/
    fileName_Cookies = [NSString stringWithFormat:@"%@/ConfigFile_Cookies.txt", documentsDirectory];
    MAUsuarios  = [[NSMutableArray alloc]initWithContentsOfFile:fileName_Cookies];
    if (MAUsuarios==nil || [MAUsuarios count]==0) {
        MAUsuarios = [[NSMutableArray alloc]init];
    }
    
    autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(txt_usuario.frame.origin.x, txt_usuario.frame.origin.y + 30, txt_usuario.frame.size.width, 120) style:UITableViewStylePlain];
    autocompleteTableView.delegate = self;
    autocompleteTableView.dataSource = self;
    autocompleteTableView.scrollEnabled = YES;
    autocompleteTableView.hidden = YES;
    [self.view addSubview:autocompleteTableView];
    
}

-(IBAction)check:(id)sender{
    
    if (!checked) {
        [check_button setImage:[UIImage imageNamed:@"checkbox-checked-gray-md.png"] forState:UIControlStateNormal];
        checked = YES;
    }
    else{
        [check_button setImage:[UIImage imageNamed:@"checkbox-unchecked-gray-md.png"] forState:UIControlStateNormal];
        checked = NO;
    }
    
}

-(IBAction)iniciar:(id)sender{
    
    [self Animacion:1];
    form = @"Ayuda";
    
    if (![txt_usuario.text isEqualToString:(@"") ] && ![txt_pass.text isEqualToString:(@"")]) {
        
        if (reachable) {
            NSString* fileName = [NSString stringWithFormat:@"%@%@", txt_usuario.text, @"_Velocidad.txt"];
            fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
            NSString* contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
            if (contents == nil || [contents isEqualToString:@""]) {

                limite_velocidad = @"90";
            }
            else{
                limite_velocidad = contents;
            }

            NSString* usuario_completo = txt_usuario.text;
            usuario_completo = [usuario_completo stringByAppendingString:@"+i+1.1"];
            
            
            fileName = [NSString stringWithFormat:@"%@%@", txt_usuario.text, @"_tiempo_unidad_ociosa.txt"];
            fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
            
            NSString *contentstiempo_unidad_ociosa = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
            if (contentstiempo_unidad_ociosa == nil || [contentstiempo_unidad_ociosa isEqualToString:@""]) {
                
                tiempo_unidad_ociosa = @"60";
                
            }
            else{
                tiempo_unidad_ociosa = contentstiempo_unidad_ociosa;
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
            
            NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword",@"usVelocidad", @"usMinSinReporte", nil];
            NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:usuario_completo, txt_pass.text, limite_velocidad, tiempo_unidad_ociosa, nil];
            
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
    else{
        [self Animacion:2];
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
                                                          message:@"Usuario y / o contraseña vacios"
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
    
    NSLog(@"%@", GlobalString);
    
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
    if ([elementName isEqualToString:@"Response"]) {
        [currentElementData removeAllObjects];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
   // dispatch_queue_t queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_async(queue, ^{ //If we've hit the </status> tag, store the data in the statuses array
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
  //  });
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    
    [self FillArray];
    
}


-(void)FillArray{
    
    
    
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
        
        StringMsg = [StringMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([StringMsg isEqualToString:@"ACTUALIZAR"]) {
            UIAlertView *messages = [[UIAlertView alloc] initWithTitle:@"Tracking"
                                                               message:@"Existe una nueva versión disponible. ¿Desea actualizar en este momento?"
                                                              delegate:self
                                                     cancelButtonTitle:@"Aceptar"
                                                     otherButtonTitles:@"Cancelar",nil];
            [messages setTag:1];
            [messages show];
            
        }
        else{
            [self EscribirArchivos];
            [self Resumen];
        }
        
        
    }

}

-(void)EscribirArchivos{
    NSString* fileName = [NSString stringWithFormat:@"%@/ConfigFile.txt", documentsDirectory];
    NSString* DataMobileUser = @"";
    if (checked == YES) {
        DataMobileUser = [DataMobileUser stringByAppendingString:txt_usuario.text];
        DataMobileUser = [DataMobileUser stringByAppendingString:@"|"];
        DataMobileUser = [DataMobileUser stringByAppendingString:txt_pass.text];
        [DataMobileUser writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
        NSMutableArray* MAUsuariostem = [[NSMutableArray alloc]init];
        if (MAUsuarios ==nil || [MAUsuarios count] == 0) {
            MAUsuariostem = [[NSMutableArray alloc] initWithObjects:DataMobileUser, nil];
        }
        else{
            BOOL existe_usuario = false;
            NSString* string_ = [NSString stringWithFormat:@"%@|%@", txt_usuario.text, txt_pass.text];
            for (int i = 0; i<[MAUsuarios count]; i++) {
                NSArray *chunks2 = [[MAUsuarios objectAtIndex:i] componentsSeparatedByString: @"|"];
                if ([txt_usuario.text isEqualToString:[chunks2 objectAtIndex:0]]) {
                    [MAUsuariostem addObject:string_];
                    existe_usuario = true;
                }
                else{
                    [MAUsuariostem addObject:[MAUsuarios objectAtIndex:i]];
                }
            }
            if (!existe_usuario) {
                [MAUsuariostem addObject:string_];
            }
        }
        [MAUsuariostem writeToFile:fileName_Cookies atomically:YES];
    }
    else{
        [@"Error" writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
    }
    GlobalUsu = txt_usuario.text;
    Globalpass = txt_pass.text;
    fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Mapas.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contentsMapas = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contentsMapas == nil || [contentsMapas isEqualToString:@""]) {
        mapas = @"Detalle";
    }
    else{
        mapas = contentsMapas;
    }
    
    fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_Busqueda.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    NSString *contentsBusqueda = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contentsBusqueda == nil || [contentsBusqueda isEqualToString:@""]) {
        
        busqueda = @"Ecónomico, Dirección";
        
    }
    else{
        busqueda = contentsBusqueda;
    }
    
    fileName = [NSString stringWithFormat:@"%@%@", GlobalUsu, @"_tiempo_unidad_ociosa.txt"];
    fileName = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    
    NSString *contentstiempo_unidad_ociosa = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contentstiempo_unidad_ociosa == nil || [contentstiempo_unidad_ociosa isEqualToString:@""]) {
        
        tiempo_unidad_ociosa = @"60";
        
    }
    else{
        tiempo_unidad_ociosa = contentstiempo_unidad_ociosa;
    }
    


}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1) {
        [self Animacion:2];
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/tracking-by-grupo-uda/id808638906?mt=8"]];
        }
        else{
            [self EscribirArchivos];
            [self Resumen];
        }
    }
    
}

//xml

-(void)Resumen{
    
    [self Animacion:2];
    
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


-(void)Animacion:(int)Code{
    
    if (Code==1) {
        btn_enviar.enabled = NO;
        check_button.enabled = NO;
        txt_pass.enabled = NO;
        txt_usuario.enabled = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
        
    }
    else {
        btn_enviar.enabled = YES;
        check_button.enabled = YES;
        txt_pass.enabled = YES;
        txt_usuario.enabled = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
        
    }
    
}



-(IBAction)ayuda:(id)sender{
    
    form = @"Login";
    
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

-(IBAction)olvidar:(id)sender{
    
    NSString* view_name = @"Olvidar";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            view_name = @"Olvidar_iPhone5";
    }
    else{
        view_name = @"Olvidar_iPad";
    }
 
    Olvidar *view = [[Olvidar alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*Method to hidden keyboard*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    autocompleteTableView.hidden = YES;
    [textField resignFirstResponder];
    return NO;
}
/*Method to hidden keyboard*/


- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    autocompleteTableView.hidden = YES;
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    autocompleteTableView.hidden = YES;
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [autocompletar_usuarios removeAllObjects];
    for(NSString *curString in MAUsuarios) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompletar_usuarios addObject:curString];
        }
    }
    if ([autocompletar_usuarios count]>0) {
        autocompleteTableView.hidden = NO;
    }
    else{
        autocompleteTableView.hidden = YES;
    }
    [autocompleteTableView reloadData];
}

#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField==txt_usuario) {
        NSString *substring = [NSString stringWithString:textField.text];
        substring = [substring stringByReplacingCharactersInRange:range withString:string];
        [self searchAutocompleteEntriesWithSubstring:substring];
    }
    return YES;
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompletar_usuarios.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    NSArray *chunks2 = [[autocompletar_usuarios objectAtIndex:indexPath.row] componentsSeparatedByString: @"|"];
    
    cell.textLabel.text = [chunks2 objectAtIndex:0];
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *chunks2 = [[autocompletar_usuarios objectAtIndex:indexPath.row] componentsSeparatedByString: @"|"];
    txt_usuario.text = [chunks2 objectAtIndex:0];
    txt_pass.text = [chunks2 objectAtIndex:1];
    autocompleteTableView.hidden = YES;
    [txt_usuario resignFirstResponder];
  //  [self goPressed];
    
}

@end
