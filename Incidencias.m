//
//  Incidencias.m
//  Tracking
//
//  Created by Angel Rivas on 22/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import "Incidencias.h"
#import "Detalle.h"
#import "Reachability.h"
#import "Detalle_iOS.h"



extern NSMutableArray* descripcion_incidencias;
extern NSString* detalle_unidad;
extern NSString* GlobalString;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
NSString* incidencia;
extern NSString* IP_unidad;
BOOL reachable;
extern NSString* mapas;
BOOL lista_incidencia;
BOOL ajustar;


NSString* incidencia;

@interface Incidencias ()
{
    SYSoapTool *soapTool;
}

@end

@implementation Incidencias


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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)retriveFromSYSoapTool:(NSMutableArray *)_data{

    [self Mensaje];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    lbl_detalle.text = detalle_unidad;
    txt_incidencia.delegate = self;
    txt_incidencia.text = @"Proporcione más información sobre su incidencia";
    txt_incidencia.textColor = [UIColor lightGrayColor];
    actividad.hidden = YES;
    incidencia = [descripcion_incidencias objectAtIndex:0];
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    ajustar = YES;
    
}

-(IBAction)detalle:(id)sender{
    
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    incidencia = [descripcion_incidencias objectAtIndex:row];
    
}


-(IBAction)enviar:(id)sender{
    
    [self Animacion:1];
    
    
    NSString *cadena = txt_incidencia.text;
    NSString *cadenaSinEspacios = [cadena stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([cadenaSinEspacios isEqualToString:(@"")]) {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
                                                          message:@"Debe escribir un comentario"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        [message show];
        
    }
    else{
        

        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"usPassword", @"Tipo", @"Comentarios", @"Eco", @"IP", nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:GlobalUsu, Globalpass, incidencia, txt_incidencia.text, detalle_unidad, IP_unidad, nil];
        
        [soapTool callSoapServiceWithParameters__functionName:@"Incidencia" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];
              txt_incidencia.text = @"";
        
        
   //     UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
     //                                                     message:@"Incidencia enviada"
       //                                                  delegate:nil
         //                                       cancelButtonTitle:@"OK"
           //                                     otherButtonTitles:nil];
     //   [message show];
    }
    
}



//

-(void)Mensaje{
    
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión";
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:IncidenciaResponse xmlns:ns1=\"http://tempuri.org/\"><return xsi:type=\"xsd:string\">" withString:@""];
    
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"</return></ns1:IncidenciaResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>" withString:@""];
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:DameIncidenciaResponse xmlns:ns1=\"http://tempuri.org/\"><return xsi:type=\"xsd:string\">" withString:@""];
    
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"</return></ns1:DameIncidenciaResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>" withString:@""];
    
    
    
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
        btn_enviar.enabled = NO;
        btn_atras.enabled = NO;
        txt_incidencia.editable = NO;
        actividad.hidesWhenStopped = TRUE;
        [actividad startAnimating];
        
    }
    else {
        btn_enviar.enabled = YES;
        btn_atras.enabled = YES;
        txt_incidencia.editable = YES;
        [actividad stopAnimating];
        [actividad hidesWhenStopped];
        
    }
    
}



//xml
-(void)parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"The XML document is now being parsed.");
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
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    
    [self FillArray];
    
}


-(void)FillArray{
    
    [self Animacion:2];
    
    NSString* mensajeAlerta = StringMsg;
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
                                                      message:mensajeAlerta
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
    
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

//


/*

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    
    if ([text isEqualToString:@"\n"]) { [textView resignFirstResponder]; } return YES;
}*/


- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return descripcion_incidencias.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    incidencia = [descripcion_incidencias objectAtIndex:row];
    incidencia = [incidencia stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceCharacterSet]];
    incidencia = [incidencia stringByTrimmingCharactersInSet:
                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return descripcion_incidencias[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        
        CGRect frame;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                frame = CGRectMake(0.0, 0.0, 299, 30);
        }
        else{
            frame = CGRectMake(0.0, 0.0, 650, 60);
        }

        //label size
        
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        //here you can play with fonts
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [pickerLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
        }
        else{
            [pickerLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:17.0]];
        }

    }
    //picker view array is the datasource
    NSString *trimmedString = [[descripcion_incidencias objectAtIndex:row] stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    trimmedString = [[descripcion_incidencias objectAtIndex:row] stringByTrimmingCharactersInSet:
                     [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [pickerLabel setText:trimmedString];
    return pickerLabel;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Proporcione más información sobre su incidencia"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [self Ajustar:self];
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self Ajustar:self];
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Proporcione más información sobre su incidencia";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

-(IBAction)Ajustar:(id)sender{
    CGRect frame_txt = txt_incidencia.frame;
    CGRect frame_btn = btn_enviar.frame;
    if (ajustar) {
        ajustar = NO;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 481.0f) {
                //Do iPhone 5 stuff here.
                frame_txt.size.height = 52;
                frame_btn.origin.y = 301;
            }
            else{
                frame_txt.size.height = 22;
                frame_btn.origin.y = 251;
            }
        } else {
            //Do iPad stuff here.
            frame_txt.size.height = 287;
            frame_btn.origin.y = 634;
        }

    }
    else{
        ajustar = YES;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 481.0f) {
                //Do iPhone 5 stuff here.
                frame_txt.size.height = 265;
                frame_btn.origin.y = 525;
            }
            else{
                frame_txt.size.height = 202;
                frame_btn.origin.y = 441;
            }
        } else {
            //Do iPad stuff here.
            frame_txt.size.height = 569;
            frame_btn.origin.y = 920;
        }
    }
    [UIView beginAnimations:Nil context:nil];
    [UIView setAnimationDuration:0.1];
    btn_enviar.frame = frame_btn;
    txt_incidencia.frame = frame_txt;
    [UIView commitAnimations];
}

@end
