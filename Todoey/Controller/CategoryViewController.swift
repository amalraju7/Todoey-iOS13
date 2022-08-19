//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Amal Raju on 19/08/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categories = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()

      loadCategories()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination =  segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destination.selectedCategory = categories[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CategoryToItems", sender: self)
    }

    @IBAction func addCategoryPressed(_ sender: Any) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add ", style: .default) { action in
            var newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categories.append(newCategory)
            self.saveCategories()
            
        }
        alert.addAction(alertAction)
        alert.addTextField { alertTextField in
            textField = alertTextField
        }
        present(alert, animated: true)
    }
    
    func saveCategories(){
        do{
           try context.save()
        }catch{
            print(error)
        }
        tableView.reloadData()
       
    }
    
    
    
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories = try context.fetch(request)
        }
        catch{
            print(error)
        }
       
        
    }
    

}
