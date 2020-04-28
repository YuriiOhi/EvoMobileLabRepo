//
//  EntryViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/18.
//  Copyright © 2020 Yurii. All rights reserved.
//
import UIKit

enum State {
    case create, display, edit
}
// Notes Adding and Saving VC
protocol NoteDelegate: AnyObject {
    func createNote(title: String, text: String, creationStamp: Date, uuidString: UUID)
    func updateNote(title: String, text: String)
}
class CreateNoteViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    
    public var noteTitle: String = ""
    public var noteText: String = ""
        
    weak var noteDelegate: NoteDelegate?
    
    var currentState: State = .create
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIWithState(state: currentState)
    }
    
    @objc func didTapNewNote() {
        if let title = titleField.text, !title.isEmpty, let text = noteField.text, !text.isEmpty {
            noteDelegate!.createNote(title: title, text: text, creationStamp: Date(), uuidString: UUID())
        }
    }
    
    func updateUIWithState(state: State) {
        
        switch state {
        case .create:
            prepareForCreate()
        case .display:
            prepareForDisplay()
        case .edit:
            prepareForEdit()
        }
    }
    
    func prepareForCreate() {
        title = "New Note"
        navigationItem.largeTitleDisplayMode = .never
        titleField.becomeFirstResponder()
        noteField.contentVerticalAlignment = .top
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapNewNote))
    }
    
    func prepareForDisplay() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Note"
        noteField.becomeFirstResponder()
        titleField.text = noteTitle
        noteField.text = noteText
        
        titleField.delegate = self
        noteField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: UIBarButtonItem.Style.plain,
                                                            target: self,
                                                            action: #selector(editScreenAction))
        
        titleField.borderStyle = UITextField.BorderStyle.none
        noteField.borderStyle = UITextField.BorderStyle.none
        
        titleField.textAlignment = .left
        noteField.textAlignment = .left
        
        titleField.contentVerticalAlignment = .center
        noteField.contentVerticalAlignment = .top
    }
    
    func prepareForEdit() {
    }
    
    @objc func editScreenAction(sender: UIBarButtonItem) {
        if currentState == .display  {
            currentState = .edit
            navigationItem.rightBarButtonItem?.title = "Done"
        }
        if currentState == .create {
            guard let titleText = titleField.text, !titleText.isEmpty, let descriptionText = noteField.text, !descriptionText.isEmpty else { return }
            noteDelegate!.createNote(title: titleText, text: descriptionText, creationStamp: Date(), uuidString: UUID())
        } else {
            guard let titleText = titleField.text, let descriptionText = noteField.text else { return }
            noteDelegate!.updateNote(title: titleText, text: descriptionText)
            navigationItem.rightBarButtonItem?.title = "Edit"
            currentState = .display
        }
    }
}

extension CreateNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //функция которая позволяет редактирование текстФилда
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return currentState != .display
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return currentState != .display
    }
    
}
