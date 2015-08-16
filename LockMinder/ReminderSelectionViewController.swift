//
//  ReminderSelectionViewController.swift
//  LockMinder
//
//  Created by Nealon Young on 8/6/15.
//  Copyright © 2015 Nealon Young. All rights reserved.
//

import EventKit
import NYAlertViewController
import SnapKit
import UIKit

class ReminderSelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let TableViewCellIdentifier = "TableViewCellIdentifier"
    let ReminderCellIdentifier = "ReminderCellIdentifier"
    
    let eventStore = EKEventStore()
    
    var tableView: UITableView!
    var previewButton: NYRoundRectButton!
    var reminders: [EKReminder]
    var selectedCalendar: EKCalendar = EKEventStore().defaultCalendarForNewReminders()
    var selectedReminders: Set<EKReminder>
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        reminders = []
        selectedReminders = []
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        reminders = []
        selectedReminders = []
        
        super.init(coder: aDecoder)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: animated)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("LockMinder", comment: "")
    
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: TableViewCellIdentifier)
        self.tableView.registerClass(ReminderTableViewCell.self, forCellReuseIdentifier: ReminderCellIdentifier)
        self.view.addSubview(self.tableView)
        
        var previewButtonBackgroundView = UIView()
        previewButtonBackgroundView.setTranslatesAutoresizingMaskIntoConstraints(false)
        previewButtonBackgroundView.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        self.view.addSubview(previewButtonBackgroundView)
        
        var previewButtonBackgroundTopBorderView = UIView()
        previewButtonBackgroundTopBorderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        previewButtonBackgroundTopBorderView.backgroundColor = UIColor(white: 0.7, alpha: 1.0)
        previewButtonBackgroundView.addSubview(previewButtonBackgroundTopBorderView)
        
        self.previewButton = NYRoundRectButton()
        self.previewButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.previewButton.addTarget(self, action: "previewButtonPressed", forControlEvents: .TouchUpInside)
        self.previewButton.titleLabel?.font = UIFont.mediumApplicationFont(18.0)
        self.previewButton.setTitle(NSLocalizedString("Preview Wallpaper", comment: ""), forState: .Normal)
        previewButtonBackgroundView.addSubview(self.previewButton)
        
        self.tableView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        
        previewButtonBackgroundView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(68)
            
            make.top.equalTo(self.tableView.snp_bottom)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        previewButtonBackgroundTopBorderView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(1.0 / UIScreen.mainScreen().scale)
            
            make.top.equalTo(previewButtonBackgroundView)
            make.leading.equalTo(previewButtonBackgroundView)
            make.trailing.equalTo(previewButtonBackgroundView)
        }
        
        self.previewButton.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(previewButtonBackgroundView).inset(UIEdgeInsetsMake(8, 8, 8, 8))
        }
        
        importReminders()
    }
    
    func previewButtonPressed() {
        if (self.selectedReminders.count == 0) {
            let alertViewController = NYAlertViewController()
            alertViewController.title = NSLocalizedString("No Reminders Selected", comment: "")
            alertViewController.message = NSLocalizedString("Select at least one reminder to generate a wallpaper", comment: "")
            alertViewController.titleFont = .mediumApplicationFont(18.0)
            alertViewController.messageFont = .applicationFont(17.0)
            alertViewController.cancelButtonTitleFont = .mediumApplicationFont(18.0)
            alertViewController.cancelButtonColor = .purpleApplicationColor()
            alertViewController.swipeDismissalGestureEnabled = true
            alertViewController.backgroundTapDismissalGestureEnabled = true
            let action = NYAlertAction(
                title: "Done",
                style: .Cancel,
                handler: { (action: NYAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            )
            
            alertViewController.addAction(action)
            
            self.presentViewController(alertViewController, animated: true, completion: nil)
        } else {
            let image = ImageGenerator.generateImage(UIImage(), reminders: Array(selectedReminders))
            let previewViewController = ImagePreviewViewController()
            previewViewController.image = image
            
            self.presentViewController(previewViewController, animated: true, completion: nil)
        }
    }
    
    private func createSampleReminders() {
        var completedRemindersPredicate = self.eventStore.predicateForCompletedRemindersWithCompletionDateStarting(nil, ending: nil, calendars: [self.selectedCalendar])
        self.eventStore.fetchRemindersMatchingPredicate(completedRemindersPredicate, completion: { (reminders: [AnyObject]!) -> Void in
            if let reminders = reminders as? [EKReminder] {
                for reminder in reminders {
                    self.eventStore.removeReminder(reminder, commit: true, error: nil)
                }
            }
            
            let reminder1 = EKReminder(eventStore: self.eventStore)
            reminder1.title = "Buy milk"
            self.eventStore.saveReminder(reminder1, commit: true, error: nil)
            
            let reminder2 = EKReminder(eventStore: self.eventStore)
            reminder2.title = "Pay water bill"
            self.eventStore.saveReminder(reminder2, commit: true, error: nil)
            
            let reminder3 = EKReminder(eventStore: self.eventStore)
            reminder3.title = "Pick up dry cleaning"
            self.eventStore.saveReminder(reminder3, commit: true, error: nil)
            
            self.reminders = [reminder1, reminder2, reminder3]
            
            self.tableView.reloadData()
        })
    }
    
    private func importReminders() {
//        createSampleReminders()
//        return
        
        let defaultRemindersCalendar = self.eventStore.defaultCalendarForNewReminders()

        ReminderLoader.importReminders(defaultRemindersCalendar) { (result: [EKReminder]?) -> Void in
            if let reminders = result {
                self.reminders = reminders
                self.tableView.reloadData()
            } else {
                let alertViewController = NYAlertViewController()
                alertViewController.title = NSLocalizedString("Reminder Access Declined", comment: "")
                alertViewController.message = NSLocalizedString("Use the Settings app to allow LockMinder access to your reminders", comment: "")
                alertViewController.titleFont = .mediumApplicationFont(17.0)
                alertViewController.messageFont = .applicationFont(17.0)
                alertViewController.cancelButtonColor = .purpleApplicationColor()
                alertViewController.swipeDismissalGestureEnabled = true
                alertViewController.backgroundTapDismissalGestureEnabled = true
                let action = NYAlertAction(
                    title: "Done",
                    style: .Cancel,
                    handler: { (action: NYAlertAction!) -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                )
                
                alertViewController.addAction(action)
                
                self.presentViewController(alertViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        case 0:
            return 1
            
        case 1:
            return self.reminders.count
            
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.section) {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell;
            
            cell.accessoryType = .DisclosureIndicator
            cell.textLabel?.text = NSLocalizedString("Reminder List", comment: "")
            cell.detailTextLabel?.text = self.selectedCalendar.title
            
            return cell;
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(ReminderCellIdentifier, forIndexPath: indexPath) as! ReminderTableViewCell;
            
            let reminder = self.reminders[indexPath.row]
            
            cell.checkmarkView.selected = self.selectedReminders.contains(reminder)
            cell.reminderLabel.text = reminder.title
            return cell;
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 48.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch (section) {
        case 1:
            let headerLabel = UILabel()
            headerLabel.textColor = UIColor(white: 0.16, alpha: 1.0)
            headerLabel.font = UIFont.applicationFont(15.0)
            headerLabel.textAlignment = .Center
            
            if (self.reminders.count > 0) {
                headerLabel.text = NSLocalizedString("Select reminders to appear on your wallpaper", comment: "")
            } else {
                headerLabel.text = NSLocalizedString("No reminders", comment: "")
            }
            
            return headerLabel
            
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch (section) {
        case 1:
            return 44.0
            
        default:
            return 0.0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
        case 0:
            return
            
        default:
            let selectedReminder = self.reminders[indexPath.row]
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! ReminderTableViewCell
            
            if (self.selectedReminders.contains(selectedReminder)) {
                self.selectedReminders.remove(selectedReminder)
                cell.checkmarkView.setSelected(false, animated: true)
            } else {
                self.selectedReminders.insert(selectedReminder)
                cell.checkmarkView.setSelected(true, animated: true)
            }
        }
    }
}
