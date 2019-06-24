//
//  DateStringTransformer.swift
//  GithubIssueViewer
//
//  Created by Udit on 23/06/19.
//  Copyright © 2019 iOSDemo. All rights reserved.
//

import Foundation
import ObjectMapper

/**
 Transformer used to parse date string to Date object and reverse
 */
class DateStringTransformer: TransformType {
    var inputFormat: String
    public typealias Object = Date
    public typealias JSON = String
    
    public init(inputFormat: String = "yyyy-MM-dd'T'HH:mm:ss'Z'") {
        self.inputFormat = inputFormat
    }
    
    func transformFromJSON(_ value: Any?) -> Object? {
        if let stringValue = value as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            let date = dateFormatter.date(from: stringValue)
            return date
        }
        return nil
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        if let dateValue = value {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = inputFormat
            let string = dateFormatter.string(from: dateValue)
            return string
        }
        return nil
    }
}

