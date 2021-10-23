//
//  DateFormat.swift
//  SimpList
//
//  Created by kazunari.ueeda on 2021/04/04.
//

import SwiftUI

class DateFormat {
    @Environment(\.timeZone) var timeZone
    
    func formattedDateForUserData(inputDate: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        dateFormat.dateFormat = "yyyy/M/d E HH:mm"
        dateFormat.timeZone = timeZone
        let dateString = dateFormat.string(from: inputDate)
        
        return dateString
    }

    func formattedDateForDisplayItem(inputDate: String) -> Date {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        dateFormat.dateFormat = "yyyy-MM-dd E"
        dateFormat.timeZone = timeZone
        let date = dateFormat.date(from: inputDate)
        
        return (date)!
    }
    
    func formattedDateForHeader() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateStyle = .medium
        dateFormat.timeStyle = .medium
        
        if TimeZone(identifier: "America/Halifax") == timeZone {
            dateFormat.dateFormat = "E MM-dd-yyyy"
        } else {
            dateFormat.dateFormat = "yyyy-MM-dd E"
        }
        
        dateFormat.timeZone = timeZone
        let dateString = dateFormat.string(from: Date())
        
        return dateString
    }
}
