//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by PrincePhoenix on 08.08.2021.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func addItemViewControllerDidCancel(
        _ controller: ItemDetailViewController)
    
    func addItemViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem)
    
    func addItemViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            doneBarButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textField.becomeFirstResponder()
    }

    // MARK: - Table View Delegates
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {
        
        nil
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.addItemViewController(
                self,
                didFinishEditing: itemToEdit)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
    }
}

// MARK: - Text Field Delegates
extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String
    ) -> Bool {
        
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(
                            in: stringRange,
                            with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
