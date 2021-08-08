//  Created by ikizey on 08.08.2021.


import UIKit


protocol ListDetailViewControllerDelegate: class {

    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController)
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishAdding checklist: Checklist)
    func listDetailViewController(
        _ controller: ListDetailViewController,
        didFinishEditing checklist: Checklist)
}


class ListDetailViewController: UITableViewController {

    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!

    weak var delegate: ListDetailViewControllerDelegate?

    var checklistToEdit: Checklist?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let checklistToEdit = checklistToEdit {
            title = "Edit Check"
            textField.text = checklistToEdit.name
            doneBarButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        textField.becomeFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }
}


// MARK: - Table View Delegates
extension ListDetailViewController {
    override func tableView(
        _ tableView: UITableView,
        willSelectRowAt indexPath: IndexPath
    ) -> IndexPath? {

        nil
    }
}


// MARK: - Text Field Delegates
extension ListDetailViewController: UITextFieldDelegate {

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {

        let oldText = textField.text!
        let stingRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stingRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
