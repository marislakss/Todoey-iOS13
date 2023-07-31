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

    // Create an array of type Item.
    var itemArray = [Item]()

    // Create path to user defaults file.
    let dataFilePath = FileManager.default.urls(
        for: .documentDirectory,
        in: .userDomainMask
    ).first?.appendingPathComponent("Items.plist")

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

//        // Print path to Items.plist file.
//        print(dataFilePath)

        loadItems()
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

//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        // NOTE: you can replace if else statement with a single line of code.
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done

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
            // Create newItem constant and initialize it as Item class.
            let newItem = Item()
            // Set title property.
            // You can force unwrap textField.text because you know it will never be nil.
            newItem.title = textField.text!

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
        // Create an instance of encoder.
        let encoder = PropertyListEncoder()

        do {
            // Encode item array.
            let data = try encoder.encode(itemArray)
            // Write data to dataFilePath.
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        // Reload table view.
        tableView.reloadData()
    }

    func loadItems() {
        // Check if dataFilePath exists.
        if let data = try? Data(contentsOf: dataFilePath!) {
            // Create an instance of decoder.
            let decoder = PropertyListDecoder()
            do {
                // Decode data.
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
}
