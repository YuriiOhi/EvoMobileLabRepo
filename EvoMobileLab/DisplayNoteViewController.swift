//
//  NoteViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/18.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
// Saved Note VC
class DisplayNoteViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var noteLabel: UITextField!
    
    public var noteTitle: String = ""
    public var noteText: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = noteTitle
        noteLabel.text = noteText
        
        noteLabel.becomeFirstResponder()
        noteLabel.delegate = self
        titleLabel.delegate = self
        titleLabel.borderStyle = UITextField.BorderStyle.none
        noteLabel.borderStyle = UITextField.BorderStyle.none
        noteLabel.textAlignment = .left
        noteLabel.contentVerticalAlignment = .top
        
        let editButton = UIBarButtonItem(title: "Edit",
                                         style: .done,
                                         target: self,
                                         action: #selector(didTapEditNote))
        let shareButton = UIBarButtonItem(title: "Share",
                                          style: .done,
                                          target: self,
                                          action: #selector(didTapShareNote))
        
        navigationItem.rightBarButtonItems = [editButton, shareButton]
    }
    
    @objc func didTapEditNote() {
       
    }
    @objc func didTapShareNote() {
        print("share")
    }
}

extension DisplayNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

