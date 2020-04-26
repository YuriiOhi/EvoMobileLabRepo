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
    func createNote(title: String, text: String, creationStamp: Date)
}
class CreateNoteViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var noteField: UITextField!
    public var completion: ((String, String, Date) -> Void)?
    
    weak var noteDelegate: NoteDelegate?
    
    var currentState: State = .create
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUIWithState(state: currentState)
    }
    
    @objc func didTapNewNote() {
        if let text = titleField.text, !text.isEmpty, !noteField.text!.isEmpty {
            completion?(text, noteField.text!, Date())
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
    }
    
    func prepareForEdit() {
    }
}


