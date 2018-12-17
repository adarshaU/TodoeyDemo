//
//  ViewController.swift
//  Todoey
//
//  Created by Adarsha Upadhya on 12/12/18.
//  Copyright © 2018 Adarsha Upadhya. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    var itemArray = [Item]()
    
    let datafielPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(datafielPath)
        
       loadItems()
        
        
        
        
        
     
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}


extension ToDoListTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoListTableViewCell")
         let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListTableViewCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
       itemArray[indexPath.row].done =  itemArray[indexPath.row].done == false ? true : false
        
        self.writeData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
   
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todaey", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            var newItem = Item()
            newItem.title = localTextField.text!
            self.itemArray.append(newItem)
            
            self.writeData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create new Item"
            localTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    fileprivate func writeData() {
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: datafielPath!)
            
        }catch{
            print("got error")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        
        do{
            let data = try Data(contentsOf: datafielPath!)
            
            let decoder = PropertyListDecoder()
            
            self.itemArray = try decoder.decode([Item].self, from: data)
            self.tableView.reloadData()
       
        }catch{
            print("Unable to load data")
        }
    }
}





