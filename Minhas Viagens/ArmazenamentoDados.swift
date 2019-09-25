//
//  ArmazenamentoDados.swift
//  Minhas Viagens
//
//  Created by Treinamento on 9/24/19.
//  Copyright © 2019 JCAS. All rights reserved.
//

import Foundation

class ArmazenamentoDados {
    
    var viagens: [Dictionary<String, String>] = []
    let chave = "ArrayViagens"
    
    func dados() -> UserDefaults {
        return UserDefaults.standard
    }
    
    func salvarViagens(viagem: Dictionary<String, String>) {
        print("SalvarViagens executado")
        viagens = carregarViagens()
        self.viagens.append(viagem)
        dados().set(viagens, forKey: chave)
        dados().synchronize()
        print(viagens)
    }
    
    func carregarViagens() -> [Dictionary<String, String>] {
        if let dadosSalvos = dados().object(forKey: chave) {
            return dadosSalvos as! [Dictionary<String, String>]
        }
        else {
            return []
        }
    }
    
    func removerViagem(indice: Int) {
        viagens = carregarViagens()
        viagens.remove(at: indice)
        dados().set(viagens, forKey: chave)
        dados().synchronize()
    }
    
}
