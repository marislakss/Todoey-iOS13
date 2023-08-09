//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import RealmSwift
import UIKit

// Subclass TodoListViewController from UITableViewController.
// This allows to avoid implementing .self and IBOutlets, its all done for you.
class TodoListViewController: UITableViewController {
    // MARK: - Properties

    // Create a Results container to store Item objects.
    var todoItems: Results<Item>?

    // Initialise Realm.
    let realm = try! Realm()

    var selectedCategory: Category? {
        // didSet is a property observer.
        didSet {
            loadItems()
        }
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Obtain path to where data is stored.
        print(FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ))
    }

    // MARK: - TableView Datasource Methods

    // Create rows in table view.
    override func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        todoItems?.count ?? 1
    }

    // Create cells in table view.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if let item = todoItems?[indexPath.row] {
            // Set cell text to itemArray at the current row.
            cell.textLabel?.text = item.title

            // Using Ternary operator ==>
            // value = condition ? valueIFTrue : valueIfFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            // If there are no items in todoItems, set cell text to "No Items Added".
            cell.textLabel?.text = "No Items Added"
        }

        return cell
    }

    // MARK: - TableView Delegate Methods

    /// Handle user interaction with table view.

    // Handle user selection of table view cell.
    override func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
//        // NOTE: Here true turns to false and false turns to true.
//        todoItems?[indexPath.row].done = !(todoItems[indexPath.row].done)
//
//        // Commit current state of context to persistent container.
//        saveItems()

        // Deselect the selected cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }

    // MARK: - Add New Items

    @IBAction func addButtonPressed(_: UIBarButtonItem) {
        // Inside of IBAction scope create a local variable to store user input.
        var textField = UITextField() // Initialize an empty text field.

        // Create an alert.
        let alert = UIAlertController(
            title: "Add New Todoey Item",
            message: "",
            preferredStyle: .alert
        )

        // Create an alert action.
        let action = UIAlertAction(
            title: "Add Item",
            style: .default
            // Create a completion handler to handle user input.
        ) { _ in

            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        // newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }

            self.tableView.reloadData()
        }

        // Add a text field to the alert using closure syntax.
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }

        // Add the alert action to the alert.
        alert.addAction(action)

        // Present the alert.
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Model Manipulation Methods

    func loadItems() {
        todoItems = selectedCategory?.items.sorted(
            byKeyPath: "title",
            ascending: true
        )

        // Reload table view.
        tableView.reloadData()
    }
}

// MARK: - Search Bar Methods

// Extend TodoListViewController to conform to UISearchBarDelegate.
// This allows to implement searchBarSearchButtonClicked method.
// extension TodoListViewController: UISearchBarDelegate {
//    // Implement searchBarSearchButtonClicked method.
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Create a fetch request.
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        // Create a predicate.
//        // Create a query to search for items that contain the search bar text.
//        let predicate = NSPredicate(
//            format: "title CONTAINS[cd] %@",
//            searchBar.text!
//        )
//
//        // Create a sort descriptor.
//        // Sort items in ascending order by title.
//        request.sortDescriptors = [NSSortDescriptor(
//            key: "title",
//            ascending: true
//        )]
//
//        // Call loadItems method with request parameter.
//        loadItems(with: request, predicate: predicate)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
//        if searchBar.text?.isEmpty == true {
//            loadItems()
//
//            // Dispatch queue.
//            DispatchQueue.main.async {
//                // Dismiss keyboard and cursor.
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
// }
