//
//  ViewController.swift
//  Todolist
//
//  Created by MoonLight on 04/01/2022.
//

import UIKit
import CoreData
class TodoListViewController: UITableViewController {
    var itemArr = [Item]()
    var selectCategory : Category? {
        didSet{
            loadItems()
        }
    }
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArr[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(itemArr[indexPath.row])
        itemArr.remove(at: indexPath.row)
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)

    }
    //MARK: - Add new Items
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Thêm mới mục cần làm", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Thêm mới mục", style: .default) { [self] action in
            //what will happen once the user clicks and Add Item button on our UIAlert
    
            let  newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCate = self.selectCategory
            self.itemArr.append(newItem)
            
            self.saveItems()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default) { action in
            print("Cancel")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Input name of Todolist Item"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context,\(error)")
        }
        self.tableView.reloadData()
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        let catePredicate = NSPredicate(format: "parentCate.name MATCHES %@",selectCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catePredicate, addtionalPredicate])
        } else {
            request.predicate = catePredicate
        }
        
        do {
            itemArr = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        self.tableView.reloadData()
    }
    
}
//MARK: - Search bar methods
extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request, predicate: predicate)
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

