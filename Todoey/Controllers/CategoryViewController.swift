//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Māris Lakšs on 04/08/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import RealmSwift
import UIKit

class CategoryViewController: UITableViewController {
    // MARK: - Properties

    // Initialise Realm.
    let realm = try! Realm()

    var categories = [Category]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }

    // MARK: - TableView Datasource Methods

    override func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        categories.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }

    // MARK: - TableView Delegate Methods

    override func tableView(
        _: UITableView,
        didSelectRowAt _: IndexPath
    ) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }

    override func prepare(
        for segue: UIStoryboardSegue,
        sender _: Any?
    ) {
        let destinationVC = segue.destination as! TodoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    // MARK: - Data Manipulation Methods

    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }

        tableView.reloadData()
    }

    func loadCategories() {
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories: \(error)")
//        }
//
//        tableView.reloadData()
    }

    // MARK: - Add New Categories

    @IBAction func addButtonPressed(_: UIBarButtonItem) {
        var textField = UITextField()

        let alert = UIAlertController(
            title: "Add New Category",
            message: "",
            preferredStyle: .alert
        )

        let action = UIAlertAction(
            title: "Add",
            style: .default
        ) { _ in
            let newCategory = Category()

            newCategory.name = textField.text!

            self.categories.append(newCategory)

            self.save(category: newCategory)
        }

        alert.addAction(action)

        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }

        present(alert, animated: true, completion: nil)
    }
}
