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
    func createNote(text: String, creationStamp: Date, editingStamp: Date,  uuidString: UUID)
    func updateNote(text: String, editingStamp: Date)
}

class CreateNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var noteField: UITextView!
    public var noteText: String = ""
    weak var noteDelegate: NoteDelegate?
    var currentState: State = .create
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIWithState(state: currentState)
    }
    
    @objc func manageNotesActions(sender: UIBarButtonItem) {
        switch currentState {
        case .create:
            guard let descriptionText = noteField.text, !descriptionText.isEmpty else { return }
            noteDelegate!.createNote(text: descriptionText, creationStamp: Date(), editingStamp: Date(), uuidString: UUID())
        case .display:
            guard let descriptionText = noteField.text else { return }
            shareNote(text: descriptionText)
        case .edit:
            guard let descriptionText = noteField.text else { return }
            noteDelegate!.updateNote(text: descriptionText, editingStamp: Date())
            currentState = .display
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
        noteField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(manageNotesActions))
    }
    
    func prepareForDisplay() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Note"
        noteField.becomeFirstResponder()
        noteField.text = noteText
        
        noteField.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share",
                                                            style: UIBarButtonItem.Style.plain,
                                                            target: self,
                                                            action: #selector(manageNotesActions))
        noteField.textAlignment = .left
        }
    
    func prepareForEdit() {
        navigationItem.largeTitleDisplayMode = .never
        title = "Note"
        noteField.becomeFirstResponder()
        noteField.text = noteText
        noteField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done",
                                                            style: UIBarButtonItem.Style.plain,
                                                            target: self,
                                                            action: #selector(manageNotesActions))
        noteField.textAlignment = .left
    
    }
}

//extension CreateNoteViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    //функция которая позволяет редактирование текстФилда
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        return currentState != .display
//    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        return currentState != .display
//    }
//}

extension CreateNoteViewController {
    
    @objc func shareNote(text: String) {
        let shareText = "\(text)"
        if shareText != nil {
            let vc = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            present(vc, animated: true)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return currentState != .display
    }
    
}


