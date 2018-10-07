//
//  ViewController.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 01.09.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var itemArray : Results<Item>?
    
    var selectedCategory : Category?  {
        didSet{
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        //loadItems()
        
    }
    
    //MARK: - Tableview Datasouce
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.titel
            cell.accessoryType = item.erledigt ? .checkmark : .none
        } else {
            cell.textLabel?.text = "keine elemente Vorhanden"
        }
        
        return cell
    }
  
    
    
    //MARK: - Table view delegate methoden (Events)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.erledigt = !item.erledigt
                }
            } catch {
                print("ERROR")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    //MARK: - add button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfeld = UITextField()
        
        let alert = UIAlertController(title: "Neues Listenelement hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (aktion) in
            //print("hinzufügen gedrückt \(textfeld.text)")
            
            if let currentcategory = self.selectedCategory {
               do {
                    try self.realm.write {
                        let element = Item()
                        element.titel = textfeld.text!
                        element.erledigt = false
                        element.dateCreated = Date()
                        currentcategory.items.append(element)
                    }
                } catch {
                    print("Erros core data write: \(error)")
                }
            }
            
            self.tableView.reloadData()
   
        }
        
        alert.addTextField { (alerttextfeld) in
            alerttextfeld.placeholder = "neues Element"
            textfeld = alerttextfeld
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Speichern/laden Routine
    
    
    func loadItems(){
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
       
        tableView.reloadData()
    }
    
    override func updatModel(at indexPath: IndexPath) {
        do {
            try realm.write {
                let obj = itemArray![indexPath.row]
                realm.delete(obj)
                
            }
        } catch {
            print("Erros core data write: \(error)")
        }
    }
    
}


//MARK: - searchbar funktionalität

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let preidcate = NSPredicate(format: "titel CONTAINS[cd] %@", searchBar.text!)
        itemArray = itemArray?.filter(preidcate).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}

