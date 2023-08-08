//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import CoreData
import UIKit

// Subclass TodoListViewController from UITableViewController.
// This allows to avoid implementing .self and IBOutlets, its all done for you.
class TodoListViewController: UITableViewController {
    // MARK: - Properties

    // Create an array of type Item.
    var itemArray = [Item]()

    var selectedCategory: Category? {
        // didSet is a property observer.
        didSet {
            loadItems()
        }
    }

    // Get access to AppDelegate as an object.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        itemArray.count
    }

    // Create cells in table view.
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        let item = itemArray[indexPath.row]

        // Set cell text to itemArray at the current row.
        cell.textLabel?.text = item.title

        // Using Ternary operator ==>
        // value = condition ? valueIFTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }

    // MARK: - TableView Delegate Methods

    /// Handle user interaction with table view.

    // Handle user selection of table view cell.
    override func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // NOTE: Here true turns to false and false turns to true.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

        // Commit current state of context to persistent container.
        saveItems()

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
            // What will happen once the user clicks the Add Item button on our UIAlert.

            let newItem = Item(context: self.context)
            // Set title property.
            // You can force unwrap textField.text because you know it will never be nil.
            newItem.title = textField.text!
            // Set done property.
            newItem.done = false
            // Set parent category.
            newItem.parentCategory = self.selectedCategory

            // Append new item to item array.
            self.itemArray.append(newItem)

            self.saveItems()
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

    func saveItems() {
        do {
            // Save data to context.
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        // Reload table view.
        tableView.reloadData()
    }

    func loadItems(
        with request: NSFetchRequest<Item> = Item.fetchRequest(),
        predicate: NSPredicate? = nil
    ) {
        // Create a predicate.
        // Create a query to search for items that belong to the selected category.
        let categoryPredicate = NSPredicate(
            format: "parentCategory.name MATCHES %@",
            selectedCategory!.name!
        )

        // Create a request.
        // if else is used to avoid force unwrapping predicate.
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(
                andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate]
            )
        } else {
            request.predicate = categoryPredicate
        }

        // Create a sort descriptor.
        // Sort items in ascending order by title.
        request.sortDescriptors = [NSSortDescriptor(
            key: "title",
            ascending: true
        )]

        do {
            // Fetch data from context.
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        // Reload table view.
        tableView.reloadData()
    }
}

// MARK: - Search Bar Methods

// Extend TodoListViewController to conform to UISearchBarDelegate.
// This allows to implement searchBarSearchButtonClicked method.
extension TodoListViewController: UISearchBarDelegate {
    // Implement searchBarSearchButtonClicked method.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Create a fetch request.
        let request: NSFetchRequest<Item> = Item.fetchRequest()

        // Create a predicate.
        // Create a query to search for items that contain the search bar text.
        let predicate = NSPredicate(
            format: "title CONTAINS[cd] %@",
            searchBar.text!
        )

        // Create a sort descriptor.
        // Sort items in ascending order by title.
        request.sortDescriptors = [NSSortDescriptor(
            key: "title",
            ascending: true
        )]

        // Call loadItems method with request parameter.
        loadItems(with: request, predicate: predicate)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange _: String) {
        if searchBar.text?.isEmpty == true {
            loadItems()

            // Dispatch queue.
            DispatchQueue.main.async {
                // Dismiss keyboard and cursor.
                searchBar.resignFirstResponder()
            }
        }
    }
}
