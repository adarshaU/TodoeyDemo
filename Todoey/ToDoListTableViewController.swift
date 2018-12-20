//
//  ViewController.swift
//  Todoey
//
//  Created by Adarsha Upadhya on 12/12/18.
//  Copyright © 2018 Adarsha Upadhya. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListTableViewController: SwipeTableViewController {

    var realm = try! Realm()
    @IBOutlet weak var searchbaroutlet: UISearchBar!
    
    var todoListItems:Results<Item>?
    
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    
    let datafielPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(datafielPath)
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = selectedCategory!.name
        if let color = selectedCategory?.cellBackgroundColor{
            
            guard let navbar = navigationController?.navigationBar else{
                return
            }
            if let navBarColor = UIColor(hexString: color){
                
                navbar.barTintColor = navBarColor
                navbar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:ContrastColorOf(navBarColor, returnFlat: true)]
                
                searchbaroutlet.barTintColor = navBarColor
            }
        }
    }
    
    //to avoide overlapping the current color on navbar on pressing back button into home screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let originalcolor = UIColor(hexString: "1D9B76") else{
            fatalError()
        }
        navigationController?.navigationBar.barTintColor = originalcolor
        navigationController?.navigationBar.tintColor = FlatWhite()
         navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:FlatWhite()]
        
    }
    
    
    func loadItems(){
        todoListItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        //update in realm
        if let item = todoListItems?[indexPath.row]{
            do{
                try realm.write {
                   realm.delete(item)
                }
            }catch{
                print("Error saving done status")
            }
        }
    }
}


extension ToDoListTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoListItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = todoListItems?[indexPath.row].title ?? "No items"
        
        if let color = UIColor(hexString: selectedCategory!.cellBackgroundColor)?.darken(byPercentage:  CGFloat(indexPath.row) / CGFloat((todoListItems!.count))){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        }
        
        
         cell.accessoryType = todoListItems?[indexPath.row].done == true ? .checkmark : .none
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //update in realm
        if let item = todoListItems?[indexPath.row]{
            do{
            try realm.write {
                item.done = !item.done
                }
            }catch{
                print("Error saving done status")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
   
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
        var localTextField = UITextField()
        let alert = UIAlertController(title: "Add new Today", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
            
                
                do{
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = localTextField.text!
                    newItem.createdDate = Date()
                    currentCategory.items.append(newItem)
                    }
                    
                }catch let error{
                    print(error.localizedDescription)
                }
            }
            
            self.tableView.reloadData()
           
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Create new Item"
            localTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    
//    fileprivate func writeData(item:Item) {
//        do{
//           try realm.write {
//                realm.add(item)
//                }
//
//            }catch let error {
//                print("Error:\(error.localizedDescription)")
//            }
//            self.tableView.reloadData()
//        }
    }






extension ToDoListTableViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoListItems = todoListItems?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "createdDate", ascending: false)
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
        loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

