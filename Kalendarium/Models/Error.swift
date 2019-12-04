//
//  Error.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/2/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Foundation

enum PlatformError: Error, CustomStringConvertible {
    case passthroughSystem(systemError: Error)
    case custom(message: String)
    
    var description: String {
        switch self {
        case .passthroughSystem(let systemError): return systemError.localizedDescription
        case .custom(let message): return message
        }
    }
}
