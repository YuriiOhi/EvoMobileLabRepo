//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/16.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIApplicationDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var isExsisting = false
    var models: [NSManagedObject] = []
    //loadView 1st
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Notes"
        initialLoad()
    }
    
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
            return
        }
        
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] noteTitle, noteText, noteDate in
            let entity = NSEntityDescription.entity(forEntityName: "SingleNote", in: self!.context)!
            let note = NSManagedObject(entity: entity, insertInto: self!.context)
            note.setValue(noteTitle, forKeyPath: "title")
            note.setValue(noteText, forKeyPath: "text")
            note.setValue(noteDate, forKey: "creationTimeStamp")
            do {
                self!.models.append(note)
                try self!.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self?.navigationController?.popToRootViewController(animated: true)
            self?.titleLabel.isHidden = true
            self?.tableView.isHidden = false
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        if let date = model.value(forKeyPath: "creationTimeStamp") as? Date {
            cell.timeLabel?.text = formattedTimeString(date: date)
            cell.dateLabel?.text = formattedDateString(date: date)
        } else {
            print("Corrupted dateLabel again")
        }
        cell.titleLabel?.text = model.value(forKeyPath: "title") as? String
        cell.noteLabel?.text = model.value(forKeyPath: "text") as? String
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //if editingStyle == UITableViewCell.EditingStyle.delete {
            //let entity = NSEntityDescription.entity(forEntityName: "SingleNote", in: self.context)!
           // let note = NSManagedObject(entity: entity, insertInto: self.context)
            guard let noteToRemove = models[indexPath.row] as? SingleNoteMO, editingStyle == .delete else {
                return
            }
            context.delete(noteToRemove)
            (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
            //self.tableView.deleteRows(at: [indexPath], with: .automatic)

            do {
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SingleNote")
                models = try context.fetch(fetchRequest)
                try context.save()
                tableView.reloadData()
                tableView.isHidden = false
                
                } catch let error as NSError {
                    print("Could not fetch. \(error), \(error.userInfo)")
            }
        //} else if editingStyle == .insert {
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    /*func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let swipeDel = UIContextualAction(style: .normal, title: "Удалить") { (action, view, success) in print("Delete")
        }
        swipeDel.backgroundColor = .red
        let conf = UISwipeActionsConfiguration(actions: [swipeDel])
        conf.performsFirstActionWithFullSwipe = false
        return UISwipeActionsConfiguration(actions: [swipeDel])
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.row]
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
    
    func initialLoad() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "SingleNote")
        do {
            models = try context.fetch(fetchRequest)
            tableView.reloadData()
            tableView.isHidden = false
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}


