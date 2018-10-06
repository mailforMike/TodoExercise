//
//  CategoryViewController.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 06.10.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]() // <- Category ist der Tabllen Name aus CoreData Model

    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell")
        
        cell?.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell!
    }
    
    func loadItems(_ request : NSFetchRequest<Category> = Category.fetchRequest()){
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Erros core data read: \(error)")
        }
        tableView.reloadData()
    }
    
    func saveItems(){
        
        do {
            try context.save()
        } catch {
            print("Erros core data write: \(error)")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfeld = UITextField()
        
        let alert = UIAlertController(title: "Neue Kategorie hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (aktion) in
            
            let element = Category(context: self.context)
            element.name = textfeld.text!
            
            self.categoryArray.append(element)
            self.saveItems()
           
        }
        
        alert.addTextField { (alerttextfeld) in
            alerttextfeld.placeholder = "neue Kategorie"
            textfeld = alerttextfeld
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
