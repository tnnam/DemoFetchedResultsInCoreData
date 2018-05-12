//
//  MasterTableViewController.swift
//  DemoFetchedResultsInCoreData
//
//  Created by Tran Ngoc Nam on 5/12/18.
//  Copyright © 2018 Tran Ngoc Nam. All rights reserved.
//

import UIKit
import CoreData

class MasterTableViewController: UITableViewController {

    var fetchedResultsController = DataService.shared.fetchedResultsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController.delegate = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = fetchedResultsController.object(at: indexPath)
        configureCell(cell, with: person)
        return cell
    }

    func configureCell(_ cell: UITableViewCell, with person: Person) {
        cell.textLabel?.text = person.name
        cell.detailTextLabel?.text = String(person.age)
        cell.imageView?.image = person.photo as? UIImage
    }
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: Unwind - truyền data về màn master
    @IBAction func unwind(for unwindSegue: UIStoryboardSegue) {
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailController = segue.destination as? DetailViewController else { return}
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        detailController.person = fetchedResultsController.object(at: indexPath)
    }
}

extension MasterTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! Person)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! Person)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
