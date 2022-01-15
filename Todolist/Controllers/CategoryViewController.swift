//
//  CategoryViewController.swift
//  Todolist
//
//  Created by MoonLight on 14/01/2022.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var CateArr = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCate()
    }
    //MARK: - Add new Category
    @IBAction func addButtonPresses(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Thêm mới mục cần làm", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Thêm mới mục", style: .default) { [self] action in
            //what will happen once the user clicks and Add Item button on our UIAlert
    
            let  newCate = Category(context: self.context)
            newCate.name = textField.text!
            self.CateArr.append(newCate)
            
            self.saveCate()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .default) { action in
            print("Cancel")
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Todolist Category"
            textField = alertTextField
        }
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CateArr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CateCell = tableView.dequeueReusableCell(withIdentifier: "CateCell", for: indexPath)
        CateCell.textLabel?.text = CateArr[indexPath.row].name
        return CateCell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = CateArr[indexPath.row]
        }
    }
    
    //MARK: - TableView Manipulation Methods
    func saveCate() {
        do {
            try context.save()
        } catch {
            print("Error saving context,\(error)")
        }
        self.tableView.reloadData()
    }
    func loadCate() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            CateArr = try context.fetch(request)
        } catch {
            print("Error fetching data from context\(error)")
        }
        self.tableView.reloadData()
    }
}
