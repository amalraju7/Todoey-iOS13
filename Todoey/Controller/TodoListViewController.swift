

import UIKit


class TodoListViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory:Category?{
        didSet{
            loadItems()
        }
    }
    var itemArray = [Item]()
    var defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TodoItemCell")
   
        
        loadItems()
//
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = items
//        }
        // Do any additional setup after loading the view.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New items
    
    @IBAction func AddItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle:.alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { [self] action in
            let newItem = Item(context: context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = selectedCategory
            
            
            self.itemArray.append(newItem)
            self.saveItems()
       
//
//       self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//            self.tableView.reloadData()
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
            
        }
        alert.addAction(action)
        present(
            alert, animated: true)
    }
    
    func saveItems(){
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//
//        }
//        catch{
//            print(error)
//        }
//
        do{
            try context.save()
        }
        catch{
            print(error)
        }
        
        tableView.reloadData()
        
        
    }
    func loadItems(){

//        if let data = try? Data(contentsOf: dataFilePath!){
//            let decoder = PropertyListDecoder()
//            do{
//                itemArray = try decoder.decode([Item].self, from: data)
//
//
//
//            }catch{
//                print(error)
//            }
//
//        }
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        request.predicate = predicate
        do{
        itemArray = try context.fetch(request)
        }catch{
            print(error)
        }
        tableView.reloadData()
    }

    

}

extension TodoListViewController: UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate1 = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        let predicate2 = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1,predicate2])
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.predicate = compoundPredicate
        request.sortDescriptors = [sortDescriptor]
        do{
            itemArray = try context.fetch(request)
        }
        catch{
            print(error)
        }
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

