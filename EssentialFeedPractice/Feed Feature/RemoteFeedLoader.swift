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
        case invalidCode
    }
    
    public typealias FeedLoaderResult = Result<[FeedItem], Error>
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (FeedLoaderResult) -> ()) {
        // Default closure to make sure tests that don't test error case don't break
        client.get(from: url) { [weak self] result in
            switch result {
            case .success(_):
                completion(.failure(.invalidCode))    // Commenting this out and adding `break` here simulates the 200 response with invalid json case
            case .failure(_):
                completion(.failure(.connectivity))
            }
        }
    }
}
