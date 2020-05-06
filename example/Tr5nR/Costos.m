//
//  Costos.m
//  Tr5nR
//
//  Created by Camilo on 11-12-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "Costos.h"

#import "Tarifa.h"

@interface Costos()
@property (weak, nonatomic) IBOutlet UITableViewCell *costoGeneral;
@property (weak, nonatomic) IBOutlet UITableViewCell *costoEstudiante;

@property (weak, nonatomic) IBOutlet UITableViewCell *costoAdulto;

@property (weak, nonatomic) IBOutlet UITableViewCell *costoMinusvalido;

@property (weak, nonatomic) IBOutlet UITableViewCell *costoConvenio;

@property (weak, nonatomic) IBOutlet UINavigationItem *titulo;

@end

@implementation Costos

@synthesize costos = _costos;
@synthesize costoGeneral = _costoGeneral;
@synthesize costoEstudiante = _costoEstudiante;
@synthesize costoAdulto = _costoAdulto;
@synthesize costoMinusvalido = _costoMinusvalido;
@synthesize costoConvenio = _costoConvenio;

@synthesize titulo = _titulo;

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    Tarifa *general = [[Tarifa alloc] init];
    Tarifa *estudiante = [[Tarifa alloc] init];
    
    Tarifa *adulto = [[Tarifa alloc] init];
    Tarifa *minusvalido = [[Tarifa alloc] init];
    Tarifa *convenio = [[Tarifa alloc] init];
    
    general = [self.costos objectAtIndex:0];
    estudiante = [self.costos objectAtIndex:1];
    
    adulto = [self.costos objectAtIndex:2];
    minusvalido = [self.costos objectAtIndex:3];
    convenio = [self.costos objectAtIndex:4];
    
    self.costoGeneral.detailTextLabel.text =  [NSString stringWithFormat:@"$%@",general.valor];
    
    self.costoEstudiante.detailTextLabel.text = [NSString stringWithFormat:@"$%@",estudiante.valor];
    
    self.costoAdulto.detailTextLabel.text =  [NSString stringWithFormat:@"$%@",adulto.valor];
    
    self.costoMinusvalido.detailTextLabel.text =  [NSString stringWithFormat:@"$%@",minusvalido.valor];
    
    self.costoConvenio.detailTextLabel.text =  [NSString stringWithFormat:@"$%@",convenio.valor];
    
    self.titulo.title = [NSString stringWithFormat:@"Costos Hora %@", general.rango.tipo];
    
}

- (void)viewDidUnload {
    [self setCostoGeneral:nil];
    [self setCostoEstudiante:nil];
    [self setCostoAdulto:nil];
    [self setCostoMinusvalido:nil];
    [self setCostoConvenio:nil];
    [self setTitulo:nil];
    [super viewDidUnload];
}
@end
