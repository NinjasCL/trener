//
//  EditarDatos.m
//  Tr5nR
//
//  Created by Camilo on 15-11-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "EditarDatos.h"
#import "Usuario.h"
#import "Usuarios.h"
#import "RealizarViaje.h"

@interface EditarDatos()
@property (weak, nonatomic) IBOutlet SimplePickerInputTableViewCell *usuario_cell;

@end

@implementation EditarDatos
@synthesize usuario_cell = _usuario_cell;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Mostramos los datos guardados por el usuario
    Usuario *usuario = [Usuarios obtenerUsuario];
    
    self.usuario_cell.detailTextLabel.text = usuario.tipo;
    
    usuario = nil;
}

- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(Usuario *)usuario {
	
    Usuario *usuarioMemoria = [Usuarios obtenerUsuario];

    // Si es distinto lo guardamos
    if (![usuarioMemoria.tipo isEqual:usuario.tipo]) {
        NSLog(@"Tipo de Usuario %@",usuario.tipo);
        // Guardamos el tipo de usuario en la memoria interna
        [Usuarios guardarUsuario:usuario];
    
        // Mostramos el cambio en Realizar Viaje
        [RealizarViaje activarRecargarDatos];
    }
}

- (void)viewDidUnload {
    [self setUsuario_cell:nil];
    [super viewDidUnload];
}
@end
