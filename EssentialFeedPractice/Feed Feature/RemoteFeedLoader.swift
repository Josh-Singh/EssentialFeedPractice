//
//  RemoteFeedLoader.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

public final class RemoteFeedLoader {
    private let client: HTTPClient
    private let url: URL
    public enum Error: Swift.Error {
        case connectivity
    }
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (Error) -> ()) {
        // Default closure to make sure tests that don't test error case don't break
        client.get(from: url) { [weak self] error in
            completion(.connectivity)
        }
    }
}
