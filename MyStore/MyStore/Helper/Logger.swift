//
//  Logger.swift
//  MyStore
//
//  Created by Samuelabraham D on 25/07/24.
//

import Foundation

/// A utility class for logging messages to the console.
public class Logger {
    
    /// Logs the given object to the console if logging is enabled.
    ///
    /// - Parameter object: The object to log.
    public class func log<T>(_ object: T) {
        #if DEBUG
        print(object)
        #endif
    }
}
