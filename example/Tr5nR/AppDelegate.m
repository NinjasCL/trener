//
//  AppDelegate.m
//  Tr5nR
//
//  Created by Camilo on 06-11-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "AppDelegate.h"

#import "Estacion.h"
#import "Usuario.h"

#import "Estaciones.h"
#import "Usuarios.h"

#import "Feriados.h"
#import "Rangos.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // Chequeamos si es primer run

    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRun"])
    {
        
        // Establecemos los valores iniciales
        
        Estacion *origen = [[Estaciones obtener] objectAtIndex:0];
        Estacion *destino = [[Estaciones obtener] objectAtIndex:19];
        Usuario *usuario = [Usuarios obtenerUsuario:0];
        
        [Estaciones guardarEstacion:origen guardarOrigen:YES];
        [Estaciones guardarEstacion:destino guardarOrigen:NO];
        [Usuarios guardarUsuario:usuario];
        
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRun"];
    }
    
    
    return YES;
}
							

@end
