//
//  ViewController.swift
//  EvoMobileLab
//
//  Created by Yurii on 2020/3/16.
//  Copyright © 2020 Yurii. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var fetchedRC: NSFetchedResultsController<SingleNoteMO>!
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var models: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        title = "Notes"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let request = SingleNoteMO.fetchRequest() as NSFetchRequest<SingleNoteMO>
        let sort = NSSortDescriptor(key: #keyPath(SingleNoteMO.dateAndTimeStamp), ascending: true)
        request.sortDescriptors = [sort]
        do {
            fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedRC.delegate = self
            try fetchedRC.performFetch()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
        
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "new") as? CreateNoteViewController else {
            return
        }
        
        vc.title = "New Note"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { [weak self] noteTitle, noteText in // items in a capture list get the strong ref by default
           // self?.models.append(SingleNote(title: noteTitle, text: noteText, timeStamp: Date(), dateStamp: Date()))
            let entity = NSEntityDescription.entity(forEntityName: "SingleNote", in: self!.context)!
            
            let note = NSManagedObject(entity: entity, insertInto: self!.context)
            
            // 3
            note.setValue(noteTitle, forKeyPath: "title")
            
            // 4
            do {
                self!.models.append(note)
                try self!.context.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            self?.navigationController?.popToRootViewController(animated: true)
            self?.titleLabel.isHidden = true
            self?.tableView.isHidden = false

        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   //     guard let models = fetchedRC.fetchedObjects else { return 0 }
     //   return models.count
    return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
      /*
        cell.timeLabel?.text = formattedDateString(date: model.value(forKeyPath: "timeStamp") as! Date)
        //formattedTimeString(date: models[indexPath.row].timeStamp)
        
        cell.dateLabel?.text = model.dateStamp//formattedDateString(date: model.value(forKeyPath: "dateStamp") as! String)   // models[indexPath.row].dateStamp)
            
        cell.titleLabel?.text = model.value(forKeyPath: "title") as? String //models[indexPath.row].title
            */
        cell.noteLabel?.text = model.value(forKeyPath: "text") as? String
        //models[indexPath.row].text
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
        // Fetch Model
        let model = models[indexPath.row]
        // Show note controller
        guard let vc = storyboard?.instantiateViewController(identifier: "note") as? DisplayNoteViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Note"
        vc.noteTitle = model.value(forKeyPath: "title") as! String // model.title
        vc.noteText = model.value(forKeyPath: "text") as! String //model.text
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        let index = indexPath ?? (newIndexPath ?? nil)
        guard let cellIndex = index else { return }
        switch type {
        case .insert:
            tableView.insertRows(at: [cellIndex], with: .fade)
        default:
            break
        }
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
