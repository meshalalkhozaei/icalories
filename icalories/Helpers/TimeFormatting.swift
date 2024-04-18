//
//  TimeFormatting.swift
//  icalories
//
//  Created by meshal alkhozaei on 18/09/1445 AH.
//

import Foundation

func calcTimeSince(date: Date) -> String {
    let minutes = Int(-date.timeIntervalSinceNow)/60
    let hours = minutes/60
    let days = hours/24
    
    if minutes < 120 {
        return "\(minutes) minutes ago"
    } else if minutes >= 120 && hours < 24 {
        return "\(hours) hours ago"
    } else {
        return "\(days) days ago"
    }
}
