//
//  ViewController.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 01.09.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //greift auf objekte der klasse appdelegate zu:
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]() // <- Item ist der Tabllen Name aus CoreData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        loadItems()
        
    }
    
    //MARK: - Tableview Datasouce
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        cell?.textLabel?.text = itemArray[indexPath.row].titel
        
        cell?.accessoryType = itemArray[indexPath.row].erledigt ? .checkmark : .none
        // das selbe wie das hier:
        //if itemArray[indexPath.row].erledigt { cell?.accessoryType = .checkmark } else { cell?.accessoryType = .none}
        
        return cell!
    }
  
    
    
    //MARK: - Table view delegate methoden (Events)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableView.cellForRow(at: indexPath)?.textLabel?.text)

        //      core data löschen:
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].erledigt = !itemArray[indexPath.row].erledigt

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - add button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfeld = UITextField()
        
        let alert = UIAlertController(title: "Neues Listenelement hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (aktion) in
            //print("hinzufügen gedrückt \(textfeld.text)")
            
            let element = Item(context: self.context)
            element.titel = textfeld.text!
            element.erledigt = false
            
            self.itemArray.append(element)
            
            self.saveItems()
            
            // default plist schreiben:
            //self.defaults.set(self.itemArray, forKey: "liste")
            
            
        }
        
        alert.addTextField { (alerttextfeld) in
            alerttextfeld.placeholder = "neues Element"
            textfeld = alerttextfeld
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Speichern/laden Routine
    
    func saveItems(){
        
        do {
           try context.save()
        } catch {
            print("Erros core data write: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(_ request : NSFetchRequest<Item> = Item.fetchRequest()){
        
        do {
            itemArray = try context.fetch(request)
        } catch {
             print("Erros core data read: \(error)")
        }
        tableView.reloadData()
    }
    
}


//MARK: - searchbar funktionalität

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let preidcate = NSPredicate(format: "titel CONTAINS[cd] %@", searchBar.text!)
        request.predicate = preidcate
        
        let sortierung = NSSortDescriptor(key: "titel", ascending: true)
        request.sortDescriptors = [sortierung]
        
        loadItems(request)
        
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

