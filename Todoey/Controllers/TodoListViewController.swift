//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

// Subclass TodoListViewController from UITableViewController.
// This allows to avoid implementing .self and IBOutlets, its all done for you.
class TodoListViewController: UITableViewController {
    // MARK: - Properties

    var itemArray = [Item]()
    // Hard coded array of strings to populate table view cells with dummy data.
    // ["Find motivation 🤑", "Keep learning 🤓", "Destroy my boss 😈", "Cuddle my son 🤗"]

    // Create User defaults
    let defaults = UserDefaults.standard

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create an array of item objects.
        let newItem = Item()
        newItem.title = "Find motivation 🤑"
        itemArray.append(newItem)

        let newItem2 = Item()
        newItem2.title = "Keep learning 🤓"
        itemArray.append(newItem2)

        let newItem3 = Item()
        newItem3.title = "Cuddle my son 🤗"
        itemArray.append(newItem3)

        // Load saved data from user defaults making it optional array of Strings.
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
            // Assign items to itemArray.
            itemArray = items
        }
    }

    // MARK: - TableView Datasource Methods

    /**
      Create sections in table view.
     **/

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

//        if item.done == true {
//            // Add checkmark.
//            cell.accessoryType = .checkmark
//        } else {
//            // Remove checkmark.
//            cell.accessoryType = .none
//        }

        // Above code can be shortened using Ternary operator ==>
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
//        // Print the selected cell.
//        print(itemArray[indexPath.row])

        // NOTE: you can replace if else statement below with a single line of code.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }

        // Check if selected cell is already selected.
        // If so, remove checkmark.
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            // Remove checkmark.
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            // Else, add checkmark.
        } else {
            // Add checkmark.
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
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

        // Create an alert action.
        let action = UIAlertAction(
            title: "Add Item",
            style: .default
            // Create a completion handler to handle user input.
        ) { _ in
            // What will happen once the user clicks the Add Item button on our UIAlert.
            // Create newItem constant and initialize it as Item class.
            let newItem = Item()
            // Set title property.
            // You can force unwrap textField.text because you know it will never be nil.
            newItem.title = textField.text!

            // Append new item to item array.
            self.itemArray.append(newItem)

            // Store item in user defaults using TodoListArray key.
            self.defaults.set(self.itemArray, forKey: "TodoListArray")

            // Reload table view data.
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
}
