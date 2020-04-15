//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/16.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var models: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Notes"
    }
        
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
            return
        }
        
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] noteTitle, noteText in // items in a capture list get the strong ref by default
            let entity = NSEntityDescription.entity(forEntityName: "SingleNote", in: self!.context)!
            let note = NSManagedObject(entity: entity, insertInto: self!.context)
            note.setValue(noteTitle, forKeyPath: "title")
            note.setValue(noteText, forKeyPath: "text")

            do {
                self!.models.append(note)
                try self!.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            self?.navigationController?.popToRootViewController(animated: true)
            self?.titleLabel.isHidden = true
            self?.tableView.isHidden = false
            self?.tableView.reloadData()//Reloads the rows and sections of the table view.
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        if let date = model.value(forKeyPath: "creationTimeStamp") as? Date {
            cell.timeLabel?.text = formattedDateString(date: date)
        } else {
            print("Corrupted timeLable")
        }
        if let date = model.value(forKeyPath: "creationTimeStamp") as? Date {
            cell.dateLabel?.text = formattedDateString(date: date)
        } else {
            print("Corrupted dateLabel")
        }
        cell.titleLabel?.text = model.value(forKeyPath: "title") as? String
        cell.noteLabel?.text = model.value(forKeyPath: "text") as? String
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDel = UIContextualAction(style: .normal, title: "Удалить") { (action, view, success) in print("Delete")
        }
        swipeDel.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        let conf = UISwipeActionsConfiguration(actions: [swipeDel])
        conf.performsFirstActionWithFullSwipe = false
        return UISwipeActionsConfiguration(actions: [swipeDel])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? DisplayNoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.value(forKeyPath: "title") as! String
        vc.noteText = model.value(forKeyPath: "text") as! String
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController {
    func formattedDateString(date: Date) -> String {
        var timeSince1970: Double
        timeSince1970 = date.timeIntervalSince1970
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeSince1970))
    }
    
    func formattedTimeString(date: Date) -> String {
        var timeSince1970: Double
        timeSince1970 = date.timeIntervalSince1970
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timeSince1970))
    }
}

