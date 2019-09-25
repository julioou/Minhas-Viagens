//
//  ListaTableViewController.swift
//  Minhas Viagens
//
//  Created by Treinamento on 9/24/19.
//  Copyright © 2019 JCAS. All rights reserved.
//

import UIKit

class ListaTableViewController: UITableViewController {
    
    var locaisViagens: [Dictionary<String, String>] = []
    let dados = ArmazenamentoDados()
    var controleNavegacao: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        controleNavegacao = "adicionar"
        locaisViagens = dados.carregarViagens()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return locaisViagens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCel", for: indexPath)
        cell.textLabel?.text = locaisViagens[indexPath.row]["local"]
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locaisViagens.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            dados.removerViagem(indice: indexPath.row)
        }
    }

    @IBAction func botaoAdicionar(_ sender: Any) {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        controleNavegacao = "listar"
        performSegue(withIdentifier: "vaiParaMapa", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "vaiParaMapa" {
            let destino = segue.destination as! ViewController
            if controleNavegacao == "listar" {
                print(controleNavegacao!)
                if let indiceRecuperado = sender {
                    let indice = indiceRecuperado as! Int
                    destino.viagem = locaisViagens[indice]
                    destino.indiceSelecionado = indice
                }
            }
            else {
                destino.viagem = [:]
                destino.indiceSelecionado = -1
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
