//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Māris Lakšs on 13/08/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Chameleon
import ChameleonSwift
import SwipeCellKit
import UIKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    var cell: UITableViewCell?
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set row height.
        tableView.rowHeight = 60.0
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        ) as! SwipeTableViewCell
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(
        _: UITableView,
        editActionsForRowAt indexPath: IndexPath,
        for orientation: SwipeActionsOrientation
    ) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(
            style: .destructive,
            title: "Delete"
        ) { _, indexPath in
            // Handle action by updating model with deletion.
            self.updateModel(at: indexPath)
        }
        
        // Customize the action appearance.
        deleteAction.image = UIImage(systemName: "trash.fill")
        
        return [deleteAction]
    }
    
    func tableView(
        _: UITableView,
        editActionsOptionsForRowAt _: IndexPath,
        for _: SwipeActionsOrientation
    ) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
    }
    
    func updateModel(at _: IndexPath) {
        // Update data model.
    }
}
