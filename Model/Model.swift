//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/26.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit

struct SingleNote {
    private(set) var text: String
    private(set) var creationTimeStamp: Date
    private(set) var editingTimeStamp: Date?
    private(set) var uuidString: UUID
}
