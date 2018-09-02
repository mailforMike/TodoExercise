//
//  ViewController.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 01.09.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // default plist file:
    //let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
      
        loadItems()
        
        
        //   user defaults laden:
//        if let items = defaults.array(forKey: "liste") as? [Item] {
//            itemArray = items
//        } else {
//            itemArray.removeAll()
//        }
        
    }
    
    //MARK - Tableview Datasouce
    
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
  
    
    
    //MARK - Table view delegate methoden (Events)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableView.cellForRow(at: indexPath)?.textLabel?.text)
        
        itemArray[indexPath.row].erledigt = !itemArray[indexPath.row].erledigt

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - add button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfeld = UITextField()
        
        let alert = UIAlertController(title: "Neues Listenelement hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (aktion) in
            //print("hinzufügen gedrückt \(textfeld.text)")
            
            let element = Item()
            element.titel = textfeld.text!
            
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
    
    //MARK - Speichern/laden Routine
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do {
            let data = try  encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Erros encoding daten: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decode: \(error)")
            }
        }
    }
}

