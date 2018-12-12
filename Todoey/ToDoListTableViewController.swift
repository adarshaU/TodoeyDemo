//
//  ViewController.swift
//  Todoey
//
//  Created by Adarsha Upadhya on 12/12/18.
//  Copyright © 2018 Adarsha Upadhya. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    let itemArray = ["One","two","three"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}


extension ToDoListTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListTableViewCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        let accessoryType:UITableViewCell.AccessoryType  = (tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) ? .none : .checkmark
        tableView.cellForRow(at: indexPath)?.accessoryType  = accessoryType
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
}

