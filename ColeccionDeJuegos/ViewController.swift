//
//  ViewController.swift
//  ColeccionDeJuegos
//
//  Created by Rodrigo Mejia on 15/05/2021.
//  Copyright © 2021 Rodrigo Mejia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.imageView?.image = UIImage(data: (juego.imagen!))
        /*juegos[indexPath.row].setValue(indexPath.row, forKeyPath: "orderPosition")
        cell.textLabel?.text = juegos[indexPath.row].value(forKey: "title") as? String
        cell.imageView?.image = UIImage(data: ((juegos[indexPath.row].value(forKey: "imagen") as? Data)!))*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
             context.delete(juegos[indexPath.row])
             (UIApplication.shared.delegate as! AppDelegate).saveContext()
             
             //Se llama la función viewWillAppear para que actualice los datos de la tabla
             viewWillAppear(true)
         }
     }
        
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
                
        let juegoMovido = juegos[sourceIndexPath.row]
        
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(juegoMovido, at: destinationIndexPath.row)
        
        //let juegoanterior = juegos[destinationIndexPath.row]
        
        //Esto debería hacer el cambio de posiciones intercambiando los valores pero no es así
        /*let titulo = juegos [destinationIndexPath.row].titulo
        let imagen = juegos[destinationIndexPath.row].imagen
        
        juegoanterior.titulo = juegos[sourceIndexPath.row].titulo
        juegoanterior.imagen = juegos[sourceIndexPath.row].imagen
        
        juegoMovido.titulo = titulo
        juegoMovido.imagen = imagen*/
        
        tableView.reloadData()
        
        //(UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
     
    @IBOutlet weak var tableView: UITableView!
    var juegos : [Juego] = []
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
            
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        setEditing(true, animated: true)
    
        self.tableView.isEditing = true
        
        
    }


}

