//
//  CheckListViewController.swift
//  Checklists
//
//  Created by PrincePhoenix on 07.08.2021.
//

import UIKit

class CheckListViewController: UITableViewController {

    var items = [ChecklistItem]()
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChecklistItems()
    }

    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        label.text = item.checked ? "☑️" : ""
    }
    
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
}


// MARK: - Table View Data Source
extension CheckListViewController {
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        
        items.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Checklistitem",
            for: indexPath)
        
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }
}


// MARK: - Table View Delegate
extension CheckListViewController {
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        saveChecklistItems()
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
        saveChecklistItems()
    }
}


// MARK: - Navigation
extension CheckListViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(
                for: sender as! UITableViewCell) {
                
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
}


// MARK: - AddItemViewController Delegates
extension CheckListViewController: ItemDetailViewControllerDelegate {
    
    func addItemViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem
    ) {
        
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
    
    func addItemViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
    ) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        
        saveChecklistItems()
    }
}


// MARK: - Persistance
extension CheckListViewController {
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        return paths.first!
    }
    
    func dataFilePath() -> URL {
        documentDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode(
                    [ChecklistItem].self,
                    from: data)
            } catch {
                print("Error dencoding item array: \(error.localizedDescription)")
            }
        }
    }
}
