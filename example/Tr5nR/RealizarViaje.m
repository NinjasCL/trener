//
//  RealizarViaje.m
//  Tr5nR
//
//  Created by Camilo on 15-11-12.
//  Copyright (c) 2012 Camilo Castro. All rights reserved.
//

#import "RealizarViaje.h"
#import "ProximosTrenes.h"
#import "Costos.h"

#import "Estacion.h"
#import "Estaciones.h"

#import "Operaciones.h"
#import "Rangos.h"

#import "Horario.h"
#import "Horarios.h"

#import "Tarifa.h"
#import "Tarifas.h"

#import "Usuarios.h"


// Contador necesario para no sobrecargar la bd
static BOOL recargarDatos = YES;

@interface RealizarViaje ()

@property (nonatomic,strong) NSArray * proximosTrenes;
@property (nonatomic,strong) NSArray * tarifas;

@property (weak, nonatomic) IBOutlet EstacionPickerInputTableViewCell *origen_cell;

@property (weak, nonatomic) IBOutlet EstacionPickerInputTableViewCell *destino_cell;

@property (weak, nonatomic) IBOutlet UITableViewCell *tiempoViaje_cell;

@property (weak, nonatomic) IBOutlet UITableViewCell *proximo_cell;

@property (weak, nonatomic) IBOutlet UITableViewCell *costo_cell;

@end

@implementation RealizarViaje

@synthesize proximosTrenes = _proximosTrenes;
@synthesize tarifas = _tarifas;

@synthesize origen_cell = _origen_cell;
@synthesize destino_cell = _destino_cell;
@synthesize tiempoViaje_cell = _tiempoViaje_cell;
@synthesize proximo_cell = _proximo_cell;
@synthesize costo_cell = _costo_cell;

+ (void) activarRecargarDatos{
    recargarDatos = YES;
}

- (void) calcularResultados {
    if (recargarDatos) {
        
        // Establecemos los valores iniciales
        Estacion *estacion = [[Estacion alloc] init];
        
        // Mostramos el Origen Guardado
        estacion = [Estaciones obtenerEstacionOrigen:YES];
        
        self.origen_cell.detailTextLabel.text = estacion.nombre;
        
        // Mostramos el Destino Guardado
        estacion = [Estaciones obtenerEstacionOrigen:NO];
        
        self.destino_cell.detailTextLabel.text = estacion.nombre;
        
        estacion = nil;
        
        self.tiempoViaje_cell.detailTextLabel.text =[ NSString stringWithFormat:@"%@ Minutos",[[Operaciones obtenerTiempoDeViaje] stringValue]];
    
    
        self.proximosTrenes = [NSArray arrayWithArray:[Horarios proximosTrenes]];
    
        self.tarifas = [NSArray arrayWithArray:[Tarifas obtenerTarifas]];
    
    
        if ([self.proximosTrenes count] > 0) {
            Horario *proximo = [self.proximosTrenes objectAtIndex:0];
            self.proximo_cell.detailTextLabel.text = [NSString stringWithFormat:@"%1.0f Minutos (%@)",[proximo.minutos doubleValue],proximo.hora];
            
            self.proximo_cell.userInteractionEnabled = YES;
            
            self.proximo_cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        } else {
            
            self.proximo_cell.detailTextLabel.text = @"No hay trenes";
            self.proximo_cell.userInteractionEnabled = NO;
            self.proximo_cell.accessoryType = UITableViewCellAccessoryNone;
        }
    
    
    
        Tarifa *costo = [Tarifas obtenerTarifaUsuario];
    
        self.costo_cell.textLabel.text = [NSString stringWithFormat:@"Costo %@",costo.usuario.tipo];
        
        self.costo_cell.detailTextLabel.text = [NSString stringWithFormat:@"$%@",costo.valor];
    }
    
    recargarDatos = NO;
}

- (void) viewDidLoad{
    // Cada minuto se actualizaran los tiempos
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(actualizarCadaMinuto:) userInfo:nil repeats:YES];
}

// Cada minuto actualiza el proximo tren
- (void) actualizarCadaMinuto:(NSTimer *)timer{
    recargarDatos = YES;
    [self calcularResultados];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self calcularResultados];
    
    
}

// Metodo que se llama cada vez que se cambia de estacion
- (void)tableViewCell:(EstacionPickerInputTableViewCell *)cell didEndEditingWithEstacion:(Estacion *)estacion{
    
    // La estacion guardada en memoria
    Estacion *estacionMemoria = [[Estacion alloc] init];
    
    // Tag 0 es Origen
    if (cell.tag == 0) {
        NSLog(@"Origen %@",estacion.nombre);


        // Guardamos en la memoria interna si es diferente a la guardada
        
        // Origen
        estacionMemoria = [Estaciones obtenerEstacionOrigen:YES];
        if (![estacionMemoria.nombre isEqual:estacion.nombre]) {
             recargarDatos = YES;
            [Estaciones guardarEstacion:estacion guardarOrigen:YES];
        }
        
    // Tag 1 para Destino
    } else {
        NSLog(@"Destino %@",estacion.nombre);

        // Guardamos en la memoria interna si es diferente a la guardada
        
        // Destino
        estacionMemoria = [Estaciones obtenerEstacionOrigen:NO];
        
        if (![estacionMemoria.nombre isEqual:estacion.nombre]) {
            recargarDatos = YES;
            [Estaciones guardarEstacion:estacion guardarOrigen:NO];
        }

        
    } 
    
    [self calcularResultados];
    
}


- (void)viewDidUnload {
    [self setOrigen_cell:nil];
    [self setDestino_cell:nil];
    [self setTiempoViaje_cell:nil];
    [self setProximo_cell:nil];
    [self setCosto_cell:nil];
    [super viewDidUnload];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if([segue.identifier isEqualToString:@"listadoProximos"]){

        if([self.proximosTrenes count]> 0){
            ProximosTrenes *proximosVC = segue.destinationViewController;
            
                proximosVC.proximos = self.proximosTrenes;
        
        }
    }
    
    if([segue.identifier isEqualToString:@"listadoCostos"]){
        if ([self.tarifas count] > 0) {
            Costos *costos = segue.destinationViewController;
            
            costos.costos = self.tarifas;
            
        }
        
    }
}
@end
