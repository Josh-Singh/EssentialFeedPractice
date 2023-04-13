//
//  HTTPClient.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

public typealias HTTPClientResult = Result<(Data, HTTPURLResponse), Error>

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> ())
}
