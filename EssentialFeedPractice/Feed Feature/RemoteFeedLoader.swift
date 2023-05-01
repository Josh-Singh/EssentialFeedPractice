//
//  RemoteFeedLoader.swift
//  EssentialFeedPractice
//
//  Created by Yash Singh on 4/6/23.
//

import Foundation

public final class RemoteFeedLoader: FeedLoader {
    private let client: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidCode
    }
    
//    public typealias FeedLoaderResult = Result<[FeedItem], Error>
    
    public init(client: HTTPClient, url: URL) {
        self.client = client
        self.url = url
    }
    
    public func load(completion: @escaping (LoadFeedResult) -> ()) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success((let data, let response)):
                if let mappedFeedItems = try? FeedItemsMapper.map(data: data, response: response) {
                    completion(.success(mappedFeedItems))
                } else {
                    completion(.failure(Error.invalidCode))
                }
            case .failure(_):
                completion(.failure(Error.connectivity))
            }
        }
    }
}
