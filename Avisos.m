//
//  Avisos.m
//  Tracking
//
//  Created by Angel Rivas on 12/15/14.
//  Copyright (c) 2014 tecnologizame. All rights reserved.
//

//#import <AirshipKit/AirshipKit.h>
#import "Avisos.h"
#import "Reachability.h"
#import "TableCellResumen.h"

BOOL reachable;
extern NSString* GlobalString;
//extern NSString* id_usr;
extern NSString* GlobalUsu;
extern NSString* Globalpass;
extern NSString* documentsDirectory;
NSMutableArray* MAid_alerta;
NSMutableArray* MAaviso;
NSMutableArray* MAfecha_alerta;
NSMutableArray* MAevento_alerta;
NSMutableArray* MAlatitud_alerta;
NSMutableArray* MAlongitud_alerta;
NSMutableArray* MAvisto_alerta;
NSMutableArray* MAradio_alerta;
NSMutableArray* MAubicacion_alerta;

@interface Avisos (){
    int contador;
    NSMutableArray* AlertasNoVistas;
    SYSoapTool *soapTool;
}

@end

@implementation Avisos

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
    StringCode = @"";
    StringMsg = @"";
    StringCode = @"-10";
    StringMsg = @"Error en la conexión al servidor";
    NSData* data = [GlobalString dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    
    MAid_alerta = [[NSMutableArray alloc]init];
    MAaviso= [[NSMutableArray alloc]init];
    MAfecha_alerta= [[NSMutableArray alloc]init];
    MAevento_alerta= [[NSMutableArray alloc]init];
    MAlatitud_alerta= [[NSMutableArray alloc]init];
    MAlongitud_alerta= [[NSMutableArray alloc]init];
    MAvisto_alerta= [[NSMutableArray alloc]init];
    MAradio_alerta= [[NSMutableArray alloc]init];
    MAubicacion_alerta= [[NSMutableArray alloc]init];


    
    
    if(![parser parse])
        NSLog(@"Error al parsear");
    
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser parse];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Reset the badge after a push is received in a active or inactive state
    // if (application.applicationState != UIApplicationStateBackground) {
   // [[UAPush shared] resetBadge];
    //   }
    
    // Do any additional setup after loading the view from its nib.
    tbl_avisos.delegate = self;
    tbl_avisos.dataSource = self;
    AlertasNoVistas = [[NSMutableArray alloc]init];
    MAid_alerta = [[NSMutableArray alloc]init];
    MAaviso = [[NSMutableArray alloc]init];
    MAfecha_alerta = [[NSMutableArray alloc]init];
    MAevento_alerta = [[NSMutableArray alloc]init];
    MAlatitud_alerta = [[NSMutableArray alloc]init];
    MAlongitud_alerta = [[NSMutableArray alloc]init];
    MAvisto_alerta = [[NSMutableArray alloc]init];
    MAradio_alerta = [[NSMutableArray alloc]init];
    MAubicacion_alerta = [[NSMutableArray alloc]init];
    soapTool = [[SYSoapTool alloc]init];
    soapTool.delegate = self;
    [tbl_avisos addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [self refreshTable];
}

