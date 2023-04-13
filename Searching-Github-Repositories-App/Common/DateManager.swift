//
//  DateManager.swift
//  Searching-Github-Repositories-App
//
//  Created by Apple on 2022/11/23.
//

import Foundation

struct DateManager {
    static func updatedDateString(dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        
        let updatedDateFormatter = DateFormatter()
        updatedDateFormatter.dateFormat = "MMM d, y"
        let updatedDateString = updatedDateFormatter.string(from: date)
        
        return updatedDateString
    }
}
