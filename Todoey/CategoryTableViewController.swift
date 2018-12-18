//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Adarsha Upadhya on 18/12/18.
//  Copyright © 2018 Adarsha Upadhya. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    
    var categories:Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    func loadCategories(){
         categories = realm.objects(Category.self)
         tableView.reloadData()
    }

    func deleteModel(indexPath:IndexPath){
        
        if let category = self.categories?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(category)
                }
            }catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        deleteModel(indexPath: indexPath)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories addded"
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinactionVC = segue.destination as! ToDoListTableViewController
       
        if let indexpath = tableView.indexPathForSelectedRow {
            destinactionVC.selectedCategory = categories?[indexpath.row]
        }
        
    }
    
    fileprivate func writeData(category:Category) {
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("got error")
        }
        
        self.tableView.reloadData()
    }
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        var localTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = localTextField.text!
            
            self.writeData(category: newCategory)
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create new Item"
            localTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

    

}


