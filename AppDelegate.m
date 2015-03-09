//
//  AppDelegate.m
//  Tracking
//
//  Created by Angel Rivas on 28/12/13.
//  Copyright (c) 2013 tecnologizame. All rights reserved.
//

#import "AppDelegate.h"
#import "Login.h"
#import "Reachability.h"
#import "MTReachabilityManager.h"
#import "Contrato.h"
#import "StreetView.h"
#import <GoogleMaps/GoogleMaps.h>
#import <AirshipKit/AirshipKit.h>
#import "Detalle_iOS.h"
#import "Avisos.h"

NSString* detalle_unidad;
NSString* latitud_unidad;
NSString* longitud_unidad;
NSString* form;
NSString* GlobalString;
NSString* configuracion;
NSString* IP_unidad;
NSString* mapas;
NSString* busqueda;
NSString* tiempo_unidad_ociosa;
NSIndexPath *index_seleccionado;
NSString* limite_velocidad;
NSMutableArray* descripcion_incidencias;
NSString* documentsDirectory;
NSString* ocultar;
NSString* DeviceToken;
NSString* dispositivo;
BOOL mostrar_street;
 
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyDh9ZBPp6hbWv_g8BGuEpy-c0wu8U1ghpo"];
    
    [MTReachabilityManager sharedManager];
    
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    
    dispositivo = @"iPhone";
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f)
            dispositivo = @"iPhone5";
    }
    else{
        dispositivo = @"iPad";
    }
    
    [UAirship takeOff:config];
    
    [UAPush shared].userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationActivationModeBackground |
                                             UIUserNotificationTypeBadge |
                                             UIUserNotificationTypeSound);
    
    [UAPush shared].userPushNotificationsEnabled = YES;
    
    DeviceToken = [[UAirship shared] deviceToken];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
     documentsDirectory = [paths objectAtIndex:0];
    configuracion = @"NO";
    mostrar_street = NO;
    index_seleccionado = [NSIndexPath indexPathForRow:0 inSection:0];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    NSString* ViewName = @"Login";
    
    NSString* fileName = [NSString stringWithFormat:@"%@/Aceptar.txt", documentsDirectory];
    NSString *contents = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents == nil || [contents isEqualToString:@""]) {
        
        ViewName = @"Contrato";
        
    }
   
    
    fileName = [NSString stringWithFormat:@"%@/Incidencias.txt", documentsDirectory];
    descripcion_incidencias = [[NSMutableArray alloc]initWithContentsOfFile:fileName];

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            //Do iPhone 5 stuff here.
            ViewName = [ViewName stringByAppendingString:@"_iPhone5"];
        }
    } else {
        //Do iPad stuff here.
        ViewName = [ViewName stringByAppendingString:@"_iPad"];
        
    }
    
    
    fileName = [NSString stringWithFormat:@"%@/Velocidad.txt", documentsDirectory];
    NSString* contents_velocidad = [[NSString alloc] initWithContentsOfFile:fileName usedEncoding:nil error:nil];
    if (contents_velocidad == nil || [contents_velocidad isEqualToString:@""]) {
        
        contents_velocidad = @"90";
    }
//    limite_velocidad = contents_velocidad;
    
    ocultar = @"-1";

    
    
  
    if (contents == nil || [contents isEqualToString:@""]) {
        
        Contrato *viewController = [[Contrato alloc] initWithNibName:@"Contrato_" bundle:nil];
        self.window.rootViewController = viewController;
        
    }
    else{
        Login*  viewController = [[Login alloc] initWithNibName:ViewName bundle:nil];
        self.window.rootViewController = viewController;
    }
    
 //   Avisos*  viewController = [[Avisos alloc] initWithNibName:@"Avisos" bundle:nil];
   //    self.window.rootViewController = viewController;
    
    
//    FacebookDemo*  viewController = [[FacebookDemo alloc] initWithNibName:@"FacebookDemo" bundle:nil];
 //   self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    UA_LINFO(@"Received remote notification (in appDelegate): %@", userInfo);
    
    /*  if ([Globalpass isEqualToString:@""] && [Globalpass isEqualToString:@""]) {
     NSString* ViewName = @"Login";
     CGSize screenSize = [[UIScreen mainScreen] bounds].size;
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     if (screenSize.height > 480.0f) {
     //Do iPhone 5 stuff here.
     ViewName = [ViewName stringByAppendingString:@"_iPhone5"];
     }
     } else {
     //Do iPad stuff here.
     ViewName = [ViewName stringByAppendingString:@"_iPad"];
     
     }
     Login *viewController = [[Login alloc] initWithNibName:ViewName bundle:nil];
     self.window.rootViewController = viewController;
     
     }
     else{
     NSString* ViewName = @"Alertas";
     CGSize screenSize = [[UIScreen mainScreen] bounds].size;
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
     if (screenSize.height > 480.0f) {
     //Do iPhone 5 stuff here.
     ViewName = [ViewName stringByAppendingString:@"_iPhone5"];
     }
     } else {
     //Do iPad stuff here.
     ViewName = [ViewName stringByAppendingString:@"_iPad"];
     
     }
     Alertas *viewController = [[Alertas alloc] initWithNibName:ViewName bundle:nil];
     self.window.rootViewController = viewController;
     }
     
     */
    
    //
    // Optionally provide a delegate that will be used to handle notifications received while the app is running
    // [UAPush shared].pushNotificationDelegate = your custom push delegate class conforming to the UAPushNotificationDelegate protocol
    
    // Reset the badge after a push is received in a active or inactive state
    if (application.applicationState != UIApplicationStateBackground) {
        [[UAPush shared] resetBadge];
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token);
    
}

- (void)registrationSucceededForChannelID:(NSString *)channelID deviceToken:(NSString *)deviceToken{
    DeviceToken = deviceToken;
}

// Returns YES if the application is currently registered for remote notifications, taking into account any systemwide settings; doesn't relate to connectivity.
- (BOOL)isRegisteredForRemoteNotifications{
    return YES;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    UA_LTRACE(@"Application did register with user notification types %ld", (unsigned long)notificationSettings.types);
    [[UAPush shared] appRegisteredUserNotificationSettings];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    UA_LERR(@"Application failed to register for remote notifications with error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    UA_LINFO(@"Application received remote notification: %@", userInfo);
    [[UAPush shared] appReceivedRemoteNotification:userInfo applicationState:application.applicationState];
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())handler {
    UA_LINFO(@"Received remote notification button interaction: %@ notification: %@", identifier, userInfo);
    [[UAPush shared] appReceivedActionWithIdentifier:identifier notification:userInfo applicationState:application.applicationState completionHandler:handler];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[UAPush shared] resetBadge];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[UAPush shared] resetBadge];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
