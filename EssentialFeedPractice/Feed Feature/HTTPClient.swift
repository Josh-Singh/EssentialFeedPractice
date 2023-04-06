//
//  HTTPClient.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class HTTPClient {
    static var shared = HTTPClient()    // Global mutable state instead of singleton now bcuz let changed to var
    
    func get(from url: URL) {}
}
