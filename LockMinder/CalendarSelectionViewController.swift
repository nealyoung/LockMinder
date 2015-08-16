//
//  CalendarSelectionViewController.swift
//  LockMinder
//
//  Created by Nealon Young on 8/15/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

import Foundation
import EventKit

protocol CalendarSelectionViewControllerDelegate {
    func didSelectCalendar(calendar: EKCalendar)
}

class CalendarSelectionViewController: UITableViewController {
    let TableViewCellIdentifier = "TableViewCellIdentifier"
    
    var delegate: CalendarSelectionViewControllerDelegate?
    var selectedCalendar: EKCalendar?
    var calendars: [EKCalendar] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Reminder List", comment: "")
        self.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCellIdentifier)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.calendars.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let calendar = self.calendars[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier, forIndexPath: indexPath) as! TableViewCell
//        cell.selectionStyle = .None
        cell.textLabel?.text = calendar.title
        
        cell.accessoryType = calendar == self.selectedCalendar ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCalendar = self.calendars[indexPath.row]
        self.delegate?.didSelectCalendar(self.selectedCalendar!)
        self.tableView.reloadData()
        
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}