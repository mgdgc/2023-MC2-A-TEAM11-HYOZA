//
//  NSSortDescriptorExtension.swift
//  Hyoza
//
//  Created by sei on 2023/05/15.
//

import Foundation

extension NSSortDescriptor {
    static func byTimestamp(ascending: Bool) -> NSSortDescriptor {
        NSSortDescriptor(keyPath: \Question.timestamp, ascending: ascending)
    }
}
