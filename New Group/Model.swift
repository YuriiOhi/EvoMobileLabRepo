//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/26.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit

struct SingleNote {
    private (set) var noteTitle: String
    private (set) var noteText: String
    private (set) var noteTimeStamp: String
    private (set) var uuidString: String

    init(noteTitle: String, noteText: String, noteTimeStamp: String, uuidString: String) {
        self.noteTitle = noteTitle
        self.noteText = noteText
        self.noteTimeStamp = noteTimeStamp
        self.uuidString = uuidString
    }
}
