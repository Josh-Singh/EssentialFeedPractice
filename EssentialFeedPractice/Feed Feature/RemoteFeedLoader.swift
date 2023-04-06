//
//  RemoteFeedLoader.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://some-url.com")!)
    }
}
