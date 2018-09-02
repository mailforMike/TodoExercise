//
//  ViewController.swift
//  TodoExercise
//
//  Created by Michael Holzinger on 01.09.18.
//  Copyright © 2018 Michael Holzinger. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["eintrag1","eintrag2","zeile3","zeile4"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "liste") as? [String] {
            itemArray = items
        } else {
            itemArray.removeAll()
        }
        
    }
    
    //MARK - Tableview Datasouce
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell")
        cell?.textLabel?.text = itemArray[indexPath.row]
        return cell!
    }
  
    
    
    //MARK - Table view delegate methoden (Events)
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(tableView.cellForRow(at: indexPath)?.textLabel?.text)
        
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
    
    //MARK - add button
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfeld = UITextField()
        
        let alert = UIAlertController(title: "Neues Listenelement hinzufügen", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "hinzufügen", style: .default) { (aktion) in
            //print("hinzufügen gedrückt \(textfeld.text)")
            self.itemArray.append(textfeld.text!)
            
            self.defaults.set(self.itemArray, forKey: "liste")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alerttextfeld) in
            alerttextfeld.placeholder = "neues Element"
            textfeld = alerttextfeld
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}

