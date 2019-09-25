//
//  ViewController.swift
//  Minhas Viagens
//
//  Created by Treinamento on 9/24/19.
//  Copyright © 2019 JCAS. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapa: MKMapView!
    
    //Variáveis de controle localização.
    let gerenciadorLocal: CLLocationManager = CLLocationManager()
    var LocalCompleto = "Endereço não econtrado!"
    var rua = "Endereço não econtrado!"
    
    //Dicionário de endereços marcados.
    var viagem: Dictionary<String, String> = [:]
    //Declaração do banco de dados que é do tipo userdefaults.
    var dadoLocal = ArmazenamentoDados()
    
    //Variáveis de controle de navegacao
    var indiceSelecionado: Int?
    var controleFluxo: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestos()
        
        if let indice = indiceSelecionado {
            if indice == -1 { //Adicionar
                configuracaoGerenciadorLocal()
            }
            else { //Listar
                exibirAnotacao(viagem: viagem)
            }
        }
    }
    
    //Função para obter a localização que o GPS apontar.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let localizacaoUsuario = locations.last {
            let latitude: CLLocationDegrees = localizacaoUsuario.coordinate.latitude
            let longitude: CLLocationDegrees = localizacaoUsuario.coordinate.longitude
            //Func Aproximando câmera do local do usuário.
            //Obtendo coordenadas.
            let coordenadas = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
            
            //Aproximando a visualização.
            let deltaLatitude: CLLocationDegrees = 0.05
            let deltaLongitude: CLLocationDegrees = 0.05
            let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
            let regiao = MKCoordinateRegion(center: coordenadas, span: areaVisualizacao)
            self.mapa.setRegion(regiao, animated: true)
        }
    }
    
    //Função para aproximar a câmera do local definindo nos inputs.
    func exibirLocal(latitude: Double, longitude: Double) {
        //Obtendo coordenadas.
        let coordenadas = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
        //Aproximando a visualização.
        let deltaLatitude: CLLocationDegrees = 0.05
        let deltaLongitude: CLLocationDegrees = 0.05
        let areaVisualizacao: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        let regiao = MKCoordinateRegion(center: coordenadas, span: areaVisualizacao)
        self.mapa.setRegion(regiao, animated: true)
        
    }
    
    //Função difindo o local das marcações e
    func exibirAnotacao(viagem: Dictionary<String, String>) {
        let latitudeString = viagem["latitude"]
        guard let latitude = Double(latitudeString!) else {fatalError("Não foi possível converter.")}
        let longitudeString = viagem["longitude"]
        guard let longitude = Double(longitudeString!) else {fatalError("Não foi possível converter.")}
        
        //Obtendo coordenadas.
        let coordenadas = CLLocationCoordinate2D.init(latitude: latitude, longitude: longitude)
        
        //Aproximando câmera do local marcado.
        if indiceSelecionado != -1 {
            exibirLocal(latitude: latitude, longitude: longitude)
        }
        
        //Exibe anotaçāo.
        let anotacao = MKPointAnnotation()
        anotacao.coordinate = coordenadas
        anotacao.title = viagem["local"]
//        anotacao.subtitle = self.LocalCompleto
        mapa.addAnnotation(anotacao)
    }
    
    //Configurando o GPS
    func configuracaoGerenciadorLocal(){
        gerenciadorLocal.delegate = self
        gerenciadorLocal.desiredAccuracy = kCLLocationAccuracyBest
//        gerenciadorLocal.requestWhenInUseAuthorization()
        gerenciadorLocal.startUpdatingLocation()
    }
    
    //Detectando toques na tela.
    func gestos(){
        let reconhecerGesto = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.marcar(gesture:)))
        reconhecerGesto.minimumPressDuration = 2
        mapa.addGestureRecognizer(reconhecerGesto)
    }
    
    //Marcação dos locais de viagens
    @objc func marcar(gesture: UIGestureRecognizer) {
       
        if gesture.state == UIGestureRecognizer.State.began {
            
            //Recuperando as coordenadas do ponto selecionado.
            let pontoSelecionado = gesture.location(in: self.mapa)
            let coordenadas = mapa.convert(pontoSelecionado, toCoordinateFrom: self.mapa)
            let latitude = coordenadas.latitude
            let longitude = coordenadas.longitude
            //Localizaçao da marcacao.
            let localizacao: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            CLGeocoder().reverseGeocodeLocation(localizacao, completionHandler: { (detalhes, error) in
                if error == nil {
                    if let local = detalhes?.first {
                        if let nome = local.name {
                            self.LocalCompleto = nome
                        }
                        if let endereco = local.thoroughfare {
                            self.rua = endereco
                        }
                    }
                    else {
                        print("Error")
                    }
                    
                    //Salvar dados obtidos.
                    self.viagem = ["local" : self.LocalCompleto,
                                   "latitude" : String(latitude),
                                   "longitude" : String(longitude)]
                    self.dadoLocal.salvarViagens(viagem: self.viagem)
                    //Exibe anotaçāo com os LocalCompleto do endereço.
                    self.exibirAnotacao(viagem: self.viagem)
                }
            })
        }
    }
    
}
