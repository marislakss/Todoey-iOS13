//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import Chameleon
import ChameleonSwift
import RealmSwift
import UIKit

// Subclass TodoListViewController from UITableViewController.
// This allows to avoid implementing .self and IBOutlets, its all done for you.
class TodoListViewController: SwipeTableViewController {
    // MARK: - Properties

    // Create a collection of Results(container) to store Item objects.
    var todoItems: Results<Item>?

    // Initialise Realm.
    let realm = try! Realm()

    @IBOutlet var searchBar: UISearchBar!

    var selectedCategory: Category? {
        // didSet is a property observer.
        didSet {
            loadItems()
        }
    }

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Remove cell separators.
        tableView.separatorStyle = .none
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set title of the navigation bar to the name of the selected category.
        title = selectedCategory?.name
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
        // Set up a cell and inherit it from the SwipeTableViewCell class.
        let cell = super.tableView(
            tableView,
            cellForRowAt: indexPath
        )

        if let item = todoItems?[indexPath.row] {
            // Set cell text to itemArray at the current row.
            cell.textLabel?.text = item.title

            // Set cell background color to a gradient of the selected category color.
            if let colour = UIColor(hexString: selectedCategory!.color)?
                .darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = colour

                // Set cell text color to a contrasting color of the cell background color.
                cell.textLabel?.textColor = ContrastColorOf(
                    colour,
                    returnFlat: true
                )
            }

            // Set checkmark color to white.
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            cell.tintColor = UIColor.white

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

    // Handle user selection of table view cell.
    override func tableView(
        _: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        // Perform Update operation on Realm objects.
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // Delete item.
                    // realm.delete(item)

                    // Update item.
                    item.done = !(item.done)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }

        tableView.reloadData()

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

        // Create an alert action once user taps the Add Item button.
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
                        newItem.dateCreated = Date()
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

    // MARK: - Delete Data From Swipe

    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting todo item: \(error)")
            }
        }
    }
}

// MARK: - Search Bar Methods

// Extend TodoListViewController to conform to UISearchBarDelegate.
// This allows to implement searchBarSearchButtonClicked method.
extension TodoListViewController: UISearchBarDelegate {
    // Implement searchBarSearchButtonClicked method.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!)
            .sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()
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
