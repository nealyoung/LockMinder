//
//  ReminderLoader.swift
//  LockMinder
//
//  Created by Nealon Young on 8/15/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//

import Foundation
import EventKit

// TODO: Implement after generic associated values are supported
//enum Result<T> {
//    case Success(T)
//    case Failure(String)
//}

class ReminderLoader {
    static let eventStore = EKEventStore()
    
    class func getDefaultReminderCalendar() -> EKCalendar {
        return eventStore.defaultCalendarForNewReminders()
    }
    
    class func getReminderCalendars() -> [EKCalendar] {
        return eventStore.calendarsForEntityType(EKEntityTypeReminder) as! [EKCalendar]
    }
    
    class func importReminders(calendar: EKCalendar, completion: (result: Optional<[EKReminder]>)->Void) {
        eventStore.requestAccessToEntityType(EKEntityTypeReminder) { (granted: Bool, error: NSError!) -> Void in
            if (!granted || error != nil) {
                completion(result: nil)
            } else {
                var completedRemindersPredicate = self.eventStore.predicateForIncompleteRemindersWithDueDateStarting(nil, ending: nil, calendars: [calendar])
                self.eventStore.fetchRemindersMatchingPredicate(completedRemindersPredicate) { (reminders: [AnyObject]!) -> Void in
                    if let reminders = reminders as? [EKReminder] {
                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
                            completion(result: reminders)
                        }
                    }
                }
            }
        }
    }
}
