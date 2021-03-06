//
//  CategoryViewController.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 06.10.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        loadItems()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let index = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[index.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "keine Kategorien angelegt"
        
        if let hex = categoryArray?[indexPath.row].color {
            cell.backgroundColor = UIColor.init(hexString: hex)
            let ttt = UIColor.init(contrastingBlackOrWhiteColorOn: UIColor.init(hexString: hex), isFlat: true)
            cell.textLabel?.textColor = ttt
        }
        
        
        
        return cell
    }
    
    func loadItems(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Erros core data write: \(error)")
        }
        self.tableView.reloadData()
    }
    
    override func updatModel(at indexPath: IndexPath) {
        do {
            try realm.write {
                let obj = categoryArray![indexPath.row]
                realm.delete(obj)
                
            }
        } catch {
            print("Erros core data write: \(error)")
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfeld = UITextField()
        
        let alert = UIAlertController(title: "Neue Kategorie hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (aktion) in
            
            let element = Category()
            element.name = textfeld.text!
            element.color = UIColor.randomFlat().hexValue()
           
            self.save(category: element)
           
        }
        
        alert.addTextField { (alerttextfeld) in
            alerttextfeld.placeholder = "neue Kategorie"
            textfeld = alerttextfeld
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
