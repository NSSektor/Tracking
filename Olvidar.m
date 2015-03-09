//
//  Olvidar.m
//  Tracking
//
//  Created by Angel Rivas on 21/12/13.
//  Copyright (c) 2013 Angel Rivas. All rights reserved.
//

#import "Olvidar.h"
#import "Login.h"
#import "Reachability.h"



BOOL reachable;
extern NSString* GlobalString;


@interface Olvidar ()
{
    SYSoapTool *soapTool;
}

@end

@implementation Olvidar

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
    
    [self Mensaje];
    
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
    txt_correo.delegate = self;
    soapTool = [[SYSoapTool alloc]init];
    
    soapTool.delegate = self;
    
    actividad.hidden = YES;
}

- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

-(IBAction)enviar:(id)sender{
    
    if(![self validateEmail:[txt_correo text]]) {
        // user entered invalid email address
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tracking" message:@"Ingrese una dirección valida de correo electrónico" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    } else {
        // user entered valid email address
        NSString *cadena = txt_correo.text;
        
        NSString *cadenaSinEspacios = [cadena stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [self Animacion:1];
        
        NSData *data = [@"tracking" dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        
        CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        {
            [output appendFormat:@"%02x", digest[i]];
        }
        
        
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"usName", @"llave", nil];
        
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:cadenaSinEspacios, output, nil];
        
        
        
        [soapTool callSoapServiceWithParameters__functionName:@"RecuperarPassword" tags:tags vars:vars wsdlURL:@"http://201.131.96.37/wbs_tracking4.php?wsdl"];

    }
    
    
    
}


-(void)Mensaje{
    
    
    
    StringCode = @"";
    
    StringMsg = @"";
    
    StringCode = @"-10";
    
    StringMsg = @"Error en la conexión";
   
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?><SOAP-ENV:Envelope SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"><SOAP-ENV:Body><ns1:RecuperarPasswordResponse xmlns:ns1=\"http://tempuri.org/\"><return xsi:type=\"xsd:string\">" withString:@""];
    
    
    
    
    
    GlobalString = [GlobalString stringByReplacingOccurrencesOfString:@"</return></ns1:RecuperarPasswordResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>" withString:@""];
    
    
    
    
    
    
    
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
        
        txt_correo.enabled = NO;
        
        actividad.hidesWhenStopped = TRUE;
        
        [actividad startAnimating];
        
        
        
    }
    
    else {
        
        btn_enviar.enabled = YES;
        
        btn_atras.enabled = YES;
        
        txt_correo.enabled = YES;
        
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
    
    [self Animacion:2];
    
    
    
    NSString* mensajeAlerta = StringMsg;
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Tracking"
                            
                                                      message:mensajeAlerta
                            
                                                     delegate:nil
                            
                                            cancelButtonTitle:@"OK"
                            
                                            otherButtonTitles:nil];
    
    [message show];
    
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

-(IBAction)atras:(id)sender{
    
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


/*Method to hidden keyboard*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
/*Method to hidden keyboard*/

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

@end