-(void)Animacion:(int)Code{
    if (Code==1) {
        btn_atras.enabled = NO;
    }
    
    else {
        btn_atras.enabled = YES;
    }
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
    
    currentElement = [elementName copy];
    currentElementString = [NSMutableString stringWithString:@""];
    if ([elementName isEqualToString:@"response"]) {
        [currentElementData removeAllObjects];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //Take the string inside an element (e.g. <tag>string</tag>) and save it in a property
    [currentElementString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"id"])
        StringCode = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"msg"])
        StringMsg = [currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([elementName isEqualToString:@"id_alerta"])
        [MAid_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"aviso"])
        [MAaviso addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"fecha"])
        [MAfecha_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"evento"])
        [MAevento_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"latitud"])
        [MAlatitud_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"longitud"])
        [MAlongitud_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"visto"])
        [MAvisto_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"radio"])
        [MAradio_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if ([elementName isEqualToString:@"ubicacion"])
        [MAubicacion_alerta addObject:[currentElementString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    //Document has been parsed. It's time to fire some new methods off!
    [self FillArray];
}

-(void)FillArray{
    NSString* mensajeAlerta = StringMsg;
    NSInteger code = [StringCode intValue];
    if (code <0){
        [MAid_alerta addObject:@""];
        [MAaviso addObject:mensajeAlerta];
        [MAfecha_alerta addObject:@""];
        [MAevento_alerta addObject:@""];
        [MAlatitud_alerta addObject:@""];
        [MAlongitud_alerta addObject:@""];
        [MAvisto_alerta addObject:@""];
        [MAradio_alerta addObject:@""];
        [MAubicacion_alerta addObject:@""];
    }
    [tbl_avisos reloadData];
    [refreshControl endRefreshing];
    [self Animacion:2];
    
}

- (void)refreshTable {
    //TODO: refresh your data
    [self Animacion:1];
   NSString* id_usr = @"-1";
    NSString* FileName = [NSString stringWithFormat:@"%@/id_usr.txt", documentsDirectory];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:FileName usedEncoding:nil error:nil];
    if (contents != nil && ![contents isEqualToString:@"Error"]) {
        id_usr = contents;
    }
    
    NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"idUsuario", nil];
    NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:id_usr, nil];
    [soapTool callSoapServiceWithParameters__functionName:@"Alertas" tags:tags vars:vars wsdlURL:@"http://201.131.96.39/wbs/wbs_pet3.php?wsdl"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [MAevento_alerta count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *simpleTableIdentifier = @"TableCell";
    
    TableCellResumen *cell;
    cell = (TableCellResumen *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            nib = [[NSBundle mainBundle] loadNibNamed:@"TableCellResumen_iPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        else{
            nib = [[NSBundle mainBundle] loadNibNamed:@"TableCellResumen" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
    }
    cell.lbl_menu.text = [MAaviso objectAtIndex:indexPath.row];
    /*
    cell.lbl_evento_alerta.text = [MAaviso objectAtIndex:indexPath.row];
    cell.lbl_fecha_alerta.text = [MAfecha_alerta objectAtIndex:indexPath.row];
    cell.lbl_ubicacion_alerta.text = [MAubicacion_alerta objectAtIndex:indexPath.row];
    cell.img_alerta.hidden = YES;
    if (![[MAvisto_alerta objectAtIndex:indexPath.row]isEqualToString:@""]) {
        cell.img_alerta.hidden = NO;
        int visto_ = [[MAvisto_alerta objectAtIndex:indexPath.row]intValue];
        NSString* nombre_imagen = [NSString stringWithFormat:@"%@", @"icono_alerta_nueva.png"];
        if (visto_== 1) {
            nombre_imagen = [NSString stringWithFormat:@"%@", @"icono_alerta_leida.png"];
        }
        cell.img_alerta.image = [UIImage imageNamed:nombre_imagen];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
     */
    
    return cell;
    
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (![[MAvisto_alerta objectAtIndex:indexPath.row]isEqualToString:@""]) {
        Sid_alerta = [MAid_alerta objectAtIndex:indexPath.row];
        Saviso = [MAaviso objectAtIndex:indexPath.row];
        Sfecha_alerta = [MAfecha_alerta objectAtIndex:indexPath.row];
        Sevento_alerta = [MAevento_alerta objectAtIndex:indexPath.row];
        Slatitud_alerta = [MAlatitud_alerta objectAtIndex:indexPath.row];
        Slongitud_alerta = [MAlongitud_alerta objectAtIndex:indexPath.row];
        Svisto_alerta = [MAvisto_alerta objectAtIndex:indexPath.row];
        Sradio_alerta = [MAradio_alerta objectAtIndex:indexPath.row];
        Subicacion_alerta = [MAubicacion_alerta objectAtIndex:indexPath.row];
        
        NSString* view_name = @"DetalleAlerta";
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height == 568.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone5"];
            else if (screenSize.height == 667.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6"];
            else if (screenSize.height == 736.0f)
                view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
        }
        else
            view_name = [view_name stringByAppendingString:@"_iPad"];
        DetalleAlerta *view = [[DetalleAlerta alloc] initWithNibName:view_name bundle:nil];
        view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:view animated:YES completion:nil];
    }
    
    */
    return indexPath;
}



-(IBAction)Resumen:(id)sender{
    /*
    NSString* view_name = @"MisMascotas";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height == 568.0f)
            view_name = [view_name stringByAppendingString:@"_iPhone5"];
        else if (screenSize.height == 667.0f)
            view_name = [view_name stringByAppendingString:@"_iPhone6"];
        else if (screenSize.height == 736.0f)
            view_name = [view_name stringByAppendingString:@"_iPhone6plus"];
    }
    else
        view_name = [view_name stringByAppendingString:@"_iPad"];
    re *viw = [[MisMascotas alloc] initWithNibName:view_name bundle:nil];
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:view animated:YES completion:nil];
    */
}

-(IBAction)MarcarLeidas:(id)sender{
    /*
    for (int i = 0; i< [MAvisto_alerta count]; i++) {
        if (![[MAvisto_alerta objectAtIndex:i]isEqualToString:@""]) {
            int visto_ = [[MAvisto_alerta objectAtIndex:i]intValue];
            if (visto_!= 1) {
                [AlertasNoVistas addObject:[MAid_alerta objectAtIndex:i]];
            }
        }
    }
    
    if ([AlertasNoVistas count] >0) {
        [self Animacion:2];
        NSMutableArray *tags = [[NSMutableArray alloc]initWithObjects:@"idAlerta", nil];
        NSMutableArray *vars = [[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@", [AlertasNoVistas objectAtIndex:contador_alertas]], nil];
        [soapTool callSoapServiceWithParameters__functionName:@"AlertaRevisada" tags:tags vars:vars wsdlURL:@"http://201.131.96.39/wbs/wbs_pet3.php?wsdl"];
    }*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
